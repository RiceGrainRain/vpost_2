import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/models/user.dart' as model;
import 'package:vpost_2/providers/user_provider.dart';
import 'package:vpost_2/resources/firestore_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/bookmark_button.dart';
import 'package:vpost_2/widgets/checkmark_button.dart';

class BookmarkCard extends StatefulWidget {
  final snap;
  const BookmarkCard({super.key, required this.snap});

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
  Random random = new Random();
  bool isLiked = false;
  bool isChecked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    isLiked = widget.snap['bookmarks'].contains(currentUser.uid);
    isChecked = widget.snap['checks'].contains(currentUser.uid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void toggleCheck() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height: 250,
      decoration: const BoxDecoration(
          color: mobileSearchColor,
          borderRadius: BorderRadius.all(Radius.circular(30))),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'By ${widget.snap['displayName']} • ${DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())}',
                            style: const TextStyle(color: secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      height: 25,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: greenColor,
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Icon(
                                size: 18,
                                CupertinoIcons.clock,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                "${widget.snap['hours']} hrs ",
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: baseplateColor,
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(
                              size: 18,
                              CupertinoIcons.pin,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              "${widget.snap['tags']}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //description
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //bookmark, share
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      BookmarkButton(
                        onPressed: () {
                          FireStoreMethods().likePost(
                            widget.snap['postId'].toString(),
                            user.uid,
                            widget.snap['bookmarks'],
                          );
                          toggleLike();
                        },
                        isLiked: isLiked,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.ios_share_outlined,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      CheckmarkButton(
                        onPressed: () {
                          FireStoreMethods().checkPost(
                            widget.snap['postId'].toString(),
                            user.uid,
                            widget.snap['checks'],
                          );
                          toggleCheck();
                        },
                        isChecked: isChecked,
                      )
                    ],
                  ),
                ),
                Expanded(
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
                        padding: const EdgeInsets.only(
                            bottom: 10.0, left: 50, right: 15),
                        child: Text(
                          widget.snap['location'],
                          style: const TextStyle(
                              color: blueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
