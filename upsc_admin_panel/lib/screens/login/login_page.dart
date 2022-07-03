import 'package:admin/blocs/sign_in_bloc.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/utils/next_screen.dart';
import 'package:admin/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserSignedIn();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2)),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.email)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.cyan, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2)),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(Icons.admin_panel_settings)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          allowAdminToLogin();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.pinkAccent),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> checkUserSignedIn() async{
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    sb.getDataFromSp().then((value)
    {
      if(sb.isSignedIn)
        {
          sb.signInwithEmailPassword(sb.email, sb.password).then((value) {

            if(sb.hasError)
            {
              openSnackbar(_scaffoldKey, sb.errorCode ?? "Something went wrong");
            }
            else{
              nextScreen(context, MainScreen());
            }

          });
        }
    });
  }

  Future<void> allowAdminToLogin() async {
openSnackbar(_scaffoldKey, "Checking credentials, Please wait..");
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    sb.signInwithEmailPassword(email, password).then((value) {

      if(sb.hasError)
        {
          openSnackbar(_scaffoldKey, sb.errorCode ?? "Something went wrong");
        }
      else{
        nextScreen(context, MainScreen());
      }

    });
  }


}
