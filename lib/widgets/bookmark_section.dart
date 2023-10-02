import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/widgets/bookmark_card.dart';

class BookmarkSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> bookmarkedPosts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: bookmarkedPosts.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: BookmarkCard(
                snap: bookmarkedPosts[index].data(),
              ),
            );
          },
        );
      },
    );
  }
}
