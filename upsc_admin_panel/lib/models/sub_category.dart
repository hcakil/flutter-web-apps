

import 'package:admin/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  String? id;
  String? image;
  String? name;
  String? mainCategory;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategoryModel({this.id, this.image, this.name, this.createdAt,this.updatedAt,this.mainCategory});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json[CommonKeys.id],
      image: json[CategoryKeys.image],
      name: json[CategoryKeys.name],
      mainCategory: json[CategoryKeys.mainCategory],
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CategoryKeys.image] = this.image;
    data[CategoryKeys.mainCategory] = this.mainCategory;
    data[CategoryKeys.name] = this.name;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
