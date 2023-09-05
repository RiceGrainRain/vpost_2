import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

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
    );
  }
}
