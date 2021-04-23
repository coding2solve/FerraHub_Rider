import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ferrahub/AllScreens/loginScreen.dart';
import 'package:ferrahub/AllScreens/mainscreen.dart';
import 'package:ferrahub/AllScreens/registerationScreen.dart';
import 'package:provider/provider.dart';
import 'DataHandler/appData.dart';
import 'package:ferrahub/AllScreens/searchScreen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (context) => AppData(),
    child: MaterialApp(
        title: 'FerraHub',
        theme: ThemeData(

          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser ==null ? LoginScreen.idScreen : MainScreen.idScreen,
        routes:{
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),

      },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
