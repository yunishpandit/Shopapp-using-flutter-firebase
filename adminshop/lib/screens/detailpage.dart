import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Detailpage extends StatefulWidget {
  const Detailpage({Key? key, required this.data, required this.id})
      : super(key: key);
  final DocumentSnapshot data;
  final String id;

  @override
  _DetailpageState createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  bool isred = false;
  var activeindex = 0;
  int count = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List images = widget.data["images"];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      bottomSheet: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  "Add to cart",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int i, int pageViewIndex) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.data["images"][i],
                              )),
                          color: Colors.grey[350]),
                    ),
                  );
                },
                options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeindex = index;
                      });
                    },
                    initialPage: 0,
                    height: 250,
                    pageSnapping: true,
                    autoPlay: false,
                    viewportFraction: 1,
                    aspectRatio: 2.2,
                    enlargeCenterPage: true)),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: AnimatedSmoothIndicator(
                  curve: Curves.linear,
                  activeIndex: activeindex,
                  effect: const SlideEffect(
                      spacing: 8.0,
                      dotWidth: 20.0,
                      dotHeight: 10.0,
                      paintStyle: PaintingStyle.fill,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.indigo),
                  count: images.length),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.data["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isred = !isred;
                        });
                      },
                      icon: const Icon(Icons.favorite_border))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (count > 1) {
                                count--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove)),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              count++;
                            });
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  Text(
                    "\$${int.parse(widget.data["price"]) * count}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "About",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.data["about"],
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recommended",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("See all"))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("recommended")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    final docs = snapshots.data!.docs;
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 4,
                                crossAxisCount: 2,
                                childAspectRatio: 0.7),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((context, index) {
                          final data = docs[index].data();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => Detailpage(
                                            data: docs[index],
                                            id: docs[index].id))));
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(data["image"]),
                                                fit: BoxFit.cover)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "\$" + data["price"],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const Text(
                                                  "\$100",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Color.fromARGB(
                                                          255, 112, 111, 111),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.favorite_border))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
