import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/screeens/chatdetails.dart';

class Chats extends StatefulWidget {
  final String? playload;
  const Chats({Key? key, this.playload}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    // Provider.of<Firebaseoperation>(context, listen: false).addtoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          Chatscrean(post: docs[index]))));
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      )),
    );
  }
}
