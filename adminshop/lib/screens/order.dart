import 'package:adminshop/screens/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  final DocumentSnapshot data;

  const Order({Key? key, required this.data}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("user")
                  .doc(widget.data["uid"])
                  .collection("order")
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  final docs = snapshots.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("No order"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: docs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = docs[index].data();
                          return Column(
                            children: [
                              ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Mappage(data: docs[index])));
                                    },
                                    icon: const Icon(Icons.map_outlined)),
                                title: Text(data["itemsname"]),
                                subtitle: Text("Items:${data["count"]}"),
                                leading: Image.network(data["itemimage"]),
                              ),
                              Text("Price${data["totalprice"]}")
                            ],
                          );
                        });
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
