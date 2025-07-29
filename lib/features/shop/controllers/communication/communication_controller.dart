import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/message_model.dart';
import 'package:xm_frontend/data/repositories/agency/agency_repository.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/data/repositories/contract/contract_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class CommunicationController extends TBaseController<MessageModel> {
  static CommunicationController get instance => Get.find();

  final _buildingRepo = Get.put(BuildingRepository());
  final _agencyRepo = Get.put(AgencyRepository());
  final _contractRepo = Get.put(ContractRepository());

  /// Messages
  RxList<MessageModel> allMessages = <MessageModel>[].obs;
  RxList<MessageModel> filteredMessages = <MessageModel>[].obs;

  /// Filters & Selections
  /// -1 = All Buildings
  RxInt selectedBuildingId = RxInt(-1);
  RxList<BuildingModel> buildingsList = <BuildingModel>[].obs;
  RxList<ContractModel> contractsByBuilding = <ContractModel>[].obs;
  RxList<int> selectedContractIds = <int>[].obs;
  RxList<String> selectedChannels = <String>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedBuildingFilterId = 0.obs; // 0 = All

  RxBool filtersApplied = false.obs; // Track if filters are applied

  RxBool loading = RxBool(false);

  /// Scheduling
  RxBool scheduleNow = RxBool(false);
  Rx<DateTime?> scheduledDate = Rx<DateTime?>(null);
  final TextEditingController scheduleController = TextEditingController();

  /// Message Form
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  // final List<String> availableChannels = ['push', 'email', 'sms'];
  final List<String> availableChannels = ['push'];
  RxBool isLoading = RxBool(false);

  final userController = Get.find<UserController>();

  /// Computed: total recipients (sum of tenants)
  int get totalRecipients {
    if (contractsByBuilding.isEmpty) return 0;
    final list =
        selectedContractIds.isEmpty
            ? contractsByBuilding
            : contractsByBuilding
                .where((c) => selectedContractIds.contains(int.parse(c.id!)))
                .toList();
    return list.fold(0, (sum, c) => sum + (c.tenantCount ?? 0));
  }

  /// Computed: all contracts selected
  bool get allContractsSelected {
    return contractsByBuilding.isNotEmpty &&
        selectedContractIds.length == contractsByBuilding.length;
  }

  @override
  void onInit() {
    super.onInit();
    loadAllBuildings();
    loadMessages();
  }

  Future<void> loadAllBuildings() async {
    try {
      final list = await _buildingRepo.getAllBuildings();
      buildingsList.assignAll(list);
    } catch (e) {
      debugPrint('Error loading buildings: \$e');
    }
  }

  Future<void> loadContractsForBuilding(int buildingId) async {
    try {
      selectedBuildingId.value = buildingId;
      selectedContractIds.clear();

      // fetch contracts by building or all
      final list =
          buildingId == -1
              ? await _contractRepo.getAllAgencyBuildingsContracts()
              : await _contractRepo.getContractsByBuildingId(buildingId);
      // only active
      list.removeWhere((c) => c.statusId != 1);
      contractsByBuilding.assignAll(list);

      // auto-select all
      selectedContractIds.assignAll(list.map((c) => int.parse(c.id!)));
    } catch (e) {
      debugPrint('Error loading contracts: \$e');
    }
  }

  /// Select building (or all)
  void selectBuilding(int buildingId) {
    loadContractsForBuilding(buildingId);
  }

  void toggleContractSelection(int contractId) {
    if (selectedContractIds.contains(contractId)) {
      selectedContractIds.remove(contractId);
    } else {
      selectedContractIds.add(contractId);
    }
  }

  void toggleAllContractsSelection(bool selectAll) {
    if (selectAll) {
      selectedContractIds.assignAll(
        contractsByBuilding.map((c) => int.parse(c.id!)),
      );
    } else {
      selectedContractIds.clear();
    }
  }

  void toggleChannel(String channel) {
    if (channel.contains('email') || channel.contains('sms')) {
      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_info'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_new_feature_coming_soon'),
      );
      return;
    }

    if (selectedChannels.contains(channel)) {
      selectedChannels.remove(channel);
    } else {
      selectedChannels.add(channel);
    }
  }

  Future<void> pickScheduleDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (time != null) {
        final dt = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        scheduledDate.value = dt;
        scheduleController.text = DateFormat('dd.MM.yyyy HH:mm').format(dt);
      }
    }
  }

  DateTime? getScheduledDateTime() =>
      scheduleNow.value ? scheduledDate.value : null;

  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      final msgs = await _agencyRepo.fetchAllAgencyMessages();

      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredMessages =
          msgs.where((message) {
            final buildingIds = message.buildingIds ?? [];
            return buildingIds.any(
              (id) => userBuildingRestrictions.contains(id),
            );
          }).toList();

      allMessages.assignAll(filteredMessages);
      filteredMessages.assignAll(filteredMessages);
    } catch (e) {
      debugPrint('Error loading messages: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitNewMessage() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedChannels.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'Validation',
        message: 'Select at least one channel.',
      );
      return;
    }

    // Build the JSON‐array for targets:
    final targets = buildTargets();

    debugPrint(targets.toString());

    // Derive createdBy from your auth repo:
    final createdBy = AuthenticationRepository.instance.currentUser!.id;

    // status‐ID: 3 == sent immediately, 2 == scheduled
    final statusId = scheduleNow.value ? 2 : 3;

    final payload = {
      'title': titleController.text.trim(),
      'content': contentController.text.trim(),
      'channels': selectedChannels.toList(),
      'scheduleAt': getScheduledDateTime()?.toIso8601String(), // or null
      'created_by': createdBy,
      'status_id': statusId,
      'targets': targets,
    };

    isLoading.value = true;
    try {
      await _agencyRepo.sendMessage(payload);

      Get.back();

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Message scheduled/sent successfully.',
      );
      clearMessageForm();
      refreshData(); // Reload messages
    } catch (e) {
      debugPrint('Error sending message: $e');
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to send message.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> buildTargets() {
    final bId = selectedBuildingId.value;
    // All contract IDs currently loaded
    final allContractIds =
        contractsByBuilding.map((c) => int.parse(c.id!)).toList();

    // 1) Single building AND all its contracts selected => building-level
    if (bId != -1 && selectedContractIds.length == allContractIds.length) {
      return [
        {'type': 'building', 'id': bId},
      ];
    }

    // 2) All buildings AND all contracts selected => per-building
    if (bId == -1 && selectedContractIds.length == allContractIds.length) {
      return buildingsList
          .map((b) => {'type': 'building', 'id': int.parse(b.id!)})
          .toList();
    }

    // 3) Any subset of contracts selected => contract-level
    if (selectedContractIds.isNotEmpty) {
      return selectedContractIds
          .map((cid) => {'type': 'contract', 'id': cid})
          .toList();
    }

    // 4) All buildings but no contracts selected => per-building
    if (bId == -1) {
      return buildingsList
          .map((b) => {'type': 'building', 'id': int.parse(b.id!)})
          .toList();
    }

    // 5) Single building, no contract picks => building-level
    return [
      {'type': 'building', 'id': bId},
    ];
  }

  Map<int, String> getTranslatedMessageStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getMessageStatusText(1),
      2: THelperFunctions.getMessageStatusText(2),
      3: THelperFunctions.getMessageStatusText(3),
    };
  }

  void applyFilters(
    int statusId,
    int buildingId,
    DateTime? start,
    DateTime? end,
  ) {
    selectedStatusId.value = statusId;

    selectedBuildingFilterId.value = buildingId;
    startDate.value = start;
    endDate.value = end;

    filterItemsWithSearch(searchTextController.text);
  }

  void clearMessageForm() {
    titleController.clear();
    contentController.clear();
    selectedContractIds.clear();
    selectedChannels.clear();
    scheduledDate.value = null;
    scheduleController.clear();
    scheduleNow.value = false;
    selectedBuildingId.value = -1;
    contractsByBuilding.clear();
  }

  void clearFilters() {
    selectedStatusId.value = -1;
    selectedBuildingFilterId.value = 0;
    startDate.value = null;
    endDate.value = null;
    searchTextController.clear();
    filterItemsWithSearch('');
  }

  void filterItemsWithSearch([String query = '']) {
    final results =
        allItems.where((item) {
          final matchesSearch = containsSearchQuery(item, query);

          final matchesStatus = _getStatusFilter(item.statusId);
          final matchesBuilding =
              selectedBuildingFilterId.value == 0 ||
              item.recipients.any(
                (recipient) =>
                    recipient.recipientId == selectedBuildingFilterId.value,
              );

          final matchesStartDate =
              startDate.value == null ||
              item.createdAt!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.createdAt!.isBefore(endDate.value!);

          return matchesSearch &&
              matchesStatus &&
              matchesBuilding &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);
  }

  bool _getStatusFilter(int? status) {
    return selectedStatusId.value == -1 || status == selectedStatusId.value;
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getMessageStatusText(selectedStatusId.value): () {
          selectedStatusId.value = -1;
          applyFilters(
            selectedStatusId.value,
            selectedBuildingFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedBuildingFilterId.value != 0) {
      final selectedBuilding = buildingsList.firstWhereOrNull(
        (b) => int.parse(b.id!) == selectedBuildingFilterId.value,
      );
      if (selectedBuilding != null) {
        filters.add({
          selectedBuilding.name.toString(): () {
            selectedBuildingFilterId.value = 0;
            applyFilters(
              selectedStatusId.value,
              selectedBuildingFilterId.value,
              startDate.value,
              endDate.value,
            );
          },
        });
      }
    }

    if (startDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_from")} ${THelperFunctions.getFormattedDate(startDate.value!)}':
            () {
              startDate.value = null;
              applyFilters(
                selectedStatusId.value,
                selectedBuildingFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    if (endDate.value != null) {
      filters.add({
        '${AppLocalization.of(Get.context!).translate("general_msgs.msg_until")} ${THelperFunctions.getFormattedDate(endDate.value!)}':
            () {
              endDate.value = null;
              applyFilters(
                selectedStatusId.value,
                selectedBuildingFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    return filters;
  }

  @override
  Future<List<MessageModel>> fetchItems() async {
    final result = await _agencyRepo.fetchAllAgencyMessages();

    final updatedUser = await userController.fetchUserDetails();

    final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

    // debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredMessages =
        result.where((message) {
          final buildingIds = message.buildingIds ?? [];
          return buildingIds.any((id) => userBuildingRestrictions.contains(id));
        }).toList();

    return filteredMessages;
  }

  @override
  bool containsSearchQuery(MessageModel item, String query) {
    return item.title!.toLowerCase().contains(query.toLowerCase()) ||
        (item.title?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }

  @override
  Future<bool> deleteItem(MessageModel item) async {
    return await _agencyRepo.deleteAgecyMessage(int.parse(item.id));
  }
}
