import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/models/user.dart' as model;
import 'package:vpost_2/widgets/bookmark_card.dart';
import '../providers/user_provider.dart';

class UserPostsSection extends StatefulWidget {
  @override
  State<UserPostsSection> createState() => _UserPostsSectionState();
}

class _UserPostsSectionState extends State<UserPostsSection> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: user.uid).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> userPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: userPosts.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookmarkCard(
                snap: userPosts[index].data(),
              ),
            );
          },
        );
      },
    );
  }
}
