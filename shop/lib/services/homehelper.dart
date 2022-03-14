import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/screeens/tabs/message.dart';

class Homehelper with ChangeNotifier {
  List userproduct = [];
  final flutternotifaction = FlutterLocalNotificationsPlugin();
  initnotificaton(BuildContext context) {
    const androdidinitilize = AndroidInitializationSettings("ic_launcher");
    const initilazationsetting =
        InitializationSettings(android: androdidinitilize);
    flutternotifaction.initialize(
      initilazationsetting,
      onSelectNotification: (payload) {
        if (payload == null) {
          print("hello");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Chats(
                        playload: payload,
                      ))));
        }
      },
    );
  }

  Future shownotification() async {
    var androiddetail = const AndroidNotificationDetails(
      "channel id",
      "channel name",
      channelDescription: "description",
      importance: Importance.max,
      priority: Priority.high,
    );
    var genenralnotificationdetail = NotificationDetails(
      android: androiddetail,
    );
    flutternotifaction.show(
      0,
      "Order",
      "Your order has been submited ",
      genenralnotificationdetail,
      payload: 'item x',
    );
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  getdata(int total, String name, String image, int count, String price) {
    userproduct.add({
      "total": total,
      "name": name,
      "image": image,
      "count": count,
      "price": price
    });
  }

  gettotalprice() {
    double gettotal = 0;
    for (var element in userproduct) {
      gettotal += element["total"];
    }
    return gettotal;
  }

  showtosat(String msg) {
    Fluttertoast.showToast(
      msg: msg,
    );
  }
}
