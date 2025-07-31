import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';
import 'package:xm_frontend/app/utils/image_constants.dart';
import 'package:xm_frontend/presentation/widgets/custom_image_view.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String selectedLanguage = 'DE'; // Default language

  final Map<String, String> languageFlags = {
    'DE': '🇩🇪',
    'FR': '🇫🇷',
    'IT': '🇮🇹',
    'EN': '🇬🇧',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic padding based on screen width
    double horizontalPadding =
        screenWidth > 1200
            ? 80.0
            : screenWidth > 991
            ? 15.0
            : screenWidth > 640
            ? 20.0
            : 10.0;

    return Container(
      height:
          80 + MediaQuery.of(context).padding.top, // Add space for status bar
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: horizontalPadding,
        right: horizontalPadding,
      ), // Apply top padding dynamically
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween, // Space between logo & language selector
        children: [
          // Left: Logo + Branding
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgGroup232x32,
                height: 42,
                width: 42,
              ),
              const SizedBox(width: 8),

              // Text Branding
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'XM',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: '\u00A0Dashboard',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: AppColors.primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right: Language Selector (Globe Icon + Dropdown)
          PopupMenuButton<String>(
            tooltip: 'Select Language', // This overrides the default tooltip

            onSelected: (String language) {
              setState(() {
                selectedLanguage = language;
              });
              // Here, you can trigger a localization update
            },
            itemBuilder: (BuildContext context) {
              return languageFlags.keys.map((String lang) {
                return PopupMenuItem<String>(
                  value: lang,
                  child: Row(
                    children: [
                      Text(languageFlags[lang] ?? ''), // Flag emoji
                      const SizedBox(width: 8),
                      Text(lang), // Language code
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              children: [
                const Icon(Icons.language, color: Colors.black), // Globe Icon
                const SizedBox(width: 5),
                Text(
                  '${languageFlags[selectedLanguage]} $selectedLanguage',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
