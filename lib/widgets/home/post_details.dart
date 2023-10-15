import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vpost_2/resources/firestore_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/home/post_card.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({
    super.key,
    required this.widget,
  });

  final PostCard widget;


  @override
  Widget build(BuildContext context) {
    return Row(
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
                      color: primaryColor,
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
                          onTap: () {
                            FireStoreMethods()
                                .deletePost(widget.snap['postId']);
                            Navigator.pop(context);
                          },
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
          icon: const Padding(
            padding: EdgeInsets.only(right: 20.0, bottom: 20),
            child: Icon(Icons.more_horiz, size: 28,),
          ),
        ),
      ],
    );
  }
}