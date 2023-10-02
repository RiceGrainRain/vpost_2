import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/models/user.dart' as model;
import 'package:vpost_2/widgets/bookmark_card.dart';
import '../providers/user_provider.dart';

class BookmarkSection extends StatefulWidget {
  @override
  State<BookmarkSection> createState() => _BookmarkSectionState();
}

class _BookmarkSectionState extends State<BookmarkSection> {
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> posts = snapshot.data!.docs;

        final List<DocumentSnapshot> bookmarkedPosts = posts.where((doc) {
          final List<dynamic> bookmarks = doc['bookmarks'] ?? [];
          return bookmarks.contains(user.uid);
        }).toList();

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
