import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:vpost_2/resources/autocomplate_prediction.dart';
import 'package:vpost_2/resources/maps_network_method.dart';
import 'package:vpost_2/resources/place_auto_complate_response.dart';
import 'package:vpost_2/responsive/mobile_screen_layout.dart';
import 'package:vpost_2/responsive/responsive_layout.dart';
import 'package:vpost_2/responsive/web_layout.dart';
import 'package:vpost_2/screens/login.dart';
import 'package:vpost_2/utils/global_variables.dart';
import 'package:vpost_2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/resources/auth_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/location_tile.dart';
import 'package:vpost_2/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<AutocompletePrediction> placePredictions = [];
  bool isLocationListVisible = false;
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _infoLinkFocusNode = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userLocationController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _userLocationController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      userAge: _ageController.text.trim(),
      userLocation: _userLocationController.text.trim(),
      file: _image!,
    );

    setState(
      () {
        _isLoading = false;
      },
    );

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Add focus listeners
    _firstNameController.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _lastNameController.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _ageController.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _passwordController.addListener(() {
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

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(flex: 2, child: Container()),
          const SizedBox(
            height: 20,
          ),

          const SizedBox(height: 40),

          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage:
                          NetworkImage("https://i.stack.imgur.com/l60Hf.png"),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          TextFieldInput(
              focusNode: _firstNameFocusNode,
              textEditingController: _firstNameController,
              hintText: "First Name",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 20,
          ),

          TextFieldInput(
              focusNode: _lastNameFocusNode,
              textEditingController: _lastNameController,
              hintText: "Last Name",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 20,
          ),

          TextFieldInput(
              focusNode: _ageFocusNode,
              textEditingController: _ageController,
              hintText: "Age",
              textInputType: TextInputType.number),

          const SizedBox(
            height: 20,
          ),

          //email
          TextFieldInput(
              focusNode: _emailFocusNode,
              textEditingController: _emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress),

          const SizedBox(
            height: 20,
          ),

          //password
          TextFieldInput(
            focusNode: _passwordFocusNode,
            textEditingController: _passwordController,
            hintText: "Password",
            textInputType: TextInputType.text,
            isPass: true,
          ),

          const SizedBox(
            height: 20,
          ),

          //confirm password
          TextFormField(
            controller: _userLocationController,
            decoration: InputDecoration(
              hintText: "Add Location",
              border: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context)),
              focusedBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context)),
              enabledBorder: OutlineInputBorder(
                  borderSide: Divider.createBorderSide(context)),
              filled: true,
              contentPadding: const EdgeInsets.all(8.0),
            ),
            keyboardType: TextInputType.streetAddress,
            obscureText: false,
          ),

          Visibility(
            visible: isLocationListVisible,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: placePredictions.length,
              itemBuilder: (context, index) => LocationTile(
                  location: placePredictions[index].description!,
                  press: () => setState(() {
                        _userLocationController.text =
                            placePredictions[index].description!;
                        isLocationListVisible = false;
                      })),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          //Register
          InkWell(
            onTap: signUpUser,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                color: greenColor,
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),

          const SizedBox(
            height: 12,
          ),
          Flexible(flex: 2, child: Container()),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text("Have an account already?"),
              ),
              GestureDetector(
                onTap: navigateToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      )),
    );
  }
}
