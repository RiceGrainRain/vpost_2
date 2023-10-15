import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/models/user.dart' as model;
import 'package:vpost_2/providers/user_provider.dart';
import 'package:vpost_2/resources/firestore_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/user_profile/bookmark_button.dart';
import 'package:vpost_2/widgets/home/location_get.dart';
import 'package:vpost_2/widgets/home/post_details.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Random random = new Random();
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

  void randomColor(randomNumber) {
    if (randomNumber == 0) {
      setState(() {
        baseplateColor = randomColor1;
      });
    } else if (randomNumber == 1) {
      setState(() {
        baseplateColor = randomColor2;
      });
    } else if (randomNumber == 2) {
      setState(() {
        baseplateColor = randomColor3;
      });
    } else if (randomNumber == 3) {
      setState(() {
        baseplateColor = randomColor4;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    randomColor(widget.snap['tagColor']);
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height: 550,
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
            child: PostDetails(widget: widget),
          ),
          //image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
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
                    ],
                  ),
                ),
                LocationGet(
                  widget: widget,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
