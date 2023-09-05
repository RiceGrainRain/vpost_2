import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text('Today\'s opportunities', style: TextStyle(color: greenColor),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.info_circle)),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: PostCard(),
      ),
    );
  }
}
