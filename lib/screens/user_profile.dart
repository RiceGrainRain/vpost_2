import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/bookmark_section.dart';
import 'package:vpost_2/widgets/edit_profile_button.dart';
import 'package:vpost_2/widgets/user_posts_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final currentUser = FirebaseAuth.instance.currentUser!;
  int postCount = 0;
  int bookmarkCount = 0;
  int serviceCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: currentUser.uid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        postCount = snapshot.docs.length;
      });
    });

    FirebaseFirestore.instance
        .collection('posts')
        .where('bookmarks', arrayContains: currentUser.uid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        bookmarkCount = snapshot.docs.length;
      });
    });

     FirebaseFirestore.instance
        .collection('posts')
        .where('checks', arrayContains: currentUser.uid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        serviceCount = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Your Profile'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          'https://plus.unsplash.com/premium_photo-1669638780803-ce74f7f3ea76?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1171&q=80'),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postCount, "Posts"),
                              buildStatColumn(bookmarkCount, "Bookmarks"),
                              buildStatColumn(serviceCount, "Services"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowButton(
                                backgroundColor: mobileBackgroundColor,
                                borderColor: Colors.grey,
                                text: 'Edit Profile',
                                textColor: primaryColor,
                                function: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // TabBar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(CupertinoIcons.bookmark_fill),
              ),
              Tab(icon: Icon(CupertinoIcons.square_favorites)),
              Tab(icon: Icon(CupertinoIcons.settings)),
            ],
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BookmarkSection(),
                UserPostsSection(),
                Center(child: Text('Section 3 Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
