import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/auth.dart';
import 'package:shop/services/firebaseoperation.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  File? image;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController conformpasswordcontroller = TextEditingController();
  bool isvisiable = true;
  bool isloading = false;
  GlobalKey<FormState> formkey = GlobalKey();
  pickimage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return null;
      } else {
        final imagetempory = File(image.path);
        setState(() {
          this.image = imagetempory;
        });
      }
    } on Exception {
      return null;
    }
  }

  @override
  void initState() {
    Provider.of<Authclass>(context, listen: false).getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        image == null
                            ? ClipOval(
                                child: Image.asset(
                                  "images/profile.png",
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              )
                            : ClipOval(
                                child: Image.file(
                                  image!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  pickimage();
                                },
                                icon: const Icon(Icons.camera_alt))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your name";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter name",
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                          hintText: "Enter email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordcontroller,
                        obscureText: isvisiable,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isvisiable = !isvisiable;
                                  });
                                },
                                icon: isvisiable
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: conformpasswordcontroller,
                        obscureText: isvisiable,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter your password";
                            // } else if (passwordcontroller.text !=
                            //     conformpasswordcontroller.text) {
                            //   return "Doesn't match the password";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Conform Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isvisiable = !isvisiable;
                                  });
                                },
                                icon: isvisiable
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        isloading = true;
                      });
                      if (image == null) {
                        Provider.of<Authclass>(context, listen: false)
                            .registeraccount(context, namecontroller.text,
                                emailcontroller.text, passwordcontroller.text)
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                        });
                      } else {
                        Provider.of<Firebaseoperation>(context, listen: false)
                            .uploadimage(image!.path, image!)
                            .whenComplete(() {
                          Provider.of<Authclass>(context, listen: false)
                              .registeraccount(context, namecontroller.text,
                                  emailcontroller.text, passwordcontroller.text)
                              .then((value) {
                            setState(() {
                              isloading = false;
                            });
                          });
                        });
                      }
                    } else {}
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
                              "Register",
                              style: TextStyle(color: Colors.blue),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
