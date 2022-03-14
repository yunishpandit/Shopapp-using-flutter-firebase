import 'package:adminshop/services/firebaseoperation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

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

  String? mtoken;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("message")
        .doc(widget.post["uid"])
        .update({
      "messageread": true,
    });
    // Provider.of<Firebaseoperation>(context, listen: false)
    //     .initnotificaton(context);
    // getToken();

    requestPermission();
    listenFCM();
    loadFCM();

    FirebaseMessaging.instance.subscribeToTopic("message");

    super.initState();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print(token);
      });
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

  inittoken() {}

  final date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
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
                    onPressed: () async {
                      Provider.of<Firebaseoperation>(context, listen: false)
                          .createmessageother(widget.post["uid"],
                              sendmessage.text, "Customer Service");
                      Provider.of<Firebaseoperation>(context, listen: false)
                          .createmessagemyoreder(widget.post["uid"],
                              sendmessage.text, widget.post["name"])
                          .whenComplete(() {
                        FirebaseFirestore.instance
                            .collection("user")
                            .doc(widget.post["uid"])
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
                            .doc(widget.post["uid"])
                            .update({
                          "lastmessage": sendmessage.text,
                        });
                      }).whenComplete(() {
                        sendmessage.clear();
                      });
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("user")
                          .doc(widget.post["uid"])
                          .get();
                      String token = snap["token"];
                      print(token);
                      Provider.of<Firebaseoperation>(context, listen: false)
                          .sendPushMessage(
                              token, sendmessage.text, "costumer care");
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
