// community_design.dart
import 'package:flutter/material.dart';
import 'template_controller.dart';

class TemplateDesign extends StatelessWidget {
  final TemplateController controller;

  const TemplateDesign({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Template Screen',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.fetchTemplateData,
              child: const Text('Fetch Template Data'),
            ),
          ],
        ),
      ),
    );
  }
}
