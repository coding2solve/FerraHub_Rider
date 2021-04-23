import 'package:drivers_app/Assistants/requestAssistant.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/Models/address.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:drivers_app/Models/directDetails.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class AssistantMethods
{
  static Future <dynamic> searchCoordinateAddress(Position position, context) async
  {
   String placeAddress = "";


   String st1,st2,st3,st4;
   String url = "https://maps.googleapis.com/maps/api/geocode/json?address=${position.latitude},${position.longitude}&key=$mapkey";
   var response = await RequestAssistant.getRequest(url);

   if(response != "failed"){

     //placeAddress =response["results"][0]["formatted_address"];
    st1=response["results"][0]["address_components"] [0]["long_name"];
    st2=response["results"][0]["address_components"] [1]["long_name"];
    st3=response["results"][0]["address_components"] [2]["long_name"];
    st4=response["results"][0]["address_components"] [3]["long_name"];



    placeAddress = st1 + " " + st2 + ", " + st3;

    Address userPickUpAddress = new Address();
    userPickUpAddress.longitude = position.longitude;
    userPickUpAddress.latitude = position.latitude;
    userPickUpAddress.placeName = placeAddress;

     Provider.of<AppData>(context, listen:false).updatePickUpLocationAddress(userPickUpAddress);
   }
   return placeAddress;
  }

static Future <DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
{
 String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition
     .latitude},${initialPosition.longitude}&destination=${finalPosition
     .latitude},${finalPosition.longitude}&key=$mapkey";
 var res = await RequestAssistant.getRequest(directionUrl);

 if (res == "failed") {
  return null;
 }

  DirectionDetails directionDetails = DirectionDetails();

  directionDetails.encodedPoints =
  res["routes"][0]["overview_polyline"]["points"];

  directionDetails.distanceText =
  res["routes"][0]["legs"][0]["distance"]["text"];
  directionDetails.distanceValue =
  res["routes"][0]["legs"][0]["distance"]["value"];

  directionDetails.durationText =
  res["routes"][0]["legs"][0]["duration"]["text"];
  directionDetails.durationValue =
  res["routes"][0]["legs"][0]["duration"]["value"];

  return directionDetails;
 }
 // ignore: missing_return
 static int calculateFares(DirectionDetails directionDetails)
 {
   //Prices charge in $USD
   double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
   double distanceTraveledFare  = (directionDetails.distanceValue / 1000) * 0.20;
   double totalFareAmount = timeTraveledFare + distanceTraveledFare;

   //Price charge in  South African Rands
    double totalLocalAmount= totalFareAmount * 13.99;

    return totalLocalAmount.truncate();

  }

  //function to get online or logged in user
   static void getCurrentOnlineUserInfo() async {
   firebaseUser = await FirebaseAuth.instance.currentUser;
   String userId = firebaseUser.uid;
   DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

   reference.once().then((DataSnapshot dataSnapShot)
    {
     if(dataSnapShot.value != null)
      {
       userCurrentInfo = Users.fromSnapshot(dataSnapShot) as User;
    }

  });

   }
}
