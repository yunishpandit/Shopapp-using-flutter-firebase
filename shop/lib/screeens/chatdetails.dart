import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/firebaseoperation.dart';
import 'package:http/http.dart' as http;

class Chatscrean extends StatefulWidget {
  final DocumentSnapshot post;

  const Chatscrean({Key? key, required this.post}) : super(key: key);
  @override
  _ChatscreanState createState() => _ChatscreanState();
}

class _ChatscreanState extends State<Chatscrean> {
  TextEditingController sendmessage = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("message")
        .doc("U3Bc6S1IzLPja2stbocTPXRA6873")
        .update({
      "messageread": true,
    });
    requestPermission();
    listenFCM();
    loadFCM();
    getToken();
    super.initState();
  }

  String? token;
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      print(token);
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void inittoken() {
    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(widget.post["uid"])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            setState(() {});
            return snapshot.data!.get("token");
          } else {
            return const Center();
          }
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

  final date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.post["name"],
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("message")
                        .doc(widget.post["uid"])
                        .collection("chat")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        final docs = snapshots.data!.docs;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              reverse: true,
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                final data = docs[index].data();
                                return Row(
                                  mainAxisAlignment: data["uid"] !=
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7),
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: data["uid"] !=
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? Colors.blue
                                                    : Colors.grey[400],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onDoubleTap: () {
                                                      FirebaseFirestore.instance
                                                          .collection("user")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection("message")
                                                          .doc(widget
                                                              .post["uid"])
                                                          .collection("chat")
                                                          .doc(docs[index].id)
                                                          .delete();
                                                    },
                                                    child: Text(
                                                      data["message"],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                        );
                      } else {
                        return const Center(
                          child: Text("loading"),
                        );
                      }
                    }),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: sendmessage,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Enter message"),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<Firebaseoperation>(context, listen: false)
                          .createmessagemy("U3Bc6S1IzLPja2stbocTPXRA6873",
                              sendmessage.text, "Customer Service");
                      Provider.of<Firebaseoperation>(context, listen: false)
                          .createmessageother(
                              "U3Bc6S1IzLPja2stbocTPXRA6873",
                              sendmessage.text,
                              Provider.of<Firebaseoperation>(context,
                                      listen: false)
                                  .inituserName
                                  .toString());
                      FirebaseFirestore.instance
                          .collection("user")
                          .doc("U3Bc6S1IzLPja2stbocTPXRA6873")
                          .collection("message")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "messageread": false,
                      });
                      FirebaseFirestore.instance
                          .collection("user")
                          .doc(widget.post["uid"])
                          .collection("message")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "lastmessage": sendmessage.text,
                      });
                      FirebaseFirestore.instance
                          .collection("user")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("message")
                          .doc("U3Bc6S1IzLPja2stbocTPXRA6873")
                          .update({
                        "lastmessage": sendmessage.text,
                      }).whenComplete(() {
                        sendmessage.clear();
                      });
                      sendPushMessage(
                          "e--9h_GLSqiGixhJlbhqXP:APA91bFjlJ2WVrQy0JdDxamS3lPIWQbTnzR1di3KjlgLedR4IpXylldWKonxOKdXh9ZMuKMCWrkAFWuDrDaIF_KxblHq49RLddnPOoc_jthwsoKQYgRDzPgLq2KyaX6oiWOC5uGUD_c8",
                          sendmessage.text,
                          "Hello");
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
