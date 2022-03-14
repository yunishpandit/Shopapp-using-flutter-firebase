import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/firebaseoperation.dart';
import 'package:shop/services/homehelper.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    Provider.of<Homehelper>(context, listen: false).initnotificaton(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My cart",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total price:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "Rs.${Provider.of<Homehelper>(context, listen: false).gettotalprice()}")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total items:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(Provider.of<Homehelper>(context, listen: false)
                      .userproduct
                      .length
                      .toString())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (Provider.of<Homehelper>(context, listen: false)
                          .userproduct
                          .isNotEmpty) {
                        Provider.of<Firebaseoperation>(context, listen: false)
                            .determinePosition();

                        Provider.of<Firebaseoperation>(context, listen: false)
                            .oderofuser(context)
                            .whenComplete(() {
                          Provider.of<Firebaseoperation>(context, listen: false)
                              .createmessagemyoreder(
                                  "U3Bc6S1IzLPja2stbocTPXRA6873",
                                  "Your order has been placed to your current location",
                                  "Customer Service");
                          Provider.of<Firebaseoperation>(context, listen: false)
                              .createmessageother(
                                  "U3Bc6S1IzLPja2stbocTPXRA6873",
                                  "Your order has been placed to your current location",
                                  Provider.of<Firebaseoperation>(context,
                                          listen: false)
                                      .inituserName
                                      .toString());
                          Provider.of<Firebaseoperation>(context, listen: false)
                              .createmessageusermy(
                                  context,
                                  "U3Bc6S1IzLPja2stbocTPXRA6873",
                                  "Your order has been placed to your current location",
                                  "Customer Service",
                                  "david@gmail.com");
                          Provider.of<Firebaseoperation>(context, listen: false)
                              .createmessageuserother(
                                  context,
                                  Provider.of<Firebaseoperation>(context,
                                          listen: false)
                                      .inituserimage
                                      .toString(),
                                  "U3Bc6S1IzLPja2stbocTPXRA6873",
                                  "Your order has been placed to your current location",
                                  Provider.of<Firebaseoperation>(context,
                                          listen: false)
                                      .inituserName
                                      .toString(),
                                  Provider.of<Firebaseoperation>(context,
                                          listen: false)
                                      .inituserEmail
                                      .toString());
                          Provider.of<Homehelper>(context, listen: false)
                              .shownotification();
                        });
                      }
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Provider.of<Homehelper>(context, listen: false)
                    .userproduct
                    .length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    child: Image.network(
                                      Provider.of<Homehelper>(context,
                                              listen: false)
                                          .userproduct[index]["image"],
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Provider.of<Homehelper>(context,
                                              listen: false)
                                          .userproduct[index]["name"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs.${Provider.of<Homehelper>(context, listen: false).userproduct[index]["total"]}",
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.blue),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                        ),
                                        Text(
                                            "Item:${Provider.of<Homehelper>(context, listen: false).userproduct[index]["count"]}")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  Provider.of<Homehelper>(context,
                                          listen: false)
                                      .userproduct
                                      .removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.close))),
                    ],
                  );
                }),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
