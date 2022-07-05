

import 'package:admin/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainCategoryModel {
  String? id;
  String? image;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  MainCategoryModel({this.id, this.image, this.name, this.createdAt,this.updatedAt});

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryModel(
      id: json[CommonKeys.id],
      image: json[CategoryKeys.image],
      name: json[CategoryKeys.name],
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CategoryKeys.image] = this.image;
    data[CategoryKeys.name] = this.name;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
