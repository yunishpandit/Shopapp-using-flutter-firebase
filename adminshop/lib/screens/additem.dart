import 'dart:io';

import 'package:adminshop/services/firebaseoperation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Additems extends StatefulWidget {
  const Additems({Key? key}) : super(key: key);

  @override
  _AdditemsState createState() => _AdditemsState();
}

class _AdditemsState extends State<Additems> {
  bool isloading = false;
  XFile? singleimage;
  List<XFile>? multipleimages;
  String? downloadimage;
  List<String>? images;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Add items",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            singleimage != null
                ? Image.file(File(singleimage!.path))
                : SvgPicture.asset(
                    "images/addphoto.svg",
                    height: 150,
                    width: 150,
                  ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick coverimage"),
                  onPressed: () async {
                    singleimage = await singleimagepick();
                    if (singleimage != null) {
                      setState(() {});
                      downloadimage = await uploadimage(singleimage!);
                    }
                  }),
            ),
            multipleimages != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: multipleimages!
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(e.path),
                                  height: 150,
                                  width: 100,
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : SvgPicture.asset(
                    "images/multiimg.svg",
                    height: 150,
                    width: 150,
                  ),
            MaterialButton(
                color: Colors.blue,
                child: const Text("Pick images"),
                onPressed: () async {
                  multipleimages = await multipleimagepick();
                  if (multipleimages != null) {
                    setState(() {});
                    images = await uploadmultipleimages(multipleimages!);
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Add name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: price,
                decoration: const InputDecoration(
                  hintText: "Add price",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: null,
                textInputAction: TextInputAction.done,
                controller: description,
                decoration: const InputDecoration(
                  hintText: "Add Description",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isloading = true;
                });
                Provider.of<Firebaseoperation>(context, listen: false)
                    .uploaditems(name.text, description.text, downloadimage!,
                        images!, price.text);
                setState(() {
                  isloading = false;
                });
              },
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.6),
                ),
                child: Center(
                  child: isloading
                      ? const CircularProgressIndicator(
                          color: Colors.blue,
                        )
                      : const Text(
                          "ADD Item",
                          style: TextStyle(color: Colors.blue),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        )),
      ),
    );
  }
}

Future<XFile?> singleimagepick() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}

Future<List<XFile>> multipleimagepick() async {
  List<XFile>? images = await ImagePicker().pickMultiImage();
  if (images!.isNotEmpty) {
    return images;
  }
  return [];
}

Future<String> uploadimage(
  XFile image,
) async {
  Reference db = FirebaseStorage.instance.ref("images/${getimagename(image)}");
  await db.putFile(File(image.path));
  return await db.getDownloadURL();
}

String getimagename(XFile image) {
  return image.path.split("/").last;
}

Future<List<String>> uploadmultipleimages(
  List<XFile> list,
) async {
  List<String> _path = [];
  for (XFile _image in list) {
    _path.add(await uploadimage(_image));
  }
  return _path;
}
