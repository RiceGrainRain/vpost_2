import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookmarkButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onPressed;
  BookmarkButton({super.key, required this.isLiked, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        size: 30,
        isLiked ? Icons.bookmark: Icons.bookmark_border,
        color: isLiked? Colors.amber: Colors.grey,
      ),
    );
  }
}
