import 'package:flutter/material.dart';
import 'package:xm_frontend/app/theme/colors.dart';

class ProgressSteps extends StatelessWidget {
  final int currentStep;

  const ProgressSteps({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          _buildStep(
            'PERSONAL INFO',
            isActive: currentStep >= 0,
            isCompleted: currentStep > 0,
            isFirst: true,
          ),
          _buildStep(
            'AGENCY INFO',
            isActive: currentStep == 1,
            isCompleted: currentStep > 1,
          ),
          _buildStep(
            'BUILDING DETAILS',
            isActive: currentStep == 2,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    String title, {
    bool isActive = false,
    bool isCompleted = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Transform.translate(
        offset: Offset(
          isFirst ? 0 : -12, //  Shift ALL but first step (reduce gap)
          0,
        ),
        child: CustomPaint(
          painter: StepPainter(
            isActive: isActive,
            isCompleted: isCompleted,
            isFirst: isFirst,
            isLast: isLast,
          ),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive || isCompleted ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StepPainter extends CustomPainter {
  final bool isActive;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;

  StepPainter({
    required this.isActive,
    required this.isCompleted,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color =
              isCompleted
                  ? AppColors.greenA700Dark
                  : isActive
                  ? AppColors.primaryColor
                  : AppColors.whiteA700
          ..style = PaintingStyle.fill;

    final Path path = Path();

    if (isFirst) {
      //  Left rounded for the first step
      path.moveTo(10, 0);
      path.lineTo(size.width - 15, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - 15, size.height);
      path.lineTo(10, size.height);
      path.arcToPoint(Offset(10, 0), radius: const Radius.circular(20));
      path.close();
    } else if (isLast) {
      //  Right rounded for the last step (FIXED ALIGNMENT)
      path.moveTo(-15, 0); // Shift left
      path.lineTo(size.width - 10, 0);
      path.arcToPoint(
        Offset(size.width - 10, size.height),
        radius: const Radius.circular(20),
      );
      path.lineTo(-15, size.height);
      path.lineTo(0, size.height / 2);
      path.close();
    } else {
      //  Middle steps (FIXED ALIGNMENT)
      path.moveTo(-10, 0); // Shift left to close gap
      path.lineTo(size.width - 15, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - 15, size.height);
      path.lineTo(-10, size.height);
      path.lineTo(5, size.height / 2);
      path.close();
    }

    canvas.drawPath(path, paint);

    //  Draw border only if not active or completed
    final Paint borderPaint =
        Paint()
          ..color =
              isActive || isCompleted ? Colors.transparent : AppColors.gray500
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
