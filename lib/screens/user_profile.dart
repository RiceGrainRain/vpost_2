import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/edit_profile_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Your Profile'),
          centerTitle: false,
        ),
        body: ListView(
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
                                buildStatColumn(20, "Posts"),
                                buildStatColumn(40, "Bookmarks"),
                                buildStatColumn(100, "hours")
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowButton(
                                backgroundColor: mobileBackgroundColor,
                                borderColor:   Colors.grey, 
                                text: 'Edit Profile', 
                                textColor: primaryColor,
                                function: () {},
                                )
                            ],
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Column buildStatColumn(int num, String label,) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(num.toString(),
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
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey
            ),
          ),
        ),
      ],
    );
  }
}
