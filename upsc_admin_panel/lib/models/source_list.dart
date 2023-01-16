

import 'package:admin/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SourceListModel {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  SourceListModel({this.id,  this.name, this.createdAt,this.updatedAt});

  factory SourceListModel.fromJson(Map<String, dynamic> json) {
    return SourceListModel(
      id: json[CommonKeys.id],
      name: json[CategoryKeys.name],
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CategoryKeys.name] = this.name;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
