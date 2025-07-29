// community_screen.dart
import 'package:flutter/material.dart';
import 'template_controller.dart';
import 'template_design.dart';

class TemplateScreen extends StatelessWidget {
  final TemplateController controller;

  const TemplateScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TemplateDesign(controller: controller);
  }
}
