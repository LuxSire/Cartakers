import 'package:flutter/material.dart';
import 'package:cartakers/app/utils/image_constants.dart';
import 'package:cartakers/presentation/widgets/custom_image_view.dart';

import '../custom_icon_button.dart';

class AppbarTrailingIconbuttonThree extends StatelessWidget {
  const AppbarTrailingIconbuttonThree({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
    this.notificationCount = 0,
  });

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Fetch the current theme
    final iconColor =
        theme.colorScheme.onBackground; // Icon color based on theme
    final backgroundColor = theme.colorScheme.surface.withOpacity(
      0.5,
    ); // Semi-transparent background

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Circle background for better visibility
            Container(
              height: height ?? 40.0,
              width: width ?? 40.0,
              decoration: BoxDecoration(
                color: backgroundColor, // Dynamic background color
                shape: BoxShape.circle,
              ),
              child: CustomIconButton(
                height: height ?? 36.0,
                width: width ?? 36.0,
                padding: const EdgeInsets.all(8.0),
                child: CustomImageView(
                  imagePath: imagePath ?? ImageConstant.imgIconNotification,
                  color: iconColor, // Dynamic icon color
                ),
              ),
            ),

            // Badge for notifications
            if (notificationCount > 0)
              Positioned(
                right: 3.0,
                top: 2.0,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error, // Badge color from theme
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$notificationCount',
                    style: TextStyle(
                      color: theme.colorScheme.onError, // Badge text color
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:tenants10/app/utils/image_constants.dart';
// import 'package:tenants10/presentation/widgets/custom_image_view.dart';
// import '../custom_icon_button.dart';

// class AppbarTrailingIconbuttonThree extends StatelessWidget {
//   const AppbarTrailingIconbuttonThree(
//       {super.key,
//       this.imagePath,
//       this.height,
//       this.width,
//       this.onTap,
//       this.margin});

//   final double? height;

//   final double? width;

//   final String? imagePath;

//   final Function? onTap;

//   final EdgeInsetsGeometry? margin;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: margin ?? EdgeInsets.zero,
//       child: GestureDetector(
//         onTap: () {
//           onTap?.call();
//         },
//         child: CustomIconButton(
//           height: height ?? 36.0,
//           width: width ?? 56.0,
//           padding: const EdgeInsets.all(8.0),
//           //   decoration: IconButtonStyleHelper.fillWhiteA,
//           child: CustomImageView(
//             imagePath: ImageConstant.imgIconNotification,
//           ),
//         ),
//       ),
//     );
//   }
// }
