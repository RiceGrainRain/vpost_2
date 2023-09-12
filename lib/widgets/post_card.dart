import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:vpost_2/utils/colors.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: mobileBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 25,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          'By ${snap['displayName']} • ${DateFormat.yMMMd().format(snap['datePublished'].toDate())}',
                          style: const TextStyle(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map(
                                (e) => InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          //image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(snap['postUrl'], fit: BoxFit.cover),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                      text: ' ${snap['description']}',
                    ),
                  ],
                ),
              ),
            ),
          ),

          //bookmark, share
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_add,
                      color: Colors.amber,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.share),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: InkWell(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(
                              snap["location"]);
                          Location locationConvert = locations[0];
                          double latitude = locationConvert.latitude;
                          double longitude = locationConvert.longitude;
                          List<AvailableMap> availableMaps = await MapLauncher.installedMaps;
                          await availableMaps.first.showMarker(
                              coords: Coords(latitude, longitude),
                              title: snap["location"],
                            );
                        },
                        child: Text(
                          snap['location'],
                          style: const TextStyle(color: blueColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
