import 'package:adminshop/screens/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cartorder extends StatefulWidget {
  final DocumentSnapshot data;

  const Cartorder({Key? key, required this.data}) : super(key: key);
  @override
  State<Cartorder> createState() => _CartorderState();
}

class _CartorderState extends State<Cartorder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title:
                const Text("CartOrder", style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.map))
            ]),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("user")
                      .doc(widget.data["uid"])
                      .collection("Cartorder")
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.hasData) {
                      final docs = snapshots.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data();
                            List items = data["items"];
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            trailing: Image.network(
                                                items[index]["image"]),
                                            title: Text(items[index]["name"]),
                                            subtitle: Text(
                                                "Items:${items[index]["count"]}"),
                                            leading: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.map_outlined)),
                                          ),
                                        ],
                                      );
                                    })),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Rs.${data["totalprice"].toString()}"),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Mappage(
                                                      data: docs[index])));
                                        },
                                        child: const Text("See location")),
                                  ],
                                )
                              ],
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
