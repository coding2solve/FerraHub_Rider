import 'package:ferrahub/AllScreens/registerationScreen.dart';
import 'package:ferrahub/AllWidgets/progressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {

  static const String idScreen= "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height:100.0,),
                Image(
                  image: AssetImage("images/icon.png"),
                  width: 400.0,
                  height: 100.0,
                  alignment: Alignment.center,
                ),


                SizedBox(height:25.0,),
                Text(
                  "Login to Request",
                  style:TextStyle(fontSize:24.0,fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),


                Padding(
                  padding:EdgeInsets.all(20.0),
                  child:Column(
                    children:[
                      SizedBox(height:1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration:InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color : Colors.grey,
                              fontSize:10.0,
                            ),
                        ),
                        style: TextStyle(fontSize:14.0),
                      ),

                      SizedBox(height:1.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration:InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color : Colors.grey,
                            fontSize:10.0,
                          ),
                        ),
                        style: TextStyle(fontSize:14.0),
                      ),
                  SizedBox(height:20.0,),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                     child: Container(
                        height :50.0,
                       child : Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize:18.0, fontFamily:"Brand Bold"),
                          ),
                       ),
                     ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),

                  ),
                    onPressed:()
                    {
                      if (!emailTextEditingController.text.contains("@"))
                      {
                        displayToastMessage("Email address is not valid", context);
                      }
                      else if(passwordTextEditingController.text.length < 1)
                      {
                        displayToastMessage("Invalid password ", context);
                      }
                      else
                      {
                        loginAndAuthenticateUser(context);
                      }

                    },
                  ),


                    ],
                  ),
                ),


                FlatButton(
                    onPressed:()
                    {
                      Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
                    },

                    child: Text(
                      "Don't have an Account? Sign up Here.",
                    )
                )
              ],

            ),
          ),
        ),
    );



  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async
  {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
        {
          return ProgressDialog(message:"Authenticating, Please wait...",);
        }

    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error" + errMsg.toString(),context);
    })).user;

    if (firebaseUser != null)
    {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if(snap.value != null)
          {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen,(route) => false);
            displayToastMessage("Successfully logged in", context);
          }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this user. Please Sign up!",context);
        }
        });
    }
        else
        {
          Navigator.pop(context);
          displayToastMessage("Error occurred, can not be Signed-in", context);
        }
   }
  }

