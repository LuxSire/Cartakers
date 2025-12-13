import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:cartakers/app/localization/app_localization.dart';

import '../popups/loaders.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final RxList<ConnectivityResult> _connectionStatus =
      <ConnectivityResult>[].obs;

  bool _hasHandledInitialStatus = false;

  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();

    // Check once on launch
    _checkInitialConnection();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Initial connectivity check
  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _connectionStatus.value = result;
    _hasHandledInitialStatus = true; // Mark as ready

    //  debugPrint('Initial Connection Status: $result');

    if (result == ConnectivityResult.none) {
      TLoaders.customToast(
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_no_internet_connection'),
      );
    }
  }

  /// Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    debugPrint('Connection Status: $result');

    if (!_hasHandledInitialStatus) return; // Ignore if not ready

    bool previouslyDisconnected = _connectionStatus.contains(
      ConnectivityResult.none,
    );
    _connectionStatus.value = result;

    if (result.contains(ConnectivityResult.none) && !previouslyDisconnected) {
      TLoaders.customToast(
        message: AppLocalization.of(
          Get.context!,
        ).translate('general_msgs.msg_no_internet_connection'),
      );
    }
  }

  /// Check the internet connection status.
  /// Returns `true` if connected, `false` otherwise.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();

      debugPrint('Connection Status: $result');

      if (result.any((element) => element == ConnectivityResult.none)) {
        debugPrint('false connectivity');
        return false;
      } else {
        debugPrint('true connectivity');
        return true;
      }
    } on PlatformException catch (_) {
      debugPrint('Error: Platform Exception');
      return false;
    }
  }

  /// Dispose or close the active connectivity stream.
  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
