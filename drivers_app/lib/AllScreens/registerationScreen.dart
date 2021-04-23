import 'package:drivers_app/AllScreens/carInfoScreen.dart';
import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/AllWidgets/progressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../configMaps.dart';
import '../main.dart';
import 'mainscreen.dart';


// ignore: must_be_immutable, camel_case_types
class RegisterationScreen extends StatelessWidget {

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController name2TextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              SizedBox(height: 90.0,),
              Image(
                image: AssetImage("images/icon.png"),
                width: 400.0,
                height: 100.0,
                alignment: Alignment.center,
              ),


              SizedBox(height: 25.0,),
              Text(
                "Signup to Drive",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),


              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "FirstName",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: name2TextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "LastName",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone ",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),


                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Sign up now",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),

                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.length < 3)
                        {
                          displayToastMessage("Name must be atleast 3 characters", context);
                        }
                        else if(name2TextEditingController.text.length < 3)
                        {
                          displayToastMessage("Name must be atleast 3 characters", context);
                        }
                        else if (!emailTextEditingController.text.contains("@"))
                        {
                          displayToastMessage("Email address is not valid", context);
                        }
                        else if (phoneTextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Phone Number is mandatory", context);
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                        displayToastMessage("Password must be atleast 5 characters", context);
                        }
                        else
                        {
                        registerNewUser(context);
                        }//registerNewUser(context);

                      },
                    ),


                  ],
                ),
              ),

              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },

                  child: Text(
                    "Already have an Account? Login Here.",
                  )
              )
            ],

          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message:"Registering, Please wait...",);
        }

    );
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error" + errMsg.toString(),context);
    })).user;

    if (firebaseUser != null)
    {
      //user created info to db
      Map userDataMap = {
         "firstname": nameTextEditingController.text.trim(),
         "lastname": name2TextEditingController.text.trim(),
         "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
     driversRef.child(firebaseUser.uid).set(userDataMap);
      currentfirebaseUser = firebaseUser;
      displayToastMessage("Congratulations, your Account has been created", context);
      Navigator.pushNamedAndRemoveUntil(context, CarInfoScreen.idScreen,(route) => false);

    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("User account has not been created",context);
    }
  }


}

displayToastMessage(String message, BuildContext context)
{
Fluttertoast.showToast(msg:message);
}
