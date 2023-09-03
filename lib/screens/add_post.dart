import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
/*      return  Center(
      child: IconButton(
         icon: const Icon(Icons.upload),
         onPressed: () {

        },
        )
     ); */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('create post'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Post',
              style: TextStyle(
                  color: greenColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage("https://i.stack.imgur.com/l60Hf.png"),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.3,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Give a description...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/51,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: NetworkImage("https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg"),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.center,
                      ),
                    ),
                  ),
                  ),
              )
            ],
          )
        ],
      ),
    );
  }
}
