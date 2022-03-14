import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Mappage extends StatefulWidget {
  final DocumentSnapshot data;

  const Mappage({Key? key, required this.data}) : super(key: key);

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];

  @override
  void initState() {
    _marker.add(Marker(
        position: LatLng(widget.data["lag"], widget.data["log"]),
        infoWindow: const InfoWindow(title: "User location"),
        markerId: const MarkerId("1")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                markers: Set<Marker>.of(_marker),
                initialCameraPosition: CameraPosition(
                    zoom: 20,
                    target: LatLng(widget.data["lag"], widget.data["log"]))),
            Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)))
          ],
        ),
      ),
    );
  }
}
