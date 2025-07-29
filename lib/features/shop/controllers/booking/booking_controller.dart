import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/amenity_unit_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/booking_timeslot_model.dart';
import 'package:xm_frontend/data/models/building_model.dart';
import 'package:xm_frontend/data/models/category_model.dart';
import 'package:xm_frontend/data/repositories/building/building_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_toggle_widget.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

enum BookingSourceType { contract, tenant, building, agency }

class BookingController extends TBaseController<BookingModel> {
  // Store the original list of bookings (unchanged)
  RxList<BookingModel> allBookings = <BookingModel>[].obs;
  RxList<BookingModel> filteredBookings = <BookingModel>[].obs;

  RxList<BookingModel> allRecentBookings = <BookingModel>[].obs;

  final _buildingRepository = Get.put(BuildingRepository());

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxInt totalBookings = 0.obs; // Total bookings count

  TextEditingController searchController =
      TextEditingController(); // For search functionality

  RxInt selectedStatusId = (-1).obs; // -1 means All
  final paginatedPage = 0.obs;

  RxList<BuildingModel> buildingsList = <BuildingModel>[].obs;
  RxInt selectedBuildingFilterId = 0.obs; // 0 = All

  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  RxMap<DateTime, List<BookingModel>> bookingsByDate =
      <DateTime, List<BookingModel>>{}.obs;
  final calendarRebuildTrigger = false.obs;

  //final currentView = 'table'.obs; // or 'calendar'
  final Rx<ViewMode> currentView = ViewMode.table.obs;

  RxBool filtersApplied = false.obs; // Track if filters are applied

  final int? id;

  final BookingSourceType sourceType;

  /// all categories that came back from the DB
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  /// which category‐IDs the user has tapped
  final RxList<int> selectedCategoryIds = <int>[].obs;

  // ─── Creation fields ──────────────────────────────────
  final formKey = GlobalKey<FormState>();
  RxBool createLoading = false.obs;

  // 1) categories to choose from
  RxList<CategoryModel> createCategories = <CategoryModel>[].obs;
  RxnInt createCategoryId = RxnInt();

  // 2) buildings (you already have buildingsList)
  RxnInt createBuildingId = RxnInt();

  // 3) tenants
  RxList<UserModel> createTenants = <UserModel>[].obs;
  RxnInt createTenantId = RxnInt();

  // 4) amenity-units
  RxList<AmenityUnitModel> createUnits = <AmenityUnitModel>[].obs;
  RxnInt createUnitId = RxnInt();

  /// ← NEW: user picks a date from calendar
  Rxn<DateTime> createBookingDate = Rxn<DateTime>();

  /// ← NEW: the slots returned by your availability proc
  RxList<BookingTimeslotModel> createSlots = <BookingTimeslotModel>[].obs;
  RxnString createSlotTime = RxnString();
  RxnString createEndSlotTime = RxnString();

  RxnInt tenantContractId = RxnInt();

  final userController = Get.find<UserController>();

  BookingController({required this.sourceType, required this.id});

  @override
  void onInit() {
    super.onInit();
    loadData(); // Load data when the controller is initialized
    loadCreateCategories();

    loadAllBuildings(); // Load all buildings when the controller is initialized
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
      //   Get.snackbar('Error', 'Failed to load buildings: $e');
    } finally {
      //  loading.value = false;
    }
  }

  Future<void> loadCreateCategories() async {
    final cats = await _buildingRepository.getAllAgencyAmenityCategories();
    createCategories.assignAll(cats);
  }

  // void onCreateCategoryChanged(int? catId) {
  //   createCategoryId.value = catId;
  //   _loadCreateUnits();
  // }

  void onCreateCategoryChanged(int? catId) {
    // 1. Update the category
    createCategoryId.value = catId;

    // 2. Drop everything that depends on category
    createBuildingId.value = null;
    createTenants.clear();
    createTenantId.value = null;
    createUnits.clear();
    createUnitId.value = null;
    createBookingDate.value = null;
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    if (catId != null) {
      loadAllBuildings();
      // tenants & units will only load once both building & tenant are set
    }
  }

  // void onCreateBuildingChanged(int? bldId) {
  //   createBuildingId.value = bldId;
  //   _loadCreateTenants(bldId);
  //   _loadCreateUnits();
  // }

  void onCreateBuildingChanged(int? bldId) {
    // 1. Update the building
    createBuildingId.value = bldId;

    // 2. Clear everything downstream of building
    createTenantId.value = null;
    createTenants.clear();
    createUnitId.value = null;
    createUnits.clear();
    createBookingDate.value = null;
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    // 3. Load tenants for that building (category is already set above)
    if (bldId != null) {
      _loadCreateTenants(bldId);
    }
  }

  Future<void> _loadCreateTenants(int? buildingId) async {
    createTenants.clear();
    if (buildingId == null) return;
    final all = await UserRepository.instance.getAllBuildingTenants(
      buildingId.toString(),
    );
    createTenants.assignAll(all.where((t) => t.contractStatus == 1));
  }

  // void onCreateTenantChanged(int? tId) {
  //   createTenantId.value = tId;
  //   _loadCreateUnits();
  // }

  void onCreateTenantChanged(int? tId) {
    // 1. Update the tenant
    createTenantId.value = tId;

    // 2. Clear downstream of tenant
    createUnitId.value = null;
    createUnits.clear();
    createBookingDate.value = null;
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    // 3. Now attempt to load units, if category+building+tenant are all non-null
    _loadCreateUnits();
  }

  Future<void> _loadCreateUnits() async {
    final cat = createCategoryId.value;
    final bld = createBuildingId.value;
    final tnt = createTenantId.value;

    debugPrint(
      'Loading units for category: $cat, building: $bld, tenant: $tnt',
    );

    // if any of the three are null, clear & bail
    if (cat == null || bld == null || tnt == null) {
      createUnits.clear();
      createUnitId.value = null;
      return;
    }

    // get zone id from createTenants list

    final tenant = createTenants.firstWhereOrNull(
      (t) => int.parse(t.id!) == tnt,
    );

    tenantContractId.value = tenant?.tenantContractId;

    debugPrint(
      'Tenant zoneId: ${tenant?.zoneId}, category: $cat, building: $bld',
    );

    try {
      final units = await _buildingRepository
          .getTenantBuildingAvailableAmenityUnitsV2(bld, tenant!.zoneId!, cat);
      createUnits.assignAll(units);
    } catch (e) {
      // either the repo threw because it used firstWhere
      // and found nothing, or some other error — just clear
      createUnits.clear();
    }

    // reset any previously-selected unit & slot
    createUnitId.value = null;
    createSlotTime.value = null;
    createSlots.clear();
  }

  /// when user picks a date from calendar widget
  // still in BookingController
  void onCreateDateChanged(DateTime newDate) {
    // 1) set the date
    createBookingDate.value = newDate;

    // 2) clear any previously‐loaded slots & selected times
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    // 3) re‐fetch slots for the current unit on the new date
    if (createUnitId.value != null) {
      _loadCreateSlots();
    }
  }

  /// ← REPLACED: fetch slots with your proc get_building_amenity_unit_availability
  Future<void> _loadCreateSlots() async {
    createSlots.clear();
    final unitId = createUnitId.value;
    final date = createBookingDate.value;

    // get amenity id
    debugPrint('Loading slots for amenity  unitId: $unitId, date: $date');

    String formattedDate = DateFormat('yyyy-MM-dd').format(date!);

    // now to datetime

    DateTime dateTime = DateTime.parse(formattedDate);

    if (unitId != null && dateTime != null) {
      final ss = await BuildingRepository.instance
          .getBuildingAmenityUnitAvailability(unitId, dateTime, 0);
      createSlots.assignAll(ss);
    }
  }

  void onCreateUnitChanged(int? uId) {
    createUnitId.value = uId;
    // if user already picked date, reload slots
    if (createBookingDate.value != null) {
      _loadCreateSlots();
    }
  }

  Future<void> submitCreateBooking() async {
    if (!formKey.currentState!.validate()) return;

    createLoading.value = true;

    var bookingCreated = false;

    String formattedSQL = DateFormat(
      'yyyy-MM-dd',
    ).format(createBookingDate.value!);
    // now to datetime

    DateTime date = DateTime.parse(formattedSQL);

    bookingCreated = await UserRepository.instance.createTenantBooking(
      createTenantId.value!,
      createUnitId.value!,
      date,
      createSlotTime.value!,
      createEndSlotTime.value!,
      tenantContractId.value!,
    );

    createLoading.value = false;

    if (bookingCreated) {
      Get.back(result: true); //  Return `true` to indicate tenant was created

      refreshData(); // Refresh the data in the parent controller
      filteredItems.refresh(); // Refresh the filtered items
      filteredBookings.refresh(); // Refresh the filtered bookings
      groupBookingsByDate(); // Re-group bookings by date

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
        ).translate('general_msgs.msg_data_failed_to_add'),
      );
    }
  }

  /// Toggle one category on/off and re-filter
  // void toggleCategory(int id) {
  //   if (selectedCategoryIds.contains(id)) {
  //     selectedCategoryIds.remove(id);
  //   } else {
  //     selectedCategoryIds.add(id);
  //   }
  //   // now immediately re-filter
  //   filterBookings(searchController.text);
  // }

  void groupBookingsByDate() {
    final Map<DateTime, List<BookingModel>> grouped = {};

    for (final booking in filteredBookings) {
      final date = booking.date;
      if (date == null) continue;

      final normalizedDate = DateTime(date.year, date.month, date.day);

      if (!grouped.containsKey(normalizedDate)) {
        grouped[normalizedDate] = [];
      }

      grouped[normalizedDate]!.add(booking);
    }

    // remove cancelled bookings
    grouped.removeWhere(
      (key, value) => value.any((booking) => booking.status == 5),
    );

    bookingsByDate.assignAll(grouped);
    calendarRebuildTrigger.toggle();

    debugPrint('Grouped bookings: ${bookingsByDate.length}');
  }

  // Method to load data from UserRepository
  Future<void> loadData() async {
    try {
      List<BookingModel> bookings;

      switch (sourceType) {
        case BookingSourceType.contract:
          bookings = await UserRepository.instance
              .fetchTenantBookingsByContractId(id!);
          break;
        case BookingSourceType.tenant:
          bookings = await UserRepository.instance
              .fetchTenantBookingsByTenantId(id!);
          break;
        case BookingSourceType.building:
          bookings = await BuildingRepository.instance
              .fetchBuildingRecentBookingsByBuildingId(id!);
          break;
        case BookingSourceType.agency:
          bookings =
              await BuildingRepository.instance
                  .fetchBuildingsBookingsByAgencyId();
          break;
      }

      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredBookingsData =
          bookings
              .where(
                (booking) => userBuildingRestrictions.contains(
                  int.parse(booking.buildingId.toString()),
                ),
              )
              .toList();

      allBookings.assignAll(filteredBookingsData);
      allRecentBookings.assignAll(filteredBookingsData);
      filteredBookings.assignAll(filteredBookingsData);
      totalBookings.value = filteredBookingsData.length;

      // build distinct CategoryModel list:
      final catMap = <int, String>{};
      for (var b in allBookings) {
        if (b.categoryId != null && b.categoryName != null) {
          catMap[b.categoryId!] = b.categoryName!;
        }
      }
      categories.assignAll(
        catMap.entries
            .map((e) => CategoryModel(id: e.key, name: e.value))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)),
      );

      groupBookingsByDate();

      update(); // Notify listeners of changes
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  Future<void> loadBuildingRecentBookingswssssss() async {
    try {
      final buildingId =
          SettingsController
              .instance
              .settings
              .value
              .selectedBuildingId; // replace with selected building id
      List<BookingModel> bookings = await _buildingRepository
          .fetchBuildingRecentBookingsByBuildingId(int.parse(buildingId));

      allRecentBookings.assignAll(bookings);

      debugPrint("All recent bookings: ${allRecentBookings.length}");
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  // Method to filter bookings based on search query and filters
  void filterBookings(String query) {
    final filteredList =
        allBookings.where((booking) {
          final matchesSearch = containsSearchQuery(booking, query);

          final matchesStatus = _getStatusFilter(booking.status);
          final matchesStartDate =
              startDate.value == null ||
              booking.date?.isAfter(startDate.value!) == true;
          final matchesEndDate =
              endDate.value == null ||
              booking.date?.isBefore(endDate.value!) == true;
          final matchesBuilding =
              selectedBuildingFilterId.value == 0 ||
              booking.buildingId == selectedBuildingFilterId.value;

          final catId = booking.categoryId;

          debugPrint(
            'Booking categoryId: $catId, selectedCategoryIds: $selectedCategoryIds',
          );
          final matchesCategory =
              selectedCategoryIds.isEmpty ||
              (catId != null && selectedCategoryIds.contains(catId));

          return matchesSearch &&
              matchesStatus &&
              matchesStartDate &&
              matchesEndDate &&
              matchesBuilding &&
              matchesCategory;
        }).toList();

    //  Set this as the new source for pagination
    filteredBookings.assignAll(filteredList);
    filteredItems.assignAll(filteredList); // if used in paginated table

    totalBookings.value = filteredList.length;

    // Reset pagination to page 0
    paginatedPage.value = 0;

    // Re-group events for calendar
    groupBookingsByDate();

    update(); // Refresh observers/UI
  }

  // Get translated booking statuses for filtering
  Map<int, String> getTranslatedBookingStatuses(BuildContext context) {
    return {
      -1: AppLocalization.of(context).translate("general_msgs.msg_all"),
      1: AppLocalization.of(context).translate("general_msgs.msg_pending"),
      7: AppLocalization.of(context).translate("general_msgs.msg_confirmed"),
      //   5: AppLocalization.of(context).translate("general_msgs.msg_cancelled"),
      3: AppLocalization.of(context).translate("general_msgs.msg_completed"),
    };
  }

  bool _getStatusFilter(int? status) {
    return selectedStatusId.value == -1 || status == selectedStatusId.value;
  }

  void applyFilters(
    int statusId,
    int buildinId,
    DateTime? start,
    DateTime? end,
  ) {
    selectedStatusId.value = statusId;
    selectedBuildingFilterId.value = buildinId;
    startDate.value = start;
    endDate.value = end;
    filterBookings(searchController.text);
  }

  void applyCategoryFilter() {
    filterBookings(searchController.text);
  }

  // Method to reset filters and reload data
  void clearFilters() {
    //  selectedStatus.value = 'All';
    selectedStatusId.value = -1; // Reset to 'All'
    selectedBuildingFilterId.value = 0; // Reset to 'All'
    startDate.value = null;
    endDate.value = null;
    searchController.clear();
    paginatedPage.value = 0; // Reset pagination
    loadData(); // Reload original data with the same contractId
    filterBookings(''); // Clear search query
  }

  void clearStartDate() {
    startDate.value = null;
  }

  void clearEndDate() {
    endDate.value = null;
  }

  List<Map<String, VoidCallback>> getActiveFilters() {
    final List<Map<String, VoidCallback>> filters = [];

    if (selectedStatusId.value != -1) {
      filters.add({
        THelperFunctions.getStatusText(selectedStatusId.value): () {
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

  void sortByPropertyName<T>(
    int sortColumnIndex,
    bool ascending,
    Comparable Function(BookingModel) getProperty,
  ) {
    sortByProperty(sortColumnIndex, ascending, getProperty);
  }

  Future<bool> updateBookingStatus(BookingModel item, int status) async {
    return await UserRepository.instance.updateTenantBookingStatus(
      int.parse(item.id!),
      status,
    );
  }

  @override
  bool containsSearchQuery(BookingModel item, String query) {
    return item.createdByName!.toLowerCase().contains(query.toLowerCase()) ||
        item.title!.toLowerCase().contains(query.toLowerCase()) ||
        item.buildingName!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(BookingModel item) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<List<BookingModel>> fetchItems() async {
    final result =
        await BuildingRepository.instance.fetchBuildingsBookingsByAgencyId();

    final updatedUser = await userController.fetchUserDetails();

    final userBuildingRestrictions = updatedUser.buildingPermissionIds ?? [];

    // debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredBookings =
        result
            .where(
              (booking) => userBuildingRestrictions.contains(
                int.parse(booking.buildingId.toString()),
              ),
            )
            .toList();

    return filteredBookings;
  }
}
