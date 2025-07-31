import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xm_frontend/app/localization/app_localization.dart';
import 'package:xm_frontend/data/models/object_model.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/data/models/message_model.dart';
import 'package:xm_frontend/features/personalization/models/user_model.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/loaders.dart';

/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class TBaseController<T> extends GetxController {
  RxBool isLoading = true.obs; // Observables for managing loading state
  RxInt sortColumnIndex =
      1.obs; // Observable for tracking the index of the column for sorting
  RxBool sortAscending =
      true.obs; // Observable for tracking the sorting order (ascending or descending)
  RxList<T> allItems = <T>[].obs; // Observable list to store all items
  RxList<T> filteredItems =
      <T>[].obs; // Observable list to store filtered items
  RxList<bool> selectedRows =
      <bool>[].obs; // Observable list to store selected rows
  final searchTextController =
      TextEditingController(); // Controller for handling search text input

  @override
  void onInit() {
    fetchData(); // Initialize data fetching when the controller is initialized
    super.onInit();
  }

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchItems();

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<bool> deleteItem(T item);

  /// Abstract method to be implemented by subclasses for checking if an item contains the search query.
  bool containsSearchQuery(T item, String query);

  /// Common method for fetching data.
  Future<void> fetchData() async {
    try {
      isLoading.value = true; // Set loading state to true
      List<T> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems =
            await fetchItems(); // Fetch items (to be implemented in subclasses)
      }
      allItems.assignAll(
        fetchedItems,
      ); // Assign fetched items to the allItems list
      filteredItems.assignAll(
        allItems,
      ); // Initially, set filtered items to all items
      selectedRows.assignAll(
        List.generate(allItems.length, (index) => false),
      ); // Initialize selected rows
    } catch (e) {
      // Handle error (to be implemented in subclasses)
    } finally {
      isLoading.value =
          false; // Set loading state to false, regardless of success or failure
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;

      final fetchedItems = await fetchItems(); // Force fresh fetch
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(fetchedItems);
      selectedRows.assignAll(
        List.generate(fetchedItems.length, (index) => false),
      );
    } catch (e) {
      // Optionally handle
    } finally {
      isLoading.value = false;
    }
  }

  /// Common method for searching based on a query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );

    // Notify listeners about the change
    update();
  }

  /// Common method for sorting items by a property
  void sortByProperty(
    int sortColumnIndex,
    bool ascending,
    Function(T) property,
  ) {
    sortAscending.value = ascending;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }

  /// Method for adding an item to the lists.
  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(
      List.generate(allItems.length, (index) => false),
    ); // Initialize selected rows
    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for updating an item in the lists.
  void updateItemFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;

    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for removing an item from the lists.
  void removeItemFromLists(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(
      List.generate(allItems.length, (index) => false),
    ); // Initialize selected rows

    update(); // Trigger UI update
  }

  /// Common method for confirming deletion and performing the deletion.
  Future<void> confirmAndDeleteItem(T item) async {
    String itemName = '';

    // Customize item name based on type
    if (item is UserModel) {
      itemName = '${item.firstName} ${item.lastName}';
    }

    if (item is ContractModel) {
      itemName = '${item.contractCode}';
    }

    if (item is MessageModel) {
      itemName = '${item.title}';
    }

    try {
      Get.defaultDialog(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_delete_item'),
        content: Text(
          '${AppLocalization.of(Get.context!).translate('general_msgs.msg_are_you_sure_delete_item')} ${itemName.isNotEmpty ? '"$itemName"' : ''}',
        ),
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () async => await deleteOnConfirm(item),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
              ),
            ),
            child: Text(
              AppLocalization.of(
                Get.context!,
              ).translate('general_msgs.msg_yes'),
            ),
          ),
        ),
        cancel: SizedBox(
          width: 80,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.buttonHeight / 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5),
              ),
            ),
            child: Text(
              AppLocalization.of(
                Get.context!,
              ).translate('general_msgs.msg_cancel'),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in confirmAndDeleteItem: $e');
    }
  }

  /// Method to be implemented by subclasses for handling confirmation before deleting an item.
  Future<void> deleteOnConfirm(T item) async {
    try {
      // Remove the Confirmation Dialog
      TFullScreenLoader.stopLoading();

      // Start the loader
      TFullScreenLoader.popUpCircular();

      final result = await deleteItem(item);

      bool isBuilding = item is ObjectModel;

      if (result == false) {
        TFullScreenLoader.stopLoading();

        if (isBuilding) {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(Get.context!).translate(
              'general_msgs.msg_error_building_cannot_be_delete_with_active_and_terminated_contracts',
            ),
          );
        } else {
          TLoaders.errorSnackBar(
            title: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_error'),
            message: AppLocalization.of(
              Get.context!,
            ).translate('general_msgs.msg_item_not_deleted'),
          );
        }

        return;
      }

      removeItemFromLists(item);

      update();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_item_deleted'),
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_item_deleted_successfully'),
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
        title: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_error'),
        message: e.toString(),
      );
    }
  }
}
