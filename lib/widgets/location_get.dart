import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/post_card.dart';

class LocationGet extends StatelessWidget {
  const LocationGet({
    super.key,
    required this.widget,
  });

  final PostCard widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                List<Location> locations =
                    await locationFromAddress(widget.snap["location"]);
                Location locationConvert = locations[0];
                double latitude = locationConvert.latitude;
                double longitude = locationConvert.longitude;
                List<AvailableMap> availableMaps =
                    await MapLauncher.installedMaps;
                await availableMaps.first.showMarker(
                  coords: Coords(latitude, longitude),
                  title: widget.snap["location"],
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 50, right: 15),
                child: Text(
                  widget.snap['location'],
                  style: const TextStyle(color: blueColor, fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
      );
  }
}
