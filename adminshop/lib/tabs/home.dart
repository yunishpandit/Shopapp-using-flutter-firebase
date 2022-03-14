import 'package:adminshop/screens/additem.dart';
import 'package:adminshop/screens/detailpage.dart';
import 'package:adminshop/services/helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var activeindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Hello,",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data!.data()!["name"],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Let's get something?",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Shimmer.fromColors(
                                child: Container(
                                  height: 10,
                                  width: 20,
                                  color: Colors.white,
                                ),
                                baseColor: Colors.grey,
                                highlightColor: Colors.grey);
                          }
                        }),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications)),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("user")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!.data()!["image"] == null
                                    ? ClipOval(
                                        child: Image.asset(
                                          "images/profile.png",
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            snapshot.data!.data()!["image"]),
                                      );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color.fromARGB(255, 170, 167, 167)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.search),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Search here",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Categories",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(onPressed: () {}, child: const Text("See all")),
                    TextButton(onPressed: () {}, child: const Text("Add item"))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("categories")
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          final docs = snapshots.data!.docs;
                          return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  width: 20,
                                );
                              },
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: docs.length,
                              itemBuilder: ((context, index) {
                                final data = docs[index].data();
                                return Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 228, 224, 224),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Image.network(
                                              data["image"],
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          data["name"],
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 112, 111, 111)),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              Provider.of<Helper>(context,
                                                      listen: false)
                                                  .showoption(context, () {});
                                            },
                                            icon: const Icon(
                                                Icons.more_vert_outlined))),
                                  ],
                                );
                              }));
                        } else {
                          return Shimmer.fromColors(
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    width: 20,
                                  );
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 228, 224, 224),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  );
                                })),
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey,
                          );
                        }
                      }),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text("Add item")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 260,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("Bestselling")
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.hasData) {
                          final docs = snapshots.data!.docs;
                          return Column(
                            children: [
                              CarouselSlider.builder(
                                  itemCount: docs.length,
                                  itemBuilder: (BuildContext context, int i,
                                      int pageViewIndex) {
                                    final data = docs[i].data();
                                    return Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        Detailpage(
                                                          data: docs[i],
                                                          id: docs[i].id,
                                                        ))));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      data["image"],
                                                    )),
                                                color: const Color(0xFFD6D6D6)),
                                          ),
                                        ),
                                        Positioned(
                                            right: 0,
                                            top: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  Provider.of<Helper>(context,
                                                          listen: false)
                                                      .showoption(context, () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Bestselling")
                                                        .doc(data[i].id)
                                                        .delete();
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.more_vert_outlined))),
                                      ],
                                    );
                                  },
                                  options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          activeindex = index;
                                        });
                                      },
                                      initialPage: 0,
                                      height: 240,
                                      pageSnapping: true,
                                      autoPlay: true,
                                      viewportFraction: 1,
                                      aspectRatio: 2.2,
                                      enlargeCenterPage: true)),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: AnimatedSmoothIndicator(
                                    curve: Curves.linear,
                                    activeIndex: activeindex,
                                    effect: const SlideEffect(
                                        spacing: 8.0,
                                        dotWidth: 10.0,
                                        dotHeight: 10.0,
                                        paintStyle: PaintingStyle.fill,
                                        dotColor: Colors.grey,
                                        activeDotColor: Colors.indigo),
                                    count: docs.length),
                              ),
                            ],
                          );
                        } else {
                          return Shimmer.fromColors(
                            child: SizedBox(
                              height: 260,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    Container(
                                        height: 240,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            baseColor: Colors.grey,
                            highlightColor: Colors.grey,
                          );
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Bestselling",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(onPressed: () {}, child: const Text("See all")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Additems())));
                        },
                        child: const Text("Add item"))
                  ],
                ),
              ),
              SizedBox(
                height: 270,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("Bestselling")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        final docs = snapshots.data!.docs;
                        return ListView.separated(
                            separatorBuilder: ((context, index) {
                              return const SizedBox(
                                width: 3,
                              );
                            }),
                            shrinkWrap: true,
                            itemCount: docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              final data = docs[index].data();

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      Detailpage(
                                                        data: docs[index],
                                                        id: docs[index].id,
                                                      ))));
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              data["image"]),
                                                          fit: BoxFit.cover)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    data["name"],
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 112, 111, 111),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "\$" +
                                                                data["price"],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Text(
                                                            "\$100",
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        112,
                                                                        111,
                                                                        111),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons
                                                              .favorite_border))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: IconButton(
                                            onPressed: () {
                                              Provider.of<Helper>(context,
                                                      listen: false)
                                                  .showoption(context, () {});
                                            },
                                            icon: const Icon(
                                                Icons.more_vert_outlined))),
                                  ],
                                ),
                              );
                            }));
                      } else {
                        return ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                  child: SizedBox(
                                    height: 270,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                color: Colors.white,
                                                height: 10,
                                                width: 150,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey.shade700);
                            });
                      }
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recommended",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(onPressed: () {}, child: const Text("See all")),
                    TextButton(onPressed: () {}, child: const Text("Add item"))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 270,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("recommended")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasData) {
                        final docs = snapshots.data!.docs;

                        return ListView.separated(
                            separatorBuilder: ((context, index) {
                              return const SizedBox(
                                width: 10,
                              );
                            }),
                            shrinkWrap: true,
                            itemCount: docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              final data = docs[index].data();

                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Detailpage(
                                                      data: docs[index],
                                                      id: docs[index].id,
                                                    ))));
                                      },
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 150,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            data["image"]),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  data["name"],
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 112, 111, 111),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "\$" + data["price"],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Text(
                                                          "\$100",
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      112,
                                                                      111,
                                                                      111),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(Icons
                                                            .favorite_border))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            Provider.of<Helper>(context,
                                                    listen: false)
                                                .showoption(context, () {});
                                          },
                                          icon: const Icon(
                                              Icons.more_vert_outlined))),
                                ],
                              );
                            }));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Menuitem {
  itme1,
  item2,
}
