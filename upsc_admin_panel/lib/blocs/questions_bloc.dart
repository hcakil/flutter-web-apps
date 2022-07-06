import 'dart:convert';
import 'dart:developer';

import 'package:admin/models/main_category.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsBloc extends ChangeNotifier {
//  DocumentSnapshot? _lastVisible;
//  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<MyUser> _data = [];

  List<MyUser> get data => _data;

  /* ProductDetailModel _oneDetailModel;

  ProductDetailModel get oneDetailModel => _oneDetailModel;

  List<CategorySelect> _dataCategorySelect = [];

  List<CategorySelect> get dataCategorySelect => _dataCategorySelect;*/

  int _popSelection = 0;

  int get popupSelection => _popSelection;

  String? password = "";
  String? name = "";
  String? isRole = "";
  String? email = "";

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    name = sp.getString('name');
    email = sp.getString('email');
    password = sp.getString('password');
    isRole = sp.getString('isRole');
    notifyListeners();
  }

 /* Stream<List<CategoryData>> categories() {
   CollectionReference ref = FirebaseFirestore.instance.collection('categories');
    return ref!.snapshots().map((x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }*/
  Stream<List<QuestionModel>> listQuestion() {
    CollectionReference ref = FirebaseFirestore.instance.collection('questions');
    return ref.snapshots().map((x) => x.docs.map((y) => QuestionModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
  Future<void> updateCategoryDocument(Map<String, dynamic> data, String? id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    await ref.doc(id).update(data).then((value) {
      log('Updated: $data');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<DocumentReference> addCategoryDocument(Map data) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    return await ref.add(data).then((value) {
      value.update({CommonKeys.id: value.id});

      log('Added: $data');

      return value;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }
  Future<DocumentReference> addSubCategoryDocument(Map data) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('subCategories');
    return await ref.add(data).then((value) {
      value.update({CommonKeys.id: value.id});

      log('Added: $data');

      return value;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> removeCategoryDocument(String? id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    await ref.doc(id).delete().then((value) {
      log('Removed: $id');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }


  Stream<List<MainCategoryModel>> mainCategories() {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    return ref.snapshots().map((x) => x.docs.map((y) => MainCategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<SubCategoryModel>> subCategories() {
    CollectionReference ref = FirebaseFirestore.instance.collection('subCategories');
    return ref.snapshots().map((x) => x.docs.map((y) => SubCategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<List<MainCategoryModel>> mainCategoriesFuture({String parentCategoryId = ''}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    return await ref.get().then((x) => x.docs.map((y) => MainCategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  afterPopSelection(value, mounted) {
    _popSelection = value;
    if (value != 0)
      onCategoryRefresh(mounted, value);
    else
      onRefresh(mounted);
    notifyListeners();
  }

  onCategoryRefresh(mounted, value) {
    _isLoading = true;
    // _snap.clear();
    _data.clear();
    // _lastVisible = null;
    notifyListeners();
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted) {
    _isLoading = true;
    // _snap.clear();
    _data.clear();
    // _lastVisible = null;

    notifyListeners();
  }
}
