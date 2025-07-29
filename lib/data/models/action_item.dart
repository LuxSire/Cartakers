// action_item.dart
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ActionItem {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackground;

  ActionItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackground,
  });
}
