import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/screeens/homepage.dart';
import 'package:shop/screeens/registerpage.dart';

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
        footerBuilder: (context, action) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have any account"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Registerpage()));
                  },
                  child: const Text("Register"))
            ],
          );
        },
        headerBuilder: (context, constraints, _) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Lottie.asset("images/welcome.json"));
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
