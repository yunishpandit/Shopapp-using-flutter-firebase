import 'package:adminshop/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SignInScreen(
        showAuthActionSwitch: false,
        headerBuilder: (context, constraints, _) {
          return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Text(
                "Welcome to adminapp",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )));
        },
        actions: [
          AuthStateChangeAction<SignedIn>((context, _) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
                (route) => false);
          }),
        ],
        providerConfigs: const [
          EmailProviderConfiguration(),
        ],
      ),
    ));
  }
}
