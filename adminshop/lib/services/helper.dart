import 'package:flutter/material.dart';

class Helper with ChangeNotifier {
  showoption(BuildContext context, Function() ontap) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Delete"), Icon(Icons.delete)],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  InkWell(
                    onTap: ontap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("Update"), Icon(Icons.update)],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
