import 'dart:io';
import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? message,
    String? confirmText,
    String? cancelText,
    IconData? icon,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Widget? content,
    bool isConfirmation = false, // Show both confirm & cancel buttons
  }) async {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final bool isDesktop = Platform.isMacOS || Platform.isWindows;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: theme.colorScheme.surface,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  isDesktop
                      ? 420.0
                      : double
                          .infinity, // Prevent full-screen width on desktops
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and Icon Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 24,
                          color:
                              isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                isDarkMode
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Message or Custom Content
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message != null) ...[
                          Text(
                            message,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  isDarkMode
                                      ? Colors.white70
                                      : theme.colorScheme.onSurface.withOpacity(
                                        0.8,
                                      ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (content != null) content,
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons - Desktop vs. Mobile Styling
                  isDesktop
                      ? ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: _buildButtons(
                          context,
                          isDarkMode,
                          theme,
                          isConfirmation,
                          onCancel,
                          onConfirm,
                          cancelText,
                          confirmText,
                        ),
                      )
                      : OverflowBar(
                        alignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: _buildButtons(
                          context,
                          isDarkMode,
                          theme,
                          isConfirmation,
                          onCancel,
                          onConfirm,
                          cancelText,
                          confirmText,
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Widget> _buildButtons(
    BuildContext context,
    bool isDarkMode,
    ThemeData theme,
    bool isConfirmation,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    String? cancelText,
    String? confirmText,
  ) {
    return [
      if (isConfirmation)
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(
            cancelText ?? 'Cancel',
            style: TextStyle(
              color:
                  isDarkMode
                      ? Colors.grey
                      : theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ElevatedButton(
        onPressed: onConfirm ?? () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(confirmText ?? 'OK'),
      ),
    ];
  }
}
