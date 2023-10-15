import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final String location;
  final VoidCallback press;
  const LocationTile({super.key, required this.location, required this.press});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          horizontalTitleGap: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(CupertinoIcons.location_circle),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 11.0),
            child: Text(
              location,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
