import 'dart:io';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    final Color backgroundColor;
    final IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        backgroundColor = Colors.blue;
        icon = Icons.info;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      // ✅ Use Snackbar on Mobile
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      // ✅ Use Floating Toast on Desktop (macOS & Windows)
      showOverlayNotification((context) {
        return Align(
          alignment: Alignment.topCenter, // ✅ Ensures it stays centered
          child: Material(
            color: Colors.transparent, // ✅ Avoids full-width background
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // ✅ Fixed width
              child: Container(
                margin: const EdgeInsets.only(top: 10), // ✅ Moves down slightly
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ✅ Prevents stretching
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed:
                          () => OverlaySupportEntry.of(context)?.dismiss(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }, duration: const Duration(seconds: 3));
    }
  }
}

/// Enum for snackbar types
enum SnackbarType { success, error, warning, info }
