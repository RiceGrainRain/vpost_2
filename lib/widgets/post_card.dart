import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: const Row(
              children: [
                Expanded(child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      Text("Username")
                    ],
                  ),
                ))
              ],
            ),
          )
        ]
        ),
    );
  }
}
