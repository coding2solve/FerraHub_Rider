import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';


String mapkey= "AIzaSyCxPiirmITysj0K7IG3ELFoxoy4u23AUYA";

User firebaseUser;
User userCurrentInfo;
User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;