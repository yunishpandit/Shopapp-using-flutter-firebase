import 'package:adminshop/screens/cartorder.dart';
import 'package:adminshop/screens/messagedetails.dart';
import 'package:adminshop/screens/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => Chatscrean(
                                                  post: docs[index]))));
                                    },
                                    child: ListTile(
                                        leading: ClipOval(
                                          child: Image.asset(
                                            "images/profile.png",
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                        title: Text(data["name"]),
                                        subtitle: data["messageread"] == true
                                            ? Text(
                                                data["lastmessage"],
                                              )
                                            : Text(
                                                data["lastmessage"],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        Order(
                                                          data: docs[index],
                                                        ))));
                                          },
                                          child: const Text("Order")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        Cartorder(
                                                            data:
                                                                docs[index]))));
                                          },
                                          child: const Text("Cartorder")),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.map_outlined))
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(
                          child: Text(
                            "No Message",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      );
                    }
                  } else {
                    return ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                              child: Column(
                                children: [
                                  ListTile(
                                      subtitle: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      title: Container(
                                        height: 10,
                                        width: 89,
                                        color: Colors.white,
                                      ),
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey);
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
