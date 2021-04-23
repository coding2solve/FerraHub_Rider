import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'mainscreen.dart';

class CarInfoScreen extends StatelessWidget {

  static const String idScreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/logo.png",width:399.0, height: 250.0,),
               Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0,22.0, 32.0),
                 child: Column(
                   children: [
                     SizedBox(height: 12.0,),
                      Text("Enter Car Details", style: TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),),
                      SizedBox(height: 26.0,),
                     TextField(
                       controller: carModelTextEditingController,
                       decoration:  InputDecoration(
                         labelText: "Car Model",
                         hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                       ),
                       style: TextStyle(fontSize: 15.0),
                     ),

                     SizedBox(height: 10.0,),
                     TextField(
                       controller: carNumberTextEditingController,
                       decoration:  InputDecoration(
                         labelText: "Car Number",
                         hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                       ),
                       style: TextStyle(fontSize: 15.0),
                     ),

                     SizedBox(height: 10.0,),
                     TextField(
                       controller: carColorTextEditingController,
                       decoration:  InputDecoration(
                         labelText: "Car Color",
                         hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                       ),
                       style: TextStyle(fontSize: 15.0),
                     ),
                     SizedBox(height: 42.0,),

                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: 16.0),
                       // ignore: deprecated_member_use
                       child: RaisedButton(
                         onPressed: ()
                         {
                         if(carModelTextEditingController.text.isEmpty)
                           {
                             displayToastMessage("Insert Car Model", context);
                           }
                         else if(carColorTextEditingController.text.isEmpty)
                         {
                           displayToastMessage("Insert Car Color", context);
                         }
                        else if(carNumberTextEditingController.text.isEmpty)
                         {
                           displayToastMessage("Insert Car Number", context);
                         }
                        else
                          {
                            saveDriveCarInfo(context);
                          }

                         },
                         color: Colors.black,
                         child: Padding(
                           padding: EdgeInsets.all(17.0),
                           child:Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text("Continue", style:TextStyle(fontSize:18.0, fontWeight: FontWeight.bold, color: Colors.white),),
                               Icon(Icons.arrow_forward, color: Colors.white,size:25.0,)
                             ],
                           ),
                         ),
                       ),

                     ),

                   ],
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void saveDriveCarInfo(context){
    String userId = currentfirebaseUser.uid;

    Map carInfoMap = {
      "car_color" : carColorTextEditingController.text,
      "car_number" : carNumberTextEditingController.text,
      "car_model" : carModelTextEditingController.text,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}
