import 'package:flutter/material.dart';

class Fullscreen extends StatelessWidget {
  const Fullscreen({Key? key, required this.data}) : super(key: key);
  final String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        child: Center(child: Image.network(data)),
      ),
    );
  }
}
