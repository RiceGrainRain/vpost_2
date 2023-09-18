import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

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
        isLiked ? Icons.bookmark: Icons.bookmark_border,
        color: isLiked? Colors.amber: secondaryColor,
        size: isLiked? 38: 37, 
      ),
    );
  }
}
