import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/organization_model.dart';
import 'package:xm_frontend/data/models/request_log_model.dart';
import 'package:xm_frontend/data/models/request_model.dart';
import 'package:xm_frontend/data/models/request_type_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/helpers/network_manager.dart';
import 'package:xm_frontend/utils/popups/full_screen_loader.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

enum RequestSourceType { contract, user, object, company }

class RequestController extends TBaseController<RequestModel> {
  static RequestController get instance => Get.find();

  // Store the original list of bookings (unchanged)
  RxList<RequestModel> allRequests = <RequestModel>[].obs;
  RxList<RequestModel> filteredRequests = <RequestModel>[].obs;

  // add list for request logs
  RxList<RequestLog> requestLogs = <RequestLog>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxInt totalRequests = 0.obs; // Total bookings count

  TextEditingController searchController =
      TextEditingController(); // For search functionality

  RxInt selectedStatusId = (-1).obs; // -1 means All

  RxList<RequestTypeModel> requestTypes = <RequestTypeModel>[].obs;
  RxList<RequestModel> allPendingRequests = <RequestModel>[].obs;

  RxInt selectedRequestTypeId = 0.obs; // 0 = All

  RxInt selectedServicerId = 0.obs;

  RxBool filtersApplied = false.obs; // Track if filters are applied

  final formKey = GlobalKey<FormState>();

  var loading = false.obs;

  final commentsController = TextEditingController();

  final commentsServicerController = TextEditingController();

  final RxInt selectedStatus = 1.obs;

  var totalPendingRequests = 0.obs; // Total bookings count

  var requestModel = RequestModel.empty().obs; // Make it observable

  final paginatedPage = 0.obs;

  final int? id;
  final RequestSourceType sourceType;

  RequestController({required this.sourceType, required this.id});

  final _objectRepository = Get.put(ObjectRepository());

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

  RxList<OrganizationModel> maintenanceServicersList =
      <OrganizationModel>[].obs;

  final userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadData(); // Load data when the controller is initialized
    loadAllObjects(); // Load all buildings
    loadAllMaintenanceServicers(); // Load all maintenance servicers
  }

  // Method to load data from UserRepository
  Future<void> loadData() async {
    try {
      List<RequestModel> requests;

      debugPrint('[$hashCode] Loading requests for $sourceType with ID: $id');

      switch (sourceType) {
        case RequestSourceType.contract:
          requests = await UserRepository.instance
              .fetchUserRequestsByContractId(id!);
          break;
        case RequestSourceType.user:
          requests = await UserRepository.instance
              .fetchUserRequestsByUserId(id!);
          break;
        case RequestSourceType.object:
          requests = await ObjectRepository.instance
              .fetchObjectRequestsByObjectId(id!);
          break;
        case RequestSourceType.company:
          requests =
              await ObjectRepository.instance
                  .fetchObjectsRequestsByCompanyId();
          break;
      }

      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredRequestsData =
          requests
              .where(
                (request) => userObjectRestrictions.contains(
                  int.parse(request.objectId.toString()),
                ),
              )
              .toList();

      allRequests.assignAll(filteredRequestsData);
      filteredRequests.assignAll(allRequests);
      allPendingRequests.assignAll(
        filteredRequestsData.where((r) => r.status == 1).toList(),
      );
      allPendingRequests.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      totalPendingRequests.value = allPendingRequests.length;
      totalRequests.value = filteredRequestsData.length;

      final valObjectId =
          allRequests.isNotEmpty ? allRequests.first.objectId : null;
      if (valObjectId != null) {
        final types = await ObjectRepository.instance.fetchRequestTypes(
          valObjectId,
        );
        requestTypes.assignAll(types);
      }

      // Preload translations for request types
      await _preloadTranslations(allRequests);
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();

      final updatedUser = await userController.fetchUserDetails();

      final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredObjects =
          result
              .where(
                (object) => userObjectRestrictions.contains(
                  int.parse(object.id.toString()),
                ),
              )
              .toList();

      objectsList.assignAll(filteredObjects);
    } catch (e) {
      //   Get.snackbar('Error', 'Failed to load buildings: $e');
    } finally {
      //  loading.value = false;
    }
  }

  void loadAllMaintenanceServicers() async {
    try {
      final result = await _objectRepository.getAllMaintenanceServicers();

      maintenanceServicersList.assignAll(result);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  Future<void> _preloadTranslations(List<RequestModel> requests) async {
    for (var request in requests) {
      await request.translateRequestType(); // Cache translation
    }
  }

  // Method to load request logs
  Future<void> loadRequestLogs(int requestId) async {
    try {
      final logs = await ObjectRepository.instance
          .fetchRequestLogsByRequestId(requestId);
      requestLogs.assignAll(logs); // Assign all fetched request logs

      debugPrint(
        'Loaded ${requestLogs.length} request logs for request ID: $requestId',
      );
    } catch (e) {
      debugPrint("Error loading requestlogs data: $e");
    }
  }

  Future<void> submitRequestUpdate(RequestModel request) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        // TFullScreenLoader.stopLoading();

        if (selectedStatus.value == 0) {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(
              Get.context!,
            ).translate('request_screen.error_please_select_a_status'),
          );
        }
        loading.value = false;
        return;
      }

      requestModel.value = request;

      debugPrint('Selected status: ${selectedStatus.value}');
      debugPrint('Comments: ${commentsController.text}');
      debugPrint('Request ID: ${request.id}');

      // Check if  selected status is not empty

      final isRequestUpdated = await UserRepository.instance
          .updateUserRequestStatus(
            int.parse(request.id!),
            selectedStatus.value,
            commentsController.text,
          );

      // Remove Loader
      loading.value = false;

      if (isRequestUpdated) {
        requestModel.value.status = selectedStatus.value;
        //  requestModel.value.description = commentsController.text;

        Get.back(result: requestModel.value);

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
        );

        // send a notification to the user
        await UserRepository.instance
            .createUserRequestNotificationByContractId(
              request.contractId,
              int.parse(request.id!),
              selectedStatus.value,
              request.ticketNumber.toString(),
            );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_failed'),
        );
      }

      update();
    } catch (e) {
      debugPrint('Error from catch submitContractUpdate: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> submitRequestAssign() async {
    Get.back(result: true);

    TLoaders.successSnackBar(
      title: AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_info'),
      message: AppLocalization.of(
        Get.context!,
      ).translate('general_msgs.msg_data_submitted'),
    );
    // try {
    // Start Loading
    //     loading.value = true;

    //   // Check Internet Connectivity
    //   final isConnected = await NetworkManager.instance.isConnected();
    //   if (!isConnected) {
    //     loading.value = false;
    //     return;
    //   }

    //   // Form Validation
    //   if (!formKey.currentState!.validate()) {
    //     // TFullScreenLoader.stopLoading();

    //     if (selectedStatus.value == 0) {
    //       TLoaders.errorSnackBar(
    //         title: AppLocalization.of(
    //           Get.context!,
    //         ).translate('general_msgs.msg_error'),
    //         message: AppLocalization.of(
    //           Get.context!,
    //         ).translate('request_screen.error_please_select_a_status'),
    //       );
    //     }
    //     loading.value = false;
    //     return;
    //   }

    //   requestModel.value = request;

    //   debugPrint('Selected status: ${selectedStatus.value}');
    //   debugPrint('Comments: ${commentsController.text}');
    //   debugPrint('Request ID: ${request.id}');

    //   // Check if  selected status is not empty

    //   final isRequestUpdated = await UserRepository.instance
    //       .updateTenantRequestStatus(
    //         int.parse(request.id!),
    //         selectedStatus.value,
    //         commentsController.text,
    //       );

    //   // Remove Loader
    //   loading.value = false;

    //   if (isRequestUpdated) {
    //     requestModel.value.status = selectedStatus.value;
    //     //  requestModel.value.description = commentsController.text;

    //     Get.back(result: requestModel.value);

    //     TLoaders.successSnackBar(
    //       title: AppLocalization.of(
    //         Get.context!,
    //       ).translate('general_msgs.msg_info'),
    //       message: AppLocalization.of(
    //         Get.context!,
    //       ).translate('general_msgs.msg_data_updated'),
    //     );

    //     // send a notification to the user
    //     await UserRepository.instance
    //         .createTenantRequestNotificationByContractId(
    //           request.contractId,
    //           int.parse(request.id!),
    //           selectedStatus.value,
    //           request.ticketNumber.toString(),
    //         );
    //   } else {
    //     TLoaders.errorSnackBar(
    //       title: AppLocalization.of(
    //         Get.context!,
    //       ).translate('general_msgs.msg_error'),
    //       message: AppLocalization.of(
    //         Get.context!,
    //       ).translate('general_msgs.msg_data_failed'),
    //     );
    //   }

    //   update();
    // } catch (e) {
    //   debugPrint('Error from catch submitContractUpdate: $e');
    //   loading.value = false;
    //   TFullScreenLoader.stopLoading();
    //   TLoaders.errorSnackBar(
    //     title: AppLocalization.of(
    //       Get.context!,
    //     ).translate('general_msgs.msg_error'),
    //     message: e.toString(),
    //   );
    // }
  }

  // Method to filter requests based on search query and filters
  void filterRequests(String query) {
    final filteredList =
        allRequests.where((request) {
          final matchesQuery = containsSearchQuery(request, query);
          final matchesStatus = _getStatusFilter(request.status);
          final matchesRequestType = _getRequestTypeFilter(
            request.requestTypeId,
          );
          final matchesStartDate =
              startDate.value == null ||
              request.createdAt?.isAfter(startDate.value!) == true;
          final matchesEndDate =
              endDate.value == null ||
              request.createdAt?.isBefore(endDate.value!) == true;

          final matchesObject =
              selectedObjectFilterId.value == 0 ||
              request.objectId == selectedObjectFilterId.value;

          return matchesQuery &&
              matchesStatus &&
              matchesRequestType &&
              matchesStartDate &&
              matchesEndDate &&
              matchesObject;
        }).toList();

    filteredRequests.assignAll(filteredList);
    filteredItems.assignAll(filteredList); // filtered items for paginated table

    // Reset pagination to page 0
    paginatedPage.value = 0;
    totalRequests.value = filteredList.length;

    update(); // Refresh observers/UI
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getStatusText(selectedStatusId.value): () {
          selectedStatusId.value = -1;
          applyFilters(
            selectedStatusId.value,
            selectedRequestTypeId.value,
            selectedObjectFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedRequestTypeId.value != 0) {
      final selectedType = requestTypes.firstWhereOrNull(
        (r) => r.id == selectedRequestTypeId.value,
      );
      if (selectedType != null) {
        filters.add({
          selectedType.name: () {
            selectedRequestTypeId.value = 0;
            applyFilters(
              selectedStatusId.value,
              selectedRequestTypeId.value,
              selectedObjectFilterId.value,
              startDate.value,
              endDate.value,
            );
          },
        });
      }
    }

    if (selectedObjectFilterId.value != 0) {
      final selectedObject = objectsList.firstWhereOrNull(
        (o) => int.parse(o.id!) == selectedObjectFilterId.value,
      );
      if (selectedObject != null) {
        filters.add({
          selectedObject.name.toString(): () {
            selectedObjectFilterId.value = 0;
            applyFilters(
              selectedStatusId.value,
              selectedRequestTypeId.value,
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
                selectedRequestTypeId.value,
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
                selectedRequestTypeId.value,
                selectedObjectFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    return filters;
  }

  // Get translated booking statuses for filtering
  Map<int, String> getTranslatedRequestStatuses(BuildContext context) {
    return {
      -1: AppLocalization.of(context).translate("general_msgs.msg_all"),
      1: AppLocalization.of(context).translate("general_msgs.msg_pending"),
      2: AppLocalization.of(context).translate("general_msgs.msg_in_progress"),
      4: AppLocalization.of(context).translate("general_msgs.msg_rejected"),
      7: AppLocalization.of(context).translate("general_msgs.msg_confirmed"),
      5: AppLocalization.of(context).translate("general_msgs.msg_cancelled"),
      3: AppLocalization.of(context).translate("general_msgs.msg_completed"),
    };
  }

  bool _getStatusFilter(int? status) {
    return selectedStatusId.value == -1 || status == selectedStatusId.value;
  }

  bool _getRequestTypeFilter(int? requestTypeId) {
    return selectedRequestTypeId.value == 0 ||
        requestTypeId == selectedRequestTypeId.value;
  }

  void applyFilters(
    int statusId,
    int requestTypeId,
    int objectId,
    DateTime? start,
    DateTime? end,
  ) {
    debugPrint(
      'Applying filters: statusId=$statusId, requestTypeId=$requestTypeId, objectId=$objectId, start=$start, end=$end',
    );

    selectedStatusId.value = statusId;
    selectedRequestTypeId.value = requestTypeId;
    selectedObjectFilterId.value = objectId;
    startDate.value = start;
    endDate.value = end;
    filtersApplied.value = true; // Only now show chips

    filterRequests(searchController.text);
  }

  // Method to reset filters and reload data
  void clearFilters() {
    selectedStatusId.value = -1; // Reset to 'All'
    selectedRequestTypeId.value = 0; // Reset to 'All'
    selectedObjectFilterId.value = 0; // Reset to 'All'
    startDate.value = null;
    endDate.value = null;
    searchController.clear();
    filtersApplied.value = false; // Hide chips
    loadData(); // Reload original data with the same contractId
    filterRequests(''); // Clear search query
    paginatedPage.value = 0; // Reset pagination
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  void sortByPropertyName<T>(
    int sortColumnIndex,
    bool ascending,
    Comparable Function(RequestModel) getProperty,
  ) {
    sortByProperty(sortColumnIndex, ascending, getProperty);
  }

  @override
  bool containsSearchQuery(RequestModel item, String query) {
    return item.createdByName!.toLowerCase().contains(query.toLowerCase()) ||
        item.ticketNumber!.toLowerCase().contains(query.toLowerCase()) ||
        item.objectName!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(RequestModel item) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<List<RequestModel>> fetchItems() async {
    final result =
        await ObjectRepository.instance.fetchObjectsRequestsByCompanyId();

    final updatedUser = await userController.fetchUserDetails();

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    // debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredRequests =
        result
            .where(
              (request) => userObjectRestrictions.contains(
                int.parse(request.objectId.toString()),
              ),
            )
            .toList();

    return filteredRequests;
  }
}
