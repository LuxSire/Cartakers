import 'package:flutter/widgets.dart';
import 'package:xm_frontend/data/api/translation_api.dart';
import 'package:xm_frontend/data/models/contract_model.dart';
import 'package:xm_frontend/utils/formatters/formatter.dart';

class UnitRoomModel {
  final String? id;
  final String? piece;

  UnitRoomModel({this.id, this.piece});

  // Convert JSON response to UnitModel
  factory UnitRoomModel.fromJson(Map<String, dynamic> json) {
    return UnitRoomModel(
      id: json['id']?.toString() ?? '',
      piece: json['piece']?.toString() ?? '',
    );
  }

  // create toJson function
  Map<String, dynamic> toJson() {
    return {'id': id, 'piece': piece};
  }

  /// Static function to create an empty request model.
  static UnitRoomModel empty() => UnitRoomModel(id: '');
}
