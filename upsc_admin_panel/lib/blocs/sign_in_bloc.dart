import 'dart:convert';
import 'dart:developer';

//import 'package:baskentfirinmakina/config/config.dart';
//import 'package:baskentfirinmakina/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
   // checkSignIn();
    // checkGuestUser();
  //  initPackageInfo();
  }

  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  // final FacebookAuth _fbAuth = FacebookAuth.instance;
  final String defaultUserImageUrl =
      'https://www.oxfordglobal.co.uk/nextgen-omics-series-us/wp-content/uploads/sites/16/2020/03/Jianming-Xu-e5cb47b9ddeec15f595e7000717da3fe.png';

  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;

  bool get hasError => _hasError;

  String? _errorCode;

  String? get errorCode => _errorCode;

  String _email = "";

  String get email => _email;

  String _isRole = "Super Admin";

  String get isRole => _isRole;

  String _password = "";

  String get password => _password;

  String _appVersion = '0.0';

  String get appVersion => _appVersion;

  String _packageName = '';

  String get packageName => _packageName;

  void initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      User? currentUser;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword)
          .then((fAuth) async {
        currentUser = fAuth.user;
        log(currentUser!.email.toString());
        log(currentUser!.uid.toString());
        if (currentUser != null ) {
          // String source = Utf8Decoder().convert(response.bodyBytes);
          //check it is admin or not
          await FirebaseFirestore.instance
              .collection("admins")
              .doc(currentUser!.uid)
              .get().then((snap) {
            if(snap.exists)
            {
              //it is admin
              //allow come in
              _email = currentUser!.email!;
              _password = userPassword;
              _isSignedIn = true;
              if(currentUser!.uid.contains("rYztq8sPFYZm6ixxxtDr16AkHG83"))
                {_isRole = "SuperAdmin";}
              else {
                _isRole = "User";
              }
              setSignIn().then((value){
                saveDataToSP().then((value){

                });
              });

              _hasError = false;
              notifyListeners();
            }
            else {
              _hasError = true;
              _errorCode = "No record found "; //e.toString();
              notifyListeners();
              //No record found
            }
          });
        }
      }).onError((error, stackTrace) {
        _hasError = true;
        _errorCode = "Error : $error"; //e.toString();
        notifyListeners();
      });





    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }



  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();


    await sp.setString('email', _email);
    await sp.setString('isRole', _isRole);
    await sp.setBool('isSigned', _isSignedIn);
    await sp.setString('password', _password);
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    _email = sp.getString('email') ?? "";
    _password = sp.getString('password') ?? "";
    _isRole = sp.getString('isRole') ??"";
    _isSignedIn = sp.getBool('isSigned') ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    await sp.setBool('isSigned', _isSignedIn);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
    print("Sign out Worked");
  }

  Future afterUserSignOut() async {
    await userSignout().then((_) async {
      await clearAllData();
      _isSignedIn = false;
      //  _guestUser = false;
      notifyListeners();
    });
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
}
