import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:provider/provider.dart';
import 'package:vpost_2/resources/autocomplate_prediction.dart';
import 'package:vpost_2/resources/place_auto_complate_response.dart';
import 'package:vpost_2/widgets/location_tile.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../resources/maps_network_method.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String description = 'Add a description';
  List<AutocompletePrediction> placePredictions = [];
  Uint8List? _file;
  bool isLoading = false;
  bool isLocationListVisible = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _hoursFocusNode = FocusNode();
  final FocusNode _tagFocusNode = FocusNode();
  final FocusNode _infoLinkFocusNode = FocusNode();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _infoLinkController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  void placeAutocomplate(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json', //unencoder path
        {
          "input": query,
          "key": apiKey,
        });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Add focus listeners
    _titleFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _descriptionFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _hoursFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _tagFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _infoLinkFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = true;
      });
    });
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
        int.parse(_hoursController.text),
        _tagController.text,
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
                'Post Description',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    postImage(
                      userProvider.getUser.email,
                      userProvider.getUser.uid,
                      userProvider.getUser.displayName,
                      userProvider.getUser.photoUrl,
                      userProvider.getUser.userAge,
                    );
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(
                    color: primaryColor,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: TextField(
                          focusNode: _titleFocusNode,
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
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: MarkdownTextInput(
                          (String value) => setState(() => description = value),
                          description,
                          label: 'Description',
                          maxLines: 4,
                          actions: MarkdownType.values,
                          controller: _descriptionController,
                          textStyle: TextStyle(fontSize: 16),
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
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: TextField(
                          focusNode: _hoursFocusNode,
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _hoursController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.arrow_forward_ios,
                                color: primaryColor, size: 14),
                            hintText: 'Hours',
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
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: TextField(
                          focusNode: _tagFocusNode,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _tagController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.arrow_forward_ios,
                                color: primaryColor, size: 14),
                            hintText: 'Type of service... Eg. Senior Care',
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
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: TextFormField(
                          focusNode: _infoLinkFocusNode,
                          onChanged: (value) {
                            placeAutocomplate(value);
                          },
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
                  Visibility(
                    visible: isLocationListVisible,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: placePredictions.length,
                      itemBuilder: (context, index) => LocationTile(
                          location: placePredictions[index].description!,
                          press: () => setState(() {
                                _infoLinkController.text =
                                    placePredictions[index].description!;
                                isLocationListVisible = false;
                              })),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
