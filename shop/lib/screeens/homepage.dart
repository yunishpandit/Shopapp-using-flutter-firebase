import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screeens/tabs/cart.dart';
import 'package:shop/screeens/tabs/favourite.dart';
import 'package:shop/screeens/tabs/home.dart';
import 'package:shop/screeens/tabs/message.dart';
import 'package:shop/screeens/tabs/profile.dart';
import 'package:shop/services/firebaseoperation.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int select = 0;
  List<Widget> childern = const [
    Home(),
    Chats(),
    Cart(),
    Favourite(),
    Profile()
  ];
  void selectindex(int index) {
    setState(() {
      select = index;
    });
  }

  @override
  void initState() {
    Provider.of<Firebaseoperation>(context, listen: false)
        .initUserdata(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childern[select],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          currentIndex: select,
          onTap: selectindex,
          items: [
            const BottomNavigationBarItem(
                label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: "Message",
                icon: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("message")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        final docs = snapshots.data!.docs;

                        if (docs.isNotEmpty) {
                          return ListView.builder(
                              itemCount: docs.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final data = docs[index].data();
                                return data["messageread"] == true
                                    ? const Icon(Icons.message)
                                    : Badge(
                                        badgeColor: Colors.red,
                                        child: const Icon(Icons.message));
                              });
                        } else {
                          return const Icon(Icons.message);
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
            const BottomNavigationBarItem(
                label: "Cart", icon: Icon(Icons.shopping_cart_outlined)),
            const BottomNavigationBarItem(
                label: "Favorite", icon: Icon(Icons.favorite_border)),
            const BottomNavigationBarItem(
                label: "Profile", icon: Icon(Icons.person))
          ]),
    );
  }
}
