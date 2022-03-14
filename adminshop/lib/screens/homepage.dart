import 'package:adminshop/tabs/home.dart';
import 'package:adminshop/tabs/message.dart';
import 'package:adminshop/tabs/profile.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> children = const [Home(), Chats(), Profile()];
  int select = 0;
  void selectindex(int index) {
    setState(() {
      select = index;
    });
  }

  @override
  void initState() {
    // Provider.of<Firebaseoperation>(context, listen: false).addtoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: selectindex,
          currentIndex: select,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: "Message"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ]),
      body: children[select],
    );
  }
}
