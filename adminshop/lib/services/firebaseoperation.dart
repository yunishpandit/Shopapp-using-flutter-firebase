import 'dart:convert';
import 'package:adminshop/tabs/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Firebaseoperation with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future uploaditems(String name, String about, String image, List images,
      String price) async {
    FirebaseFirestore.instance.collection("Bestselling").add({
      "name": name,
      "about": about,
      "image": image,
      "images": FieldValue.arrayUnion(images),
      "price": price
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
      "uid": firebaseAuth.currentUser!.uid,
      "name": name,
      "message": message,
      "time": DateTime.now()
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAKcsxucE:APA91bGC5CNOoMGNSYrp4umy5xFY3lT2vVqPbGF2rOs3SClJpzfdFWRs3TiVzOg3SbvlKBdw9XEqh07xlN5AsVX4B8XJc2sYk0C-ypD7NMUecnn0zmaU37WNmdReGK679FF4nr3vUFiF',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      return null;
    }
  }

  final flutternotifaction = FlutterLocalNotificationsPlugin();
  initnotificaton(BuildContext context) {
    const androdidinitilize = AndroidInitializationSettings("ic_launcher");
    const initilazationsetting =
        InitializationSettings(android: androdidinitilize);
    flutternotifaction.initialize(
      initilazationsetting,
      onSelectNotification: (payload) {
        if (payload == null) {
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const Chats())));
        }
      },
    );
  }

  // Future addtoken() async {
  //   FirebaseFirestore.instance
  //       .collection("user")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set({"token": FirebaseMessaging.instance.getToken()});
  // }
}
