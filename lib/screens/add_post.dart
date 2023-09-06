import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _infoLinkController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage(String title, String uid, String displayName, String profImage,
      String location) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _titleController.text,
        _descriptionController.text,
        _file!,
        uid,
        displayName,
        profImage,
        _infoLinkController.text,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar("Eureka!", context);
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () => postImage(
                    userProvider.getUser.email,
                    userProvider.getUser.uid,
                    userProvider.getUser.displayName,
                    userProvider.getUser.photoUrl,
                    userProvider.getUser.userAge,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.88,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.arrow_forward_ios,
                              color: primaryColor, size: 14),
                          hintText: 'Add a title',
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: primaryColor,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: primaryColor,
                  thickness: 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.88,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _infoLinkController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.arrow_forward_ios,
                              color: primaryColor, size: 14),
                          hintText: 'Add Location',
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: primaryColor,
                  thickness: 1,
                ),
              ],
            ),
          );
  }
}
