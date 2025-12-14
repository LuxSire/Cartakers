import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cartakers/app/localization/app_localization.dart';
import 'package:cartakers/data/abstract/base_data_table_controller.dart';
import 'package:cartakers/data/api/translation_api.dart';
import 'package:cartakers/data/models/object_model.dart';
import 'package:cartakers/data/models/user_role_model.dart';
import 'package:cartakers/data/repositories/authentication/authentication_repository.dart';
import 'package:cartakers/data/repositories/object/object_repository.dart';
import 'package:cartakers/utils/helpers/helper_functions.dart';

import '../../../data/repositories/company/company_repository.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../media/models/image_model.dart';
import '../models/company_model.dart';

/// Controller for managing admin-related data and operations
class CompanyController extends TBaseController<CompanyModel  > {
  RxList<bool> selectedRows = <bool>[].obs;   
  static CompanyController get instance => Get.find();

  @override
  Future<List<CompanyModel>> fetchItems() async {
    // Fetch all companies from the repository
    return await companyRepository.getAllCompanies();
  }

  // Observable variables
  RxBool loading = false.obs;
  Rx<CompanyModel> company = CompanyModel.empty().obs;
  Rx<CompanyModel> companyRetrived = CompanyModel.empty().obs;

  RxString companyRetrivedProfileUrl = ''.obs;
  final displayNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final cityController = TextEditingController();
      final countryController = TextEditingController();
    final tokenController = TextEditingController();
  final searchController = TextEditingController();

  final selectedObjectId = 0.obs;

  Rx<Uint8List?> memoryBytes = Rx<Uint8List?>(null);

  RxBool hasImageChanged = false.obs;

  final paginatedPage = 0.obs;
  var companyModel = CompanyModel.empty().obs; // Make it observable

  // Dependencies
  final companyRepository = Get.put(CompanyRepository());
  final _objectRepository = Get.put(ObjectRepository());

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;
  RxList<UserRoleModel> companyRolesList = <UserRoleModel>[].obs;

  var selectedObjectIds = <int>[].obs;

  final selectedRoleId = 0.obs;

  RxBool filtersApplied = false.obs; // Track if filters are applied

  // for filters
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedRoleFilterId = (-1).obs; // 0 = All
  RxInt selectedStatusFilterId = (-1).obs; // 0 = All

  RxList<CompanyModel> allcompanies = <CompanyModel>[].obs;


  @override
  void onInit() {
    super.onInit();

    // Get companys
    loadcompanies();
      ever(filteredItems, (_) {
        selectedRows.value = List<bool>.filled(filteredItems.length, false);
          });
    //  fetchcompanysAndTranslateFields();
  }

  void resetFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    emailController.clear();
    cityController.clear();
    countryController.clear();
    selectedObjectId.value = 0; // Reset selected object ID

  }

  /// Fetches company details from the repository
  Future<CompanyModel> fetchCompanyDetails() async {
    try {
      loading.value = true;
      //if (company.value.id == null || company.value.id!.isEmpty) {
      //  debugPrint('Fetching company Details');
      final companyR = await companyRepository.fetchCompanyDetails();
      debugPrint('company from fetchcompanyDetails controller: ${companyR.toJson()}');
      
      company.value = companyR;

      debugPrint('company from company controller: ${company.value.toJson()}');

      var translatedRoleName = await TranslationApi.smartTranslate(
        company.value.roleNameExt!,
      );

      debugPrint('Translated Role Name: $translatedRoleName');

      // company.value.translatedRoleNameExt = translatedRoleName;

      company.update((val) => val?.translatedRoleNameExt = translatedRoleName);

      nameController.text = company.value.name;


      loading.value = false;

      debugPrint('company Details Refreshed: ${company.value.toJson()}');
      return companyR;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Something went wrong.',
        message: e.toString(),
      );
      return CompanyModel.empty();
    }
  }

  void loadAllObjects() async {
    try {
      final result = await _objectRepository.getAllObjects();

      objectsList.assignAll(result);
      //    debugPrint('Buildings Loaded: ${buildingsList.length}');
    } catch (e) {
      //   Get.snackbar('Error', 'Failed to load buildings: $e');
    } finally {
      //  loading.value = false;
    }
  }

  void toggleObject(int id) {
    if (selectedObjectIds.contains(id)) {
      selectedObjectIds.remove(id);
    } else {
      selectedObjectIds.add(id);
    }
  }

  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true, // So we can preview it in memory
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      memoryBytes.value = file.bytes;
      hasImageChanged.value = true;

      companyRetrivedProfileUrl.value = file.name;
    }
  }

  Future<CompanyModel> fetchCompanyDetailsById(int companyId) async {
    loading.value = true;
    try {
      if (companyId != 0) {
        final company = await companyRepository.fetchCompanyDetailsById(companyId);

        if (company == null) {
          // handle null gracefully
          debugPrint('No company found with id $companyId');
          // Optionally clear fields or return an empty company model
          companyRetrived.value = CompanyModel.empty();
        } else {
          // companyRetrived.value = company;
          companyRetrived.update((val) {
            // Update the company object with the retrieved data
            val?.id = company.id;
            val?.name = company.name;
   
            val?.phone = company.phone;
            val?.displayName = company.displayName;
            val?.profilePicture = company.profilePicture;
            val?.email = company.email;
            val?.roleId = company.roleId;
            val?.roleName = company.roleName;
            val?.companyId = company.companyId;
            val?.companyName = company.companyName;
            val?.createdAt = company.createdAt;
            val?.updatedAt = company.updatedAt;
            val?.translatedRoleNameExt = company.translatedRoleNameExt;
            val?.status = company.status;
            val?.statusId = company.statusId;
            val?.roleExtId = company.roleExtId;
            val?.city=company.city;
            val?.country = company.country;
          });
        }
      }

      // Populate form fields safely (empty string fallback)
      nameController.text = companyRetrived.value.name ?? '';
      phoneController.text = companyRetrived.value.phone ?? '';
      displayNameController.text = companyRetrived.value.displayName ?? '';
      companyRetrivedProfileUrl.value = companyRetrived.value.profilePicture ?? '';
      emailController.text = companyRetrived.value.email ?? '';
      selectedRoleId.value =
          companyRetrived.value.roleExtId ?? 0; // Default to 0 if null
      selectedStatusId.value =
          companyRetrived.value.statusId ?? -1; // Default to -1 if null

      // get list of company assigned objects
 
      selectedObjectIds.clear(); // Clear previous selections
       debugPrint('Selected Object IDs: $selectedObjectIds');

      return companyRetrived.value;
    } catch (e) {
      debugPrint('Error fetching company details: $e');
      // Optionally show a snackbar/toast
      // TLoaders.errorSnackBar(title: 'Something went wrong.', message: e.toString());
      return CompanyModel.empty();
    } finally {
      loading.value = false;
    }
  }

  void resetcompanyDetails() {
    // Reset the company details to empty
    companyRetrived.value = CompanyModel.empty();
    nameController.clear();
    displayNameController.clear();
    phoneController.clear();
    displayNameController.clear();
    companyRetrivedProfileUrl.value = '';
    emailController.clear();
    memoryBytes.value = null;
    hasImageChanged.value = false;
    selectedObjectIds.clear();
    selectedRoleId.value = 0;
    cityController.clear();
    countryController.clear();
  }

  Map<int, String> getTranslatedcompanyStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getUserStatusText(1),
      2: THelperFunctions.getUserStatusText(2),
      3: THelperFunctions.getUserStatusText(3),
    };
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusFilterId.value != -1) {
      filters.add({
        THelperFunctions.getUserStatusText(selectedStatusFilterId.value): () {
          selectedStatusFilterId.value = -1;
          applyFilters(
            selectedStatusFilterId.value,
            selectedRoleFilterId.value,
            startDate.value,
            endDate.value,
          );
        },
      });
    }

    if (selectedRoleFilterId.value != -1) {
      final selectedRole = companyRolesList.firstWhereOrNull(
        (r) => r.id == selectedRoleFilterId.value,
      );
      if (selectedRole != null) {
        filters.add({
          selectedRole.nameTranslated.toString(): () {
            selectedRoleFilterId.value = -1;
            applyFilters(
              selectedStatusFilterId.value,
              selectedRoleFilterId.value,
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
                selectedStatusFilterId.value,
                selectedRoleFilterId.value,
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
                selectedStatusFilterId.value,
                selectedRoleFilterId.value,
                startDate.value,
                endDate.value,
              );
            },
      });
    }

    return filters;
  }

  void filterItemsWithSearch([String query = '']) {
    // print(
    //   "Filtering companys with selectedRoleFilterId.value = ${selectedRoleFilterId.value}",
    // );
    // allItems.forEach((item) {
    //   print("company: ${item.firstName} ${item.lastName}, roleId: ${item.roleId}");
    // });

    final results =
        allcompanies.where((item) {
          // 1. Search query: allow empty (show all)
          final matchesSearch =
              query.isEmpty || containsSearchQuery(item, query);

          // 2. Status filter: allow "All" (-1)
          final matchesStatus =
              selectedStatusFilterId.value == -1 ||
              (item.statusId != null &&
                  item.statusId == selectedStatusFilterId.value);

          // 3. Role filter: allow "All" (-1)
          final int? companyRoleId = item.roleExtId;
          final matchesRole =
              selectedRoleFilterId.value == -1 ||
              (companyRoleId != null && companyRoleId == selectedRoleFilterId.value);

          // 4. Date filters: handle nulls
          final matchesStartDate =
              startDate.value == null ||
              (item.createdAt != null &&
                  (item.createdAt!.isAfter(startDate.value!) ||
                      item.createdAt!.isAtSameMomentAs(startDate.value!)));
          final matchesEndDate =
              endDate.value == null ||
              (item.createdAt != null &&
                  (item.createdAt!.isBefore(endDate.value!) ||
                      item.createdAt!.isAtSameMomentAs(endDate.value!)));

          return matchesSearch &&
              matchesStatus &&
              matchesRole &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);
  selectedRows.value = List<bool>.filled(filteredItems.length, false); // <-- Add this line
}


  bool _getStatusFilter(int? status) {
    return selectedStatusId.value == -1 || status == selectedStatusId.value;
  }

  void applyFilters(int statusId, int roleId, DateTime? start, DateTime? end) {
    selectedStatusFilterId.value = statusId;

    selectedRoleFilterId.value = roleId;
    startDate.value = start;
    endDate.value = end;

    filterItemsWithSearch(searchController.text);
  }

  void clearFilters() {
    selectedStatusFilterId.value = -1;
    selectedRoleFilterId.value = -1;
    startDate.value = null;
    endDate.value = null;
    searchController.clear();
    filterItemsWithSearch('');
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  void registerupdateCompany() async {
    try {
      loading.value = true;
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.stopLoading();
        return;
      }

      // save the temporary company details
      final savedcompany = company.value;

      // check is companyretrived is not empty or null
 
        company.value = companyRetrived.value;
        //    debugPrint('company Retrieved: ${company.value.toJson()}');
      

      // company.update((val) {
      //   val = companyRetrived.value;
      // });

      // Form Validation
      if (!formKey.currentState!.validate()) {
        //  TFullScreenLoader.stopLoading();
        return;
      }
      company.value.profilePicture = companyRetrivedProfileUrl.value;
      //company.value.roleExtId = selectedRoleId.value;

      // debugPrint('company Details: ${company.value.toJson()}');

      final iscompanyUpdated = await companyRepository.registerupdateCompany(company.value);

      company.value = savedcompany;

      company.refresh();

      loading.value = false;
      TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
        );

    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  Future<void> submitCompany() async {
    try {
      if (!formKey.currentState!.validate()) return;

      loading.value = true;

      var statusCode = 0; // 0 means exists, 1 created new tenant , 2 failed

      var roleId = 2; // default for company users

      final response = await CompanyRepository.instance.createNewCompany(
        nameController.text,
        emailController.text,
        phoneController.text,
        cityController.text,
        countryController.text,
        selectedRoleId.value
      );

      statusCode = response['status'];

      loading.value = false;
      
      
      Get.back(result: true); //  Return `true` to indicate user was created

      if (statusCode == 1) {  
          await loadcompanies(); // <-- This will fetch the updated list and sync selectedRows

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
        );
      } else if (statusCode == 0) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_exists'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_failed_to_add'),
        );
      }
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  void sortByPropertyName<T>(
    int sortColumnIndex,
    bool ascending,
    Comparable Function(CompanyModel) getProperty,
  ) {
    sortByProperty(sortColumnIndex, ascending, getProperty);
  }


  Future<void> loadcompanies() async {
    loading.value = true;
    try {
      final companies = await companyRepository.getAllCompanies();

      debugPrint('Load companies: ${companies.length}');
      for (final company in companies) {
        company.translatedStatus = await TranslationApi.smartTranslate(
          company.status ?? '',
        );
      }
      allcompanies.assignAll(companies);
      filteredItems.assignAll(companies);
      // Ensure selectedRows matches filteredItems length
      selectedRows.value = List<bool>.filled(filteredItems.length, false);
    } catch (e) {
      TLoaders.errorSnackBar(title: "Error", message: "Failed to load companies.");
    } finally {
      loading.value = false;
    }
  }

 
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.fullName.toString().toLowerCase(),
    );
  }

  void sortByObject(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.objectName.toString().toLowerCase(),
    );
  }

  void sortByEmail(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.email.toString().toLowerCase(),
    );
  }

  void sortByPhone(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.phone.toString().toLowerCase(),
    );
  }

  void sortByUnit(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.unitNumber.toString().toLowerCase(),
    );
  }

  void sortByContract(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.contractReference.toString().toLowerCase(),
    );
  }

  void sortByStatus(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.contractStatus.toString().toLowerCase(),
    );
  }

  void sortByCreatedAt(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (CompanyModel b) => b.createdAt.toString().toLowerCase(),
    );
  }



  @override
  bool containsSearchQuery(CompanyModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.email.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(CompanyModel item) async {
    final isDeleted = await companyRepository.deleteCompanyById( item.id!);
    debugPrint('company Deleted by company Controller');
/*
    if (isDeleted) {
      // deletes company directory for the images
      final companyId = AuthenticationRepository.instance.currentcompany!.companyId;
      final containerName = 'docs';
      final directory = 'companys/${item.id}';

      await companyRepository.deletecompanyDirectory(containerName, directory);
    }
    */

    return isDeleted;
  }
}
