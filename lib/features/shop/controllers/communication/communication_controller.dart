import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/permission_model.dart';
import 'package:xm_frontend/data/models/message_model.dart';
import 'package:xm_frontend/data/repositories/company/company_repository.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/contract/permission_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class CommunicationController extends TBaseController<MessageModel> {

  final Rx<ObjectModel?> selectedObject = Rx<ObjectModel?>(null);

  static CommunicationController get instance => Get.find();
  
  CommunicationController({ObjectModel? initialObject})
 {
    if (initialObject != null) {
      selectedObject.value = initialObject;
      selectedObjectId.value = initialObject.id!;
    }
  }
  final _objectRepo = Get.put(ObjectRepository());
  final _companyRepo = Get.put(CompanyRepository());
  final _permRepo = Get.put(PermissionRepository());

  /// Messages
  RxList<MessageModel> allMessages = <MessageModel>[].obs;
  RxList<MessageModel> filteredMessages = <MessageModel>[].obs;
 
  /// Filters & Selections
  /// -1 = All Objects
  RxInt selectedObjectId = RxInt(-1);

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;
  RxList<PermissionModel> contractsByObject = <PermissionModel>[].obs;
  RxList<int> selectedContractIds = <int>[].obs;
  RxList<String> selectedChannels = <String>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

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

  /// Computed: total recipients (sum of users)
  int get totalRecipients {
    if (contractsByObject.isEmpty) return 0;
    final list =
        selectedContractIds.isEmpty
            ? contractsByObject
            : contractsByObject
                .where((c) => selectedContractIds.contains(int.parse(c.id!)))
                .toList();
    return list.fold(0, (sum, c) => sum );
  }

  /// Computed: all contracts selected
  bool get allContractsSelected {
    return contractsByObject.isNotEmpty &&
        selectedContractIds.length == contractsByObject.length;
  }

  @override
  void onInit() {
    super.onInit();
    loadAllObjects();

    if (selectedObject.value != null) {
      selectedObjectId.value = selectedObject.value!.id!;
    }
    debugPrint("Communication Initiated: ${selectedObjectId.value}");

    filteredItems.clear();
    filterMessagesBySelectedObject();
    ever(selectedObject, (object) {
      debugPrint("Selected Object ID changed: ${object?.id}");
      filterMessagesBySelectedObject();
    });
  }

  Future<void> loadAllObjects() async {
    try {
      final list = await _objectRepo.getAllObjects();
      objectsList.assignAll(list);
    } catch (e) {
      debugPrint('Error loading objects: \$e');
    }
  }

  Future<void> loadPermissionsForObject(int objectId) async {
    try {
      selectedObjectId.value = objectId;
      selectedContractIds.clear();

      // fetch permissions by object   or all
      final list = await _permRepo.getAllPermissions();
      // auto-select all
      //selectedContractIds.assignAll(list.map((c) => int.parse(c.id!)));
    } catch (e) {
      debugPrint('Error loading contracts: \$e');
    }
  }

  /// Select object (or all)
  void selectObject(int objectId) {
    loadPermissionsForObject(objectId);
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
        contractsByObject.map((c) => int.parse(c.id!)),
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
      final msgs = await _objectRepo.fetchAllMessages();
/*
      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredMessages =
          msgs.where((message) {
            final objectIds = message.objectIds ?? [];
            return objectIds.any(
              (id) => userObjectRestrictions.contains(id),
            );
          }).toList();
*/
      allMessages.assignAll(msgs);
      debugPrint('Loaded messages: ${msgs.length}');
    } catch (e) {
      debugPrint('Error loading messages: \$e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> filterMessagesBySelectedObject() async
  {
    await loadMessages();
    debugPrint("Messages retrieved and Filtered: ${selectedObject.value?.id}");
    if (selectedObject.value == null) {
      filteredItems.assignAll(allMessages);
    }  else {
          final ownerCompanyId = selectedObject.value!.owner!;
          final objectCompanyId = selectedObject.value!.companyId!;
          final currentUserId = userController.user.value.id;

    filteredItems.assignAll(
      allMessages.where((msg) => msg.objectId == selectedObject.value!.id!
      &&
        (msg.companyId == ownerCompanyId || msg.senderId.toString() == currentUserId)
      ).toList(),
    );
    }
      selectedRows.value = List<bool>.filled(filteredItems.length, false);
      debugPrint("Messages retrieved and Filtered: ${filteredItems.value}");
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
    final createdByCompany = AuthenticationRepository.instance.currentUser!.companyId;
    // status‐ID: 3 == sent immediately, 2 == scheduled
    final statusId = scheduleNow.value ? 2 : 3;

    final payload = {
      'title': titleController.text.trim(),
      'content': contentController.text.trim(),
      'channels': selectedChannels.toList(),
      'scheduleAt': getScheduledDateTime()?.toIso8601String(), // or null
      'createdAt': DateTime.now().toIso8601String(),
      'created_by': createdBy,
      'status_id': statusId,
      'targets': targets,
      'id':selectedObjectId.value,
      'unique_id': DateTime.now().millisecondsSinceEpoch,
      'company_Id': createdByCompany
    };

    isLoading.value = true;
    try {
      await _objectRepo.sendMessage(payload);

      Get.back();


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
    final oId = selectedObjectId.value;
    // All contract IDs currently loaded
    final allContractIds =
        contractsByObject.map((c) => int.parse(c.id!)).toList();

    // 1) Single object AND all its contracts selected => object-level
    if (oId != -1 && selectedContractIds.length == allContractIds.length) {
      return [
        {'type': 'object', 'id': oId},
      ];
    }

    // 2) All objects AND all contracts selected => per-object  
    if (oId == -1 && selectedContractIds.length == allContractIds.length) {
      return objectsList
          .map((o) => {'type': 'object', 'id': o.id!})
          .toList();
    }

    // 3) Any subset of contracts selected => contract-level
    if (selectedContractIds.isNotEmpty) {
      return selectedContractIds
          .map((cid) => {'type': 'contract', 'id': cid})
          .toList();
    }

    // 4) All objects but no contracts selected => per-object
    if (oId == -1) {
      return objectsList
          .map((o) => {'type': 'object', 'id': o.id!})
          .toList();
    }

    // 5) Single object, no contract picks => object-level
    return [
      {'type': 'object', 'id': oId},
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
    int objectId,
    DateTime? start,
    DateTime? end,
  ) {
    selectedStatusId.value = statusId;

    selectedObjectFilterId.value = objectId;
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
    selectedObjectId.value = -1;
    contractsByObject.clear();
  }

  void clearFilters() {
    selectedStatusId.value = -1;
    selectedObjectFilterId.value = 0;
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
          final matchesObject =
              selectedObjectFilterId.value == 0 ||
              item.recipients.any(
                (recipient) =>
                    recipient.recipientId == selectedObjectFilterId.value,
              );

          final matchesStartDate =
              startDate.value == null ||
              item.createdAt!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.createdAt!.isBefore(endDate.value!);

          return matchesSearch &&
              matchesStatus &&
              matchesObject &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();
  
    filteredItems.assignAll(results);
  selectedRows.value = List<bool>.filled(filteredItems.length, false); // <-- Add 

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
            selectedObjectFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedObjectFilterId.value != 0) {
      final selectedObject = objectsList.firstWhereOrNull(
        (o) => o.id! == selectedObjectFilterId.value,
      );
      if (selectedObject != null) {
        filters.add({
          selectedObject.name.toString(): () {
            selectedObjectFilterId.value = 0;
            applyFilters(
              selectedStatusId.value,
              selectedObjectFilterId.value,
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
                selectedObjectFilterId.value,
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
                selectedObjectFilterId.value,
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
    final result = await _objectRepo.fetchAllMessages();
    final filteredMessages = result.toList();
/*
    final updatedUser = await userController.fetchUserDetails();
    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    // Normalize both lists to String for comparison
    final restrictionIds = userObjectRestrictions.map((e) => e.toString()).toSet();
    final filteredMessages = result.where((message) {
      final objectIds = (message.objectIds ?? []).map((e) => e.toString());
      return objectIds.any((id) => restrictionIds.contains(id));
    }).toList();
*/
    
    return filteredMessages;
  }

  @override
  bool containsSearchQuery(MessageModel item, String query) {
    return item.title!.toLowerCase().contains(query.toLowerCase()) ||
        (item.title?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }

  @override
  Future<bool> deleteItem(MessageModel item) async {
    return await _companyRepo.deleteCompanyMessage(int.parse(item.id));
  }
}
