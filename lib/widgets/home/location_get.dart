import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add the Firestore package
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/home/post_card.dart';

class LocationGet extends StatefulWidget {
  const LocationGet({
    super.key,
    required this.widget,
  });

  final PostCard widget;
 // Store the user's UID

  @override
  State<LocationGet> createState() => _LocationGetState();
}
final _currentUser = FirebaseAuth.instance.currentUser!;

class _LocationGetState extends State<LocationGet> {
  Future<double> _calculateDistance() async {
    // Add Firebase Firestore reference
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot userDoc = await firestore.collection('users').doc(_currentUser.uid).get();

    if (userDoc.exists) {
      final double userLat = userDoc['latitude'];
      final double userLong = userDoc['longitude'];

      final Distance distance = Distance();
      final double miles = distance.as(
        LengthUnit.Mile,
        LatLng(userLat, userLong),
        LatLng(widget.widget.snap['postLat'], widget.widget.snap['postLong']),
      );
      return miles;
    } else {
      throw Exception('User document not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () async {
            List<Location> locations = await locationFromAddress(widget.widget.snap['location']);
            Location locationConvert = locations[0];
            double latitude = locationConvert.latitude;
            double longitude = locationConvert.longitude;
            List<AvailableMap> availableMaps = await MapLauncher.installedMaps;
            await availableMaps.first.showMarker(
              coords: Coords(latitude, longitude),
              title: widget.widget.snap['location'],
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 50, right: 15),
            child: FutureBuilder<double>(
              future: _calculateDistance(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final double? miles = snapshot.data;
                  return Text(
                    '${miles?.toInt()} mi • ${widget.widget.snap['location']}',
                    style: const TextStyle(
                      color: blueColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
