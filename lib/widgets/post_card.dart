import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/models/user.dart' as model;
import 'package:vpost_2/providers/user_provider.dart';
import 'package:vpost_2/resources/firestore_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/like_button.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    isLiked = widget.snap['bookmarks'].contains(currentUser.uid);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
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
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
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
            child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
          ),

          Container(
            height: 117,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: RichText(
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

          //bookmark, share
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, left: 10),
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
                          size: 28,
                          color: Colors.grey,
                        ),
                      ),
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
                        padding: const EdgeInsets.only(bottom: 5.0, left: 60),
                        child: Text(
                          widget.snap['location'],
                          style: const TextStyle(color: blueColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
