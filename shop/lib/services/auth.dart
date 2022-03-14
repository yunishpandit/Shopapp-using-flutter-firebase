import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screeens/homepage.dart';
import 'package:shop/services/firebaseoperation.dart';

class Authclass with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? token;
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      print(token);
    });
  }

  Future registeraccount(
      BuildContext context, String name, String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Provider.of<Firebaseoperation>(context, listen: false)
          .createuser(name, email, token!);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
          (route) => false);
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
    }
  }
}
