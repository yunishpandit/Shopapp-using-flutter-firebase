import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/homehelper.dart';

class Firebaseoperation with ChangeNotifier {
  UploadTask? task;
  String? urlDownload;
  String? inituserName;
  String? inituserEmail;
  String? inituserimage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future createuser(String name, String email, String token) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': name,
      'email': email,
      'image': urlDownload,
      'token': token
    });
  }

  Future uploadimage(String imagepath, File image) async {
    try {
      final filename = imagepath;
      final destination = 'image/$filename';
      task = FirebaseApi.uploadTask(destination, image);
      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();
    } on Exception {
      return null;
    }
  }

  Future addtocart(String name, String price, int count, String image) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc()
        .set({
      "name": name,
      "price": price,
      "totalprice": count,
      "image": image,
    });
  }

  Future initUserdata(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      inituserName = doc.data()!["name"];
      inituserEmail = doc.data()!["email"];
      inituserimage = doc.data()!["image"];

      notifyListeners();
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Geolocator.openAppSettings();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future oderofuseritems(BuildContext context, String itemname, int count,
      String image, int count1) async {
    Position position = await determinePosition();
    var lag = position.latitude;
    var log = position.longitude;

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("order")
        .doc()
        .set({
      "totalprice": count1,
      "lag": lag,
      "log": log,
      "username": inituserName,
      "email": inituserEmail,
      "itemsname": itemname,
      "count": count,
      "itemimage": image
    });
  }

  Future oderofuser(
    BuildContext context,
  ) async {
    Position position = await determinePosition();
    var lag = position.latitude;
    var log = position.longitude;

    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Cartorder")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "totalprice":
          Provider.of<Homehelper>(context, listen: false).gettotalprice(),
      "lag": lag,
      "log": log,
      "username": inituserName,
      "email": inituserEmail,
      "items": FieldValue.arrayUnion(
          Provider.of<Homehelper>(context, listen: false).userproduct),
      "count":
          Provider.of<Homehelper>(context, listen: false).userproduct.length
    });
  }

  addtofavourite(String name, String about, String image, List images,
      String price, String id) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favouriteitem")
        .doc(name)
        .set({
      "name": name,
      "productid": id,
      "about": about,
      "image": image,
      "images": FieldValue.arrayUnion(images),
      "price": price
    });
  }

  Future createmessagemy(
    String otheruseruid,
    String message,
    String name,
  ) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("message")
        .doc(otheruseruid)
        .collection("chat")
        .add({
      "uid": firebaseAuth.currentUser!.uid,
      "name": name,
      "message": message,
      "time": DateTime.now()
    });
  }

  Future createmessagemyoreder(
    String otheruseruid,
    String message,
    String name,
  ) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("message")
        .doc(otheruseruid)
        .collection("chat")
        .add({
      "uid": otheruseruid,
      "name": name,
      "message": message,
      "time": DateTime.now()
    });
  }

  Future createmessageother(
      String otheruseruid, String message, String name) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(otheruseruid)
        .collection("message")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("chat")
        .add({
      "uid": firebaseAuth.currentUser!.uid,
      "name": name,
      "message": message,
      "time": DateTime.now()
    });
  }

  Future createmessageusermy(BuildContext context, String otheruseruid,
      String message, String name, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("message")
          .doc(otheruseruid)
          .set({
        "uid": otheruseruid,
        "lastmessage": message,
        "messageread": false,
        "name": name,
        "email": email,
        "myuid": firebaseAuth.currentUser!.uid
      });
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future createmessageuserother(BuildContext context, String image,
      String otheruseruid, String message, String name, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(otheruseruid)
          .collection("message")
          .doc(firebaseAuth.currentUser!.uid)
          .set({
        "uid": firebaseAuth.currentUser!.uid,
        "name": name,
        "lastmessage": message,
        "image": image,
        "messageread": false,
        "email": firebaseAuth.currentUser!.email,
        "myuid": otheruseruid
      });
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class FirebaseApi {
  static UploadTask? uploadTask(String destination, File image) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(image);
    } on Exception {
      return null;
    }
  }
}
