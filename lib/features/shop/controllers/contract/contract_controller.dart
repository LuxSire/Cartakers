import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/unit_model.dart';
import 'package:xm_frontend/data/repositories/authentication/authentication_repository.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';

import 'package:xm_frontend/data/repositories/contract/contract_repository.dart';
import 'package:xm_frontend/data/repositories/unit/unit_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/controllers/building/building_unit_detail_controller.dart';
import 'package:xm_frontend/utils/constants/colors.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/helpers/network_manager.dart';
import 'package:xm_frontend/utils/popups/full_screen_loader.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

class ContractController extends TBaseController<ContractModel> {
  static ContractController get instance => Get.find();

  final _contractRepository = Get.put(ContractRepository());
  final _unitReposotory = Get.put(UnitRepository());
  final _buildingRepository = Get.put(BuildingRepository());

  final formKey = GlobalKey<FormState>();

  RxBool isDataUpdated = false.obs;

  final RxList<ContractModel> pendingContracts = <ContractModel>[].obs;

  final contractReferenceController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final tenants = <UserModel>[].obs;
  final selectedTenants = <UserModel>[].obs;
  final RxInt selectedStatus = 3.obs; // default to Pending

  RxBool filtersApplied = false.obs; // Track if filters are applied

  var contractModel = ContractModel.empty().obs; // Make it observable
  final paginatedPage = 0.obs;

  var loading = false.obs;

  var searchQueryValue = "".obs;

  RxBool loadingTenants = true.obs;

  // This will be used to filter tenants by name or email
  var filteredTenants = <UserModel>[].obs;
  RxList<UnitModel> unitsList = <UnitModel>[].obs;
  RxList<BuildingModel> buildingsList = <BuildingModel>[].obs;

  // this is for when creating a new contract from all contracts table
  RxInt selectedUnitId = 0.obs;
  RxInt selectedBuildingId = 0.obs;

  RxList<ContractModel> allContracts = <ContractModel>[].obs;
  RxList<ContractModel> filteredContracts = <ContractModel>[].obs;

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  RxInt selectedStatusId = (-1).obs; // -1 means all statuses
  RxInt selectedBuildingFilterId = 0.obs; // 0 = All

  final userController = Get.find<UserController>();

  @override
  void onInit() {
    // Retrieve stored email and password if "Remember Me" is selected
    super.onInit();
    //
    loadTenants();
    loadAllBuildings();
    loadContarcts();
  }

  Future<void> loadContarcts() async {
    loading.value = true;
    try {
      final contracts =
          await _contractRepository.getAllAgencyBuildingsContracts();

      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

      debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredContractsData =
          contracts
              .where(
                (contract) => userBuildingRestrictions.contains(
                  int.parse(contract.buildingId.toString()),
                ),
              )
              .toList();

      allContracts.assignAll(filteredContractsData);
      filteredContracts.assignAll(filteredContractsData);
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

  // Load tenants and update state
  void loadTenants() async {
    try {
      loadingTenants.value = true; // Start loading
      // Simulate a delay or actual data fetching logic
      await Future.delayed(Duration(seconds: 1)); // Mock async fetch

      debugPrint(contractModel.value.toJson().toString());
      debugPrint('Contract ID: ${contractModel.value.id}');

      // Assuming contractModel is already populated
      filteredTenants.value = contractModel.value.tenants ?? [];

      debugPrint('Filtered Tenants: ${filteredTenants.length}');

      loadingTenants.value = false; // Mark loading as done
    } catch (e) {
      loadingTenants.value = false;
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }

  void loadAllBuildingUnits(int buildingId) async {
    try {
      final result = await _buildingRepository.fetchBuildingUnits(
        buildingId.toString(),
      );

      unitsList.assignAll(result);

      debugPrint('Building Units: ${unitsList.length}');
      debugPrint('Building ID: $buildingId');
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

  void loadAllBuildings() async {
    try {
      final result = await _buildingRepository.getAllBuildings();
      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredBuildings =
          result
              .where(
                (building) => userBuildingRestrictions.contains(
                  int.parse(building.id.toString()),
                ),
              )
              .toList();

      buildingsList.assignAll(filteredBuildings);
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

  Future<void> loadPendingContracts() async {
    // final all = await _contractRepository.getAllBuildingContracts();
    // pendingContracts.assignAll(
    //   all.where((c) => c.statusId == 3),
    // ); // Status 3 = pending
  }

  Future<void> initializeContractData(int contractId) async {
    contractModel.value = await _contractRepository.fetchContractById(
      contractId,
    );

    // Fetch assigned tenants
    final assignedTenants = await UserRepository.instance
        .fetchTenantsByContractId(int.parse(contractModel.value.id!));
    contractModel.value.tenants = assignedTenants;

    contractModel.value.tenantCount = assignedTenants.length;

    // Pre-fill form
    contractReferenceController.text = contractModel.value.contractCode ?? '';

    if (contractModel.value.startDate != null) {
      startDateController.text = DateFormat(
        'dd.MM.yyyy',
      ).format(contractModel.value.startDate!);
    } else {
      startDateController.text = '';
    }

    if (contractModel.value.endDate != null) {
      endDateController.text = DateFormat(
        'dd.MM.yyyy',
      ).format(contractModel.value.endDate!);
    } else {
      endDateController.text = '';
    }

    selectedStatus.value = contractModel.value.statusId!;

    // Load unassigned + merge
    final unassigned = await _contractRepository.getAllNonContractTenants(
      contractModel.value.buildingId!,
    );

    final mergedTenants = [
      ...unassigned,
      ...assignedTenants.where((a) => !unassigned.any((u) => u.id == a.id)),
    ];
    tenants.assignAll(mergedTenants);

    // Pre-select assigned tenants
    selectedTenants.value =
        tenants.where((t) => assignedTenants.any((a) => a.id == t.id)).toList();
  }

  String statusIdToLocalizedText(BuildContext context, int statusId) {
    switch (statusId) {
      case 1:
        return AppLocalization.of(context).translate('general_msgs.msg_active');
      case 2:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_terminated');
      case 3:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_pending');
      default:
        return AppLocalization.of(
          context,
        ).translate('general_msgs.msg_unknown');
    }
  }

  void pickStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      startDateController.text = formatted;
    }
  }

  void editPickStartDate(BuildContext context, DateTime initDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      startDateController.text = formatted;
    }
  }

  void editPickEndDate(BuildContext context, DateTime initDate) async {
    // check initDate is not null

    final date = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  TColors.primary, // Main picker color (selected day, header)
              onPrimary:
                  Colors.white, // Text on primary (e.g., selected day text)
              //  onSurface: TColors.text,  // Default text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TColors.primary, // Button text (Cancel/OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final formatted = DateFormat('dd.MM.yyyy').format(date);
      endDateController.text = formatted;
    }
  }

  Future<void> loadNonContractTenants(int bId) async {
    try {
      loading.value = true;

      int? buildingId;

      try {
        // Attempt to get the building ID from the current unit
        buildingId =
            BuildingUnitDetailController.instance.unit.value.buildingId;
      } catch (e) {
        buildingId = 0; // Fallback to 0 if not available
      }

      if (buildingId == null || buildingId == 0) {
        // If buildingId is still 0, use the provided bId
        buildingId = bId;
      }

      if (bId != 0) {
        buildingId = bId;
      }

      final result = await _contractRepository.getAllNonContractTenants(
        int.parse(buildingId.toString()),
      );

      tenants.assignAll(result);
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

  Future<void> loadSelectedBuildingNonContractTenants(int buildingId) async {
    try {
      loading.value = true;

      debugPrint(
        'loadSelectedBuildingNonContractTenants Building ID: $buildingId',
      );
      final result = await _contractRepository.getAllNonContractTenants(
        int.parse(buildingId.toString()),
      );

      tenants.assignAll(result);
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

  Future<void> loadNonContractTenantsMerged(ContractModel contract) async {
    try {
      loading.value = true;

      final buildingId =
          BuildingUnitDetailController.instance.unit.value.buildingId;

      debugPrint('loadNonContractTenants Building ID: $buildingId');

      // Load unassigned tenants
      final unassigned = await _contractRepository.getAllNonContractTenants(
        int.parse(buildingId.toString()),
      );

      // Merge with assigned tenants from the contract
      final assigned = contract.tenants ?? [];

      debugPrint('assigned Tenants: ${assigned.length}');

      // Add assigned tenants only if not already in unassigned list
      final merged = [
        ...unassigned,
        ...assigned.where(
          (assignedTenant) =>
              !unassigned.any(
                (t) => t.id.toString() == assignedTenant.id.toString(),
              ),
        ),
      ];

      tenants.assignAll(merged);

      debugPrint('Merged Tenants: ${tenants.length}');

      // Now preselect the assigned tenants
      selectedTenants.value =
          tenants
              .where(
                (t) => assigned.any((a) => a.id.toString() == t.id.toString()),
              )
              .toList();
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

  Future<void> submitContract() async {
    // the parameter is used when creating a new contract from assigned unit
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
        //   TFullScreenLoader.stopLoading();
        loading.value = false;
        return;
      }
      debugPrint('Selected Status: ${selectedStatus.value}');
      debugPrint('Selected Tenants: ${selectedTenants.length}');
      debugPrint('Selected Unit ID: ${selectedUnitId.value}');
      debugPrint('Selected Building ID: ${selectedBuildingId.value}');

      // Map Data
      contractModel.value.contractCode =
          contractReferenceController.text.trim();

      if (startDateController.text.isNotEmpty) {
        contractModel.value.startDate = DateFormat(
          'dd.MM.yyyy',
        ).parse(startDateController.text.trim());
      } else {
        contractModel.value.startDate = null;
      }

      contractModel.value.statusId = 3;
      contractModel.value.tenants = selectedTenants;
      contractModel.value.tenantCount = selectedTenants.length;
      contractModel.value.tenantNames = selectedTenants
          .map((tenant) => tenant.displayName)
          .join(', ');

      if (selectedUnitId.value != 0) {
        contractModel.value.unitId =
            selectedUnitId
                .value; // Use selected unit ID from All contracts table
      } else {
        contractModel.value.unitId = int.parse(
          BuildingUnitDetailController.instance.unit.value.id!,
        );
      }

      if (selectedBuildingId.value != 0) {
        contractModel.value.buildingId = selectedBuildingId.value;
      } else {
        contractModel.value.buildingId = int.parse(
          BuildingUnitDetailController.instance.unit.value.buildingId
              .toString(),
        );
      }

      //
      bool isContractCreated = false;
      isContractCreated = await _contractRepository.createContract(
        contractModel.value,
      );

      // Remove Loader
      loading.value = false;

      if (isContractCreated) {
        if (selectedUnitId.value != 0) {
          Get.back(result: true);
        } else {
          Get.back(result: contractModel.value);
        }

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
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

      // Update UI Listeners
      update();
    } catch (e) {
      debugPrint('Error from catch submit contrat: $e');
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

  Future<void> submitContractFromUnitAssign(
    int assignedUnitId,
    int buildingId,
  ) async {
    // the parameter is used when creating a new contract from assigned unit
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      selectedUnitId.value = assignedUnitId;
      selectedBuildingId.value = buildingId;

      debugPrint('Selected Status: ${selectedStatus.value}');
      debugPrint('Selected Tenants: ${selectedTenants.length}');
      debugPrint(
        'Selected Unit ID  submitContractFromUnitAssign: ${selectedUnitId.value}',
      );

      debugPrint('Selected Building ID: ${selectedBuildingId.value}');

      // Map Data
      contractModel.value.contractCode =
          contractReferenceController.text.trim();

      if (startDateController.text.isNotEmpty) {
        contractModel.value.startDate = DateFormat(
          'dd.MM.yyyy',
        ).parse(startDateController.text.trim());
      } else {
        contractModel.value.startDate = null;
      }

      contractModel.value.statusId = 3;
      contractModel.value.tenants = selectedTenants;
      contractModel.value.tenantCount = selectedTenants.length;
      contractModel.value.tenantNames = selectedTenants
          .map((tenant) => tenant.displayName)
          .join(', ');

      contractModel.value.buildingId = selectedBuildingId.value;

      if (selectedUnitId.value != 0) {
        contractModel.value.unitId =
            selectedUnitId
                .value; // Use selected unit ID from All contracts table
      } else {
        contractModel.value.unitId = int.parse(
          BuildingUnitDetailController.instance.unit.value.id!,
        );
      }

      //
      bool isContractCreated = false;
      isContractCreated = await _contractRepository.createContract(
        contractModel.value,
      );

      // Remove Loader
      loading.value = false;

      if (isContractCreated) {
        if (selectedUnitId.value != 0) {
          Get.back(result: true);
        } else {
          Get.back(result: contractModel.value);
        }

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_submitted'),
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

      // Update UI Listeners
      update();
    } catch (e) {
      debugPrint('Error from catch submit contrat: $e');
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

  Future<void> submitContractUpdate(ContractModel contract) async {
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
        TFullScreenLoader.stopLoading();
        loading.value = false;
        return;
      }

      // Check if any tenant is selected and statusId is not 3 (pending)
      if (selectedTenants.isEmpty && selectedStatus.value != 3) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(Get.context!).translate(
            'edit_contract_screen.error_msg_please_select_at_least_one_tenant',
          ),
        );
        loading.value = false;
        return;
      }

      var updateUnitStatus = false;
      var newUnitStatus = 0;

      // Check for active contract and handle accordingly
      if (selectedStatus.value == 1) {
        final activeContract = await _contractRepository
            .fetchActiveContractsByUnitId(
              int.parse(contract.unitId.toString()),
            );

        if (!activeContract.isEmpty && activeContract.id != contract.id) {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(Get.context!).translate(
              'edit_contract_screen.error_msg_another_active_contract_exists',
            ),
          );
          loading.value = false;
          return;
        } else {
          updateUnitStatus = true;
          newUnitStatus = 2; // Set to 2 - occupied
        }
      }

      if (selectedStatus.value == 2) {
        final activeContract = await _contractRepository
            .fetchActiveContractsByUnitId(
              int.parse(contract.unitId.toString()),
            );

        if (activeContract.id == contract.id) {
          updateUnitStatus = true;
          newUnitStatus = 1; // Set to 1 - available
        }
      }

      if (selectedStatus.value == 3) {
        final activeContract = await _contractRepository
            .fetchActiveContractsByUnitId(
              int.parse(contract.unitId.toString()),
            );

        if (!activeContract.isEmpty && activeContract.id == contract.id) {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(Get.context!).translate(
              'edit_contract_screen.error_msg_cannot_set_to_pending_when_active',
            ),
          );

          loading.value = false;
          return;
        } else {
          updateUnitStatus = true;
          newUnitStatus = 1; // Set to 1 - vacant
        }
      }

      debugPrint(
        'updateUnitStatus: $updateUnitStatus, newUnitStatus: $newUnitStatus',
      );

      bool isContractUpdated = false;
      bool isContractUpdatedSuccessfully = false;

      final parsedStartDate =
          startDateController.text.trim().isNotEmpty
              ? DateFormat('dd.MM.yyyy').parse(startDateController.text.trim())
              : null;

      final parsedEndDate =
          endDateController.text.trim().isNotEmpty
              ? DateFormat('dd.MM.yyyy').parse(endDateController.text.trim())
              : null;

      if (contract.contractCode != contractReferenceController.text.trim() ||
          contract.startDate?.toIso8601String() !=
              parsedStartDate?.toIso8601String() ||
          contract.endDate?.toIso8601String() !=
              parsedEndDate?.toIso8601String() ||
          contract.tenantCount != selectedTenants.length ||
          contract.statusId != selectedStatus ||
          contract.tenants != selectedTenants) {
        isContractUpdated = true;

        // Map Data
        contractModel.value.contractCode =
            contractReferenceController.text.trim();

        if (startDateController.text.isNotEmpty) {
          contractModel.value.startDate = DateFormat(
            'dd.MM.yyyy',
          ).parse(startDateController.text.trim());
        } else {
          contractModel.value.startDate = null;
        }

        if (endDateController.text.isNotEmpty) {
          contractModel.value.endDate = DateFormat(
            'dd.MM.yyyy',
          ).parse(endDateController.text.trim());
        } else {
          if (newUnitStatus == 1) {
            if (selectedStatus.value == 3) {
              // Do nothing
            } else {
              contractModel.value.endDate = DateTime.now();
            }
          } else {
            contractModel.value.endDate = null;
          }
        }

        contractModel.value.statusId = selectedStatus.value;
        contractModel.value.tenants = selectedTenants;
        contractModel.value.tenantCount = selectedTenants.length;
        contractModel.value.tenantNames = selectedTenants
            .map((tenant) => tenant.displayName)
            .join(', ');

        // Call Repository to Update
        isContractUpdatedSuccessfully = await _contractRepository
            .updateContractDetails(contractModel.value);

        if (updateUnitStatus && isContractUpdatedSuccessfully) {
          await _unitReposotory.updateUnitStatus(
            int.parse(contract.unitId.toString()),
            newUnitStatus,
          );
        }
      }

      // Remove Loader
      loading.value = false;

      if (isContractUpdated && isContractUpdatedSuccessfully) {
        Get.back(result: contractModel.value);

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
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

  Future<void> assignContract(ContractModel contract) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return;
      }

      var updateUnitStatus = false;
      var newUnitStatus = 0;

      // Check for active contract and handle accordingly

      final activeContract = await _contractRepository
          .fetchActiveContractsByUnitId(int.parse(contract.unitId.toString()));

      if (!activeContract.isEmpty && activeContract.id != contract.id) {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(Get.context!).translate(
            'edit_contract_screen.error_msg_another_active_contract_exists',
          ),
        );
        loading.value = false;
        return;
      } else {
        updateUnitStatus = true;
        newUnitStatus = 2; // Set to 2 - occupied
      }

      debugPrint(
        'updateUnitStatus: $updateUnitStatus, newUnitStatus: $newUnitStatus',
      );

      bool isContractUpdatedSuccessfully = false;

      // Call Repository to Update
      isContractUpdatedSuccessfully = await _contractRepository
          .updateContractDetails(contractModel.value);

      if (updateUnitStatus && isContractUpdatedSuccessfully) {
        await _unitReposotory.updateUnitStatus(
          int.parse(contract.unitId.toString()),
          newUnitStatus,
        );
      }
      // Remove Loader
      loading.value = false;

      if (isContractUpdatedSuccessfully) {
        Get.back(result: true);

        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
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

  Future<bool> submitContractTerminate(ContractModel contract) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isContractUpdatedSuccessfuly = false;

      contractModel.value = contract;

      isContractUpdatedSuccessfuly = await _contractRepository
          .updateContractDetails(contractModel.value);

      if (isContractUpdatedSuccessfuly) {
        debugPrint('Contract updated successfully');
        debugPrint(contract.unitId.toString());
        debugPrint('Unit ID: ${contract.unitId}');
        debugPrint(
          'Unit ID: ${int.parse(contractModel.value.unitId.toString())}',
        );
        // update unit status
        await _unitReposotory.updateUnitStatus(
          int.parse(contract.unitId.toString()),
          1, // set to available
        );
      }

      // Remove Loader
      loading.value = false;

      if (isContractUpdatedSuccessfuly) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
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
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch submitContractTerminate: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> removeTenantFromContract(int contractId, int tenantId) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRemoved = false;

      isRemoved = await _contractRepository.removeTenantFromContract(
        contractId,
        tenantId,
      );

      // Remove Loader
      loading.value = false;

      if (isRemoved) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
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
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch removeTenantFromContract: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateTenantContractPrimary(int contractId, int tenantId) async {
    try {
      // Start Loading
      loading.value = true;

      debugPrint('updateTenantContractPrimary: $contractId, $tenantId');

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isUpdated = false;

      isUpdated = await _contractRepository.updateTenantContractPrimary(
        contractId,
        tenantId,
      );

      // Remove Loader
      loading.value = false;

      if (isUpdated) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_data_updated'),
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
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch updateTenantContractPrimary: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  void filterTenants(String query) {
    searchQueryValue.value = query;

    if (query.isEmpty) {
      filteredTenants.value = contractModel.value.tenants ?? [];
    } else {
      filteredTenants.value =
          contractModel.value.tenants?.where((tenant) {
            return tenant.displayName.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                tenant.email.toLowerCase().contains(query.toLowerCase());
          }).toList() ??
          [];
    }
  }

  Future<File?> pickFile() async {
    // Show the file picker dialog and allow the user to select a file
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      return File(result.files.single.path!); // Return the file
    } else {
      return null; // No file selected
    }
  }

  Future<bool> deleteDocumentFromAzure(
    String fileName,
    String containerName,
    int documentId,
  ) async {
    try {
      if (fileName == '') {
        debugPrint('No file name found.');
        return false;
      }

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileDeleted = false;

      isFileDeleted = await _contractRepository.deleteDocument(
        fileName,
        containerName,
        documentId,
      );

      // Remove Loader
      loading.value = false;

      if (isFileDeleted) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_deleted'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_delete_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> uploadDocumentToAzure(File pickedFile, int contractId) async {
    try {
      if (pickedFile == null) {
        debugPrint('No file selected.');
        return false;
      }

      final directoryName =
          "contracts/$contractId"; // Set the directory for storage

      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isFileUploaded = false;

      isFileUploaded = await _contractRepository.uploadNewDocument(
        contractId,
        directoryName,
        pickedFile,
      );

      // Remove Loader
      loading.value = false;

      if (isFileUploaded) {
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_new_document_uploaded_successfully'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_document_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch uploadDocumentToAzure: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
  }

  Future<bool> renameFile(int documentId, String newFileName) async {
    try {
      // Start Loading
      loading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        loading.value = false;
        return false;
      }
      bool isRenameFileUpdatedSuccessfuly = false;

      isRenameFileUpdatedSuccessfuly = await _contractRepository.updateFileName(
        documentId,
        newFileName,
      );

      // Remove Loader
      loading.value = false;

      debugPrint(
        'isRenameFileUpdatedSuccessfuly: $isRenameFileUpdatedSuccessfuly',
      );

      if (isRenameFileUpdatedSuccessfuly) {
        Get.back(result: newFileName);
        TLoaders.successSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_info'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_success'),
        );
      } else {
        TLoaders.errorSnackBar(
          title: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_error'),
          message: AppLocalization.of(
            Get.context!,
          ).translate('general_msgs.msg_rename_file_failed'),
        );
        return false;
      }

      // Update UI Listeners
      update();
      return true;
    } catch (e) {
      debugPrint('Error from catch renameFile: $e');
      loading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
      return false;
    }
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

    debugPrint(
      'applyFilters: statusId=$statusId, buildingId=$buildingId, start=$start, end=$end',
    );

    filterItemsWithSearch(searchTextController.text);
  }

  void clearFilters() {
    selectedStatusId.value = -1;
    selectedBuildingFilterId.value = 0;
    startDate.value = null;
    endDate.value = null;
    searchTextController.clear();
    filterItemsWithSearch('');
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  void clearFields() {
    contractReferenceController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedTenants.clear();
    selectedStatus.value = 3; // Default to pending
  }

  void resetFields() {
    contractReferenceController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedTenants.clear();
    selectedStatus.value = 3;
    selectedBuildingId.value = 0;
  }

  Map<int, String> getTranslatedContractStatuses() {
    return {
      -1: AppLocalization.of(Get.context!).translate("general_msgs.msg_all"),
      1: THelperFunctions.getUnitContractStatusText(1),
      2: THelperFunctions.getUnitContractStatusText(2),
      3: THelperFunctions.getUnitContractStatusText(3),
      4: THelperFunctions.getUnitContractStatusText(4),
    };
  }

  void filterItemsWithSearch([String query = '']) {
    final results =
        allItems.where((item) {
          final matchesSearch = containsSearchQuery(item, query);

          final matchesStatus =
              selectedStatusId.value == -1 || // All
              (selectedStatusId.value == 4 &&
                  (item.statusId == null ||
                      item.statusId == 0)) || // Unassigned
              (item.statusId != null &&
                  item.statusId == selectedStatusId.value);

          final matchesBuilding =
              selectedBuildingFilterId.value == 0 ||
              item.buildingId == selectedBuildingFilterId.value;

          final matchesStartDate =
              startDate.value == null ||
              item.startDate!.isAfter(startDate.value!);

          final matchesEndDate =
              endDate.value == null || item.startDate!.isBefore(endDate.value!);

          // if (selectedStatusId.value == 4) {
          //   debugPrint(
          //     'Evaluating ${item.fullName} → contractStatus=${item.contractStatus}',
          //   );
          // }

          return matchesSearch &&
              matchesStatus &&
              matchesBuilding &&
              matchesStartDate &&
              matchesEndDate;
        }).toList();

    filteredItems.assignAll(results);
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getUnitContractStatusText(selectedStatusId.value): () {
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
  Future<List<ContractModel>> fetchItems() async {
    // return await _contractRepository.getAllBuildingContracts();

    final result = await _contractRepository.getAllAgencyBuildingsContracts();

    final updatedUser = await userController.fetchUserDetails();

    final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

    debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredContractsData =
        result
            .where(
              (contract) => userBuildingRestrictions.contains(
                int.parse(contract.buildingId.toString()),
              ),
            )
            .toList();

    return filteredContractsData;
  }

  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.contractCode.toString().toLowerCase(),
    );
  }

  void sortByBuilding(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.buildingName.toString().toLowerCase(),
    );
  }

  void sortByUnit(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.unitNumber.toString().toLowerCase(),
    );
  }

  void sortByStartDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.startDate?.toIso8601String() ?? '',
    );
  }

  void sortByEndDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.endDate?.toIso8601String() ?? '',
    );
  }

  void sortByStatus(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
      (ContractModel b) => b.statusId.toString().toLowerCase(),
    );
  }

  @override
  bool containsSearchQuery(ContractModel item, String query) {
    return item.tenantNames!.toLowerCase().contains(query.toLowerCase()) ||
        item.contractCode!.toLowerCase().contains(query.toLowerCase()) ||
        item.unitNumber.toString().toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(ContractModel item) async {
    return await _contractRepository.deleteContract(int.parse(item.id!));
  }
}
