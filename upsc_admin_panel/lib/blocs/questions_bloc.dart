import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:admin/constants.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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

  Stream<List<QuestionModel>> listQuestionByUser(MyUser? user,DateTime? first, DateTime? last) {
    CollectionReference ref = FirebaseFirestore.instance.collection('questions');

    return ref.where("addedBy",isEqualTo: user!.Email).where("createdAt",isGreaterThan:first).where("createdAt",isLessThan:last).snapshots().map((x) => x.docs.map((y) => QuestionModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<List<QuestionModel>>? listQuestionByUserFuture(MyUser? user,DateTime? first, DateTime? last) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('questions');
    List<QuestionModel> list =[];
    list = await ref.where("addedBy",isEqualTo: user!.Email).where("createdAt",isGreaterThan:first).where("createdAt",isLessThan:last).get().then((x) => x.docs.map((y) => QuestionModel.fromJson(y.data() as Map<String, dynamic>)).toList());

    return list;

   // return ref.where("addedBy",isEqualTo: user!.Email).where("createdAt",isGreaterThan:first).where("createdAt",isLessThan:last).snapshots().map((x) => x.docs.map((y) => QuestionModel.fromJson(y.data() as Map<String, dynamic>)).toList());
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
  Future<List<SubCategoryModel>> subCategoriesById({String parentCategoryId = ''}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('subCategories');
    print(parentCategoryId + "parent");
    List<SubCategoryModel> list =[];
    List<SubCategoryModel> listFiltered =[];
    list = await ref.get().then((x) => x.docs.map((y) => SubCategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
    list.forEach((element) {

      if(element.mainCategory!.contains(parentCategoryId))
        {
          print("filtered" + element.mainCategory.toString());
          listFiltered.add(element);
        }
    });
    return listFiltered;
  }

  Future<String> uploadFile(Uint8List? file) async {
    String image ="";


    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('questionImages')
        .child(Uuid().v1());

    //print('OS: ${Platform.operatingSystem}');
    //Reference storageReference = FirebaseStorage.instance.ref().child('img').child('$prefix${path.basename(file.path)}');
    UploadTask uploadTask = ref.putData(file!);

    log('File Uploading');
    uploadTask.whenComplete(() async {
      image = await uploadTask.snapshot.ref.getDownloadURL();
     // print(image);
    });

    return image;

  /*  return await uploadTask.then((v) async {
      log('File Uploaded');

      if (v.state == TaskState.success) {
        String url = await ref.getDownloadURL();

        log(url);

        return url;
      } else {
        throw errorSomethingWentWrong;
      }
    }).catchError((error) {
      throw error;
    });*/
  }

  Future<List<MainCategoryModel>> mainCategoriesFuture({String parentCategoryId = ''}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('mainCategories');
    return await ref.get().then((x) => x.docs.map((y) => MainCategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  //FOR BASIC CRUD OPS
  Future<void> updateDocument(Map<String, dynamic> data, String? id, String? refCame) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('$refCame');
    await ref.doc(id).update(data).then((value) {
      log('Updated: $data');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<DocumentReference> addDocument(Map data,  String? refCame) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('$refCame');
    return await ref.add(data).then((value) {
      value.update({CommonKeys.id: value.id});

      log('Added: $data');

      return value;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> removeDocument(String? id, String? refCame) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('$refCame');
    await ref.doc(id).delete().then((value) {
      log('Removed: $id');
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<List<QuestionModel>> questionListFuture({String? topicName}) async {
    Query? query;
    CollectionReference ref = FirebaseFirestore.instance.collection('questions');
    if (topicName != null) {
      query = ref.where('topic', isEqualTo: topicName);
    } else {
      query = ref;
    }


    return await query.get().then((x) => x.docs.map((y) => QuestionModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Query getQuestions({String? topicName}) {
    Query query;
    CollectionReference ref = FirebaseFirestore.instance.collection('questions');
    if (topicName != null) {
      query = ref.where('topic', isEqualTo: topicName);
    } else {
      query = ref;
    }
    return query;
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
