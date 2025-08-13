import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/abstract/base_data_table_controller.dart';
import 'package:xm_frontend/data/models/amenity_unit_model.dart';
import 'package:xm_frontend/data/models/booking_model.dart';
import 'package:xm_frontend/data/models/booking_timeslot_model.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/category_model.dart';
import 'package:xm_frontend/data/repositories/object/object_repository.dart';
import 'package:xm_frontend/data/repositories/user/user_repository.dart';
import 'package:xm_frontend/features/personalization/controllers/settings_controller.dart';
import 'package:xm_frontend/features/personalization/controllers/user_controller.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';
import 'package:xm_frontend/features/shop/screens/booking/dialogs/view_toggle_widget.dart';
import 'package:xm_frontend/utils/helpers/helper_functions.dart';
import 'package:xm_frontend/utils/popups/loaders.dart';

enum BookingSourceType { user, company }

class BookingController extends TBaseController<BookingModel> {
  // Store the original list of bookings (unchanged)
  RxList<BookingModel> allBookings = <BookingModel>[].obs;
  RxList<BookingModel> filteredBookings = <BookingModel>[].obs;

  RxList<BookingModel> allRecentBookings = <BookingModel>[].obs;

  final _objectRepository = Get.put(ObjectRepository());

  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxInt totalBookings = 0.obs; // Total bookings count

  TextEditingController searchController =
      TextEditingController(); // For search functionality

  RxInt selectedStatusId = (-1).obs; // -1 means All
  final paginatedPage = 0.obs;

  RxList<ObjectModel> objectsList = <ObjectModel>[].obs;
  RxInt selectedObjectFilterId = 0.obs; // 0 = All

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
  RxList<CategoryModel> bookingCategories = <CategoryModel>[].obs;
  RxnInt createCategoryId = RxnInt();

  // 2) buildings (you already have buildingsList)
  RxnInt createObjectId = RxnInt();

  // 3) users
  RxList<UserModel> createUsers = <UserModel>[].obs;
  RxnInt createUserId = RxnInt();

  // 4) amenity-units
  RxList<AmenityUnitModel> createUnits = <AmenityUnitModel>[].obs;
  RxnInt createUnitId = RxnInt();

  /// ← NEW: user picks a date from calendar
  Rxn<DateTime> createBookingDate = Rxn<DateTime>();

  /// ← NEW: the slots returned by your availability proc
  RxList<BookingTimeslotModel> createSlots = <BookingTimeslotModel>[].obs;
  RxnString createSlotTime = RxnString();
  RxnString createEndSlotTime = RxnString();

  RxnInt userContractId = RxnInt();

  final userController = Get.find<UserController>();

  BookingController({required this.sourceType, required this.id});

  @override
  void onInit() {
    super.onInit();
    loadData(); // Load data when the controller is initialized
    bookingCategories();

    loadAllObjects(); // Load all objects when the controller is initialized
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
                  int.tryParse(object.id.toString()) ?? 0 ,
                ),
              )
              .toList();
      debugPrint('User object restrictions: $userObjectRestrictions');
      debugPrint('All object IDs: ${result.map((o) => o.id).toList()}');
      objectsList.assignAll(filteredObjects);
    } catch (e) {
      //   Get.snackbar('Error', 'Failed to load buildings: $e');
    } finally {
      //  loading.value = false;
    }
  }

  Future<void> loadBookingCategories() async {
    final cats = await _objectRepository.getAllBookingCategories();
    bookingCategories.assignAll(cats);
  }

  // void onCreateCategoryChanged(int? catId) {
  //   createCategoryId.value = catId;
  //   _loadCreateUnits();
  // }

  void onCreateCategoryChanged(int? catId) {
    // 1. Update the category
    createCategoryId.value = catId;

    // 2. Drop everything that depends on category
    createObjectId.value = null;
    createUsers.clear();
    createUserId.value = null;
    createUnits.clear();
    createUnitId.value = null;
    createBookingDate.value = null;
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    if (catId != null) {
      loadAllObjects();
      // tenants & units will only load once both building & tenant are set
    }
  }

  // void onCreateBuildingChanged(int? bldId) {
  //   createBuildingId.value = bldId;
  //   _loadCreateTenants(bldId);
  //   _loadCreateUnits();
  // }

  void onCreateObjectChanged(int? oId) {
    // 1. Update the building
    createObjectId.value = oId;

    // 2. Clear everything downstream of building
    createUserId.value = null;
    createUsers.clear();
    createUnitId.value = null;
    createUnits.clear();
    createBookingDate.value = null;
    createSlots.clear();
    createSlotTime.value = null;
    createEndSlotTime.value = null;

    // 3. Load users for that building (category is already set above)
    if (oId != null) {
      _loadCreateUsers(oId);
    }
  }

  Future<void> _loadCreateUsers(int? objectId) async {
    createUsers.clear();
    if (objectId == null) return;
    final all = await UserRepository.instance.getAllObjectUsers(
      objectId.toString(),
    );
    createUsers.assignAll(all.where((t) => t.contractStatus == 1));
  }

  // void onCreateTenantChanged(int? tId) {
  //   createTenantId.value = tId;
  //   _loadCreateUnits();
  // }

  void onCreateUserChanged(int? uId) {
    // 1. Update the tenant
    createUserId.value = uId;

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
    final bld = createObjectId.value;
    final tnt = createUserId.value;

    debugPrint(
      'Loading units for category: $cat, object: $bld, tenant: $tnt',
    );

    // if any of the three are null, clear & bail
    if (cat == null || bld == null || tnt == null) {
      createUnits.clear();
      createUnitId.value = null;
      return;
    }

    // get zone id from createUsers list

    final user = createUsers.firstWhereOrNull(
      (t) => int.parse(t.id!) == tnt,
    );

    userContractId.value = user?.userContractId;

    debugPrint(
      'User zoneId: ${user?.zoneId}, category: $cat, building: $bld',
    );


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
      final ss = await ObjectRepository.instance
          .getObjectAmenityUnitAvailability(unitId, dateTime, 0);
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

    bookingCreated = await UserRepository.instance.createUserBooking(
      createUserId.value!,
      createUnitId.value!,
      date,
      createSlotTime.value!,
      createEndSlotTime.value!,
      userContractId.value!,
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

        case BookingSourceType.user:
          bookings = await UserRepository.instance
              .fetchUserBookingsByUserId(id!);
          break;
        case BookingSourceType.company:
          bookings =
              await ObjectRepository.instance
                  .fetchObjectsBookingsByCompanyId();
          break;
      }

      final updatedUser = await userController.fetchUserDetails();

      final userBuildingRestrictions = updatedUser.objectPermissionIds ?? [];

      // debugPrint('User building restrictions: $userBuildingRestrictions');

      final filteredBookingsData =
          bookings
              .where(
                (booking) => userBuildingRestrictions.contains(
                  int.parse(booking.objectId.toString()),
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
    selectedObjectFilterId.value = buildinId;
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
    selectedObjectFilterId.value = 0; // Reset to 'All'
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

  void sortByPropertyName<T>(
    int sortColumnIndex,
    bool ascending,
    Comparable Function(BookingModel) getProperty,
  ) {
    sortByProperty(sortColumnIndex, ascending, getProperty);
  }

  Future<bool> updateBookingStatus(BookingModel item, int status) async {
    return await UserRepository.instance.updateUserBookingStatus(
      int.parse(item.id!),
      status,
    );
  }

  @override
  bool containsSearchQuery(BookingModel item, String query) {
    return item.createdByName!.toLowerCase().contains(query.toLowerCase()) ||
        item.title!.toLowerCase().contains(query.toLowerCase()) ||
        item.objectName!.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<bool> deleteItem(BookingModel item) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<List<BookingModel>> fetchItems() async {
    final result =
        await ObjectRepository.instance.fetchObjectsBookingsByCompanyId();

    final updatedUser = await userController.fetchUserDetails();

    final userObjectRestrictions = updatedUser.objectPermissionIds ?? [];

    // debugPrint('User building restrictions: $userBuildingRestrictions');

    final filteredBookings =
        result
            .where(
              (booking) => userObjectRestrictions.contains(
                int.parse(booking.objectId.toString()),
              ),
            )
            .toList();

    return filteredBookings;
  }
}
