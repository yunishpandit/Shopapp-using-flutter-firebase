import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shop/screeens/splashscreen.dart';
import 'package:shop/services/auth.dart';
import 'package:shop/services/firebaseoperation.dart';
import 'package:shop/services/homehelper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  var androdidinitilize = const AndroidInitializationSettings(
    "ic_launcher",
  );
  var iosinitilize = const IOSInitializationSettings();
  var initilazationsetting = InitializationSettings(
    android: androdidinitilize,
    iOS: iosinitilize,
  );
  var localnotificaton = FlutterLocalNotificationsPlugin();
  localnotificaton.initialize(
    initilazationsetting,
    onSelectNotification: (payload) {},
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Firebaseoperation()),
        ChangeNotifierProvider(create: (_) => Authclass()),
        ChangeNotifierProvider(create: (_) => Homehelper())
      ],
      child: MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white),
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)))),
        debugShowCheckedModeBanner: false,
        home: const Splashscreen(),
      ),
    );
  }
}
