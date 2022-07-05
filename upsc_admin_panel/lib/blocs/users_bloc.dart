import 'dart:convert';

import 'package:admin/models/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersBloc extends ChangeNotifier {
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

  Future<List<MyUser>> getUserList(String? id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('admins');

     await ref.get().then((querySnapshot) {
      querySnapshot.docs.forEach((field) {
        _data.add(new MyUser.name(
            UserId: field["id"],
            Email: field["email"],
            NameSurname: field["name"],
            IsRole: field["name"].toString().length == 5
                ? "SuperAdmin"
                : "Normal"));
      });


    });


     return _data;
  }
  Query? getAdminList() {
    CollectionReference ref = FirebaseFirestore.instance.collection('admins');
    return ref;
  }

  Stream<List<MyUser>> users() {
    CollectionReference ref = FirebaseFirestore.instance.collection('admins');
    /// return ref.orderBy('updatedAt', descending: true).snapshots().map((x) => x.docs.map((y) => UserModel.fromJson(y.data())).toList());
    return ref.snapshots().map((x) => x.docs.map((y) => MyUser.fromMap(y.data() as Map<String, dynamic>)).toList());
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
