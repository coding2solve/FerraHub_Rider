import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {

  String id;
  String email;
  String firstname;
  String lastname;
  String phone;

  Users({this.id, this.email, this.firstname, this.lastname, this.phone,});

  Users.fromSnapshot(DataSnapshot dataSnapshot)

  {
    id= dataSnapshot.key;
    email= dataSnapshot.value["email"];
    firstname= dataSnapshot.value["firstname"];
    lastname= dataSnapshot.value["lastname"];
    phone= dataSnapshot.value["phone"];

  }
}