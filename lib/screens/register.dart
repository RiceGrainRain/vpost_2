import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:vpost_2/screens/location.dart';
import 'package:vpost_2/screens/login.dart';
import 'package:vpost_2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/resources/auth_methods.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _confirmPasswordController.dispose();
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
      confirmPassword: _confirmPasswordController.text.trim(),
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
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserLocationUpdate()));
/*        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResponsiveLayout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout(),),),
      ); */
    }
  }

    void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage("https://i.stack.imgur.com/l60Hf.png"),
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

              const SizedBox(height: 20),

TextFieldInput(
              textEditingController: _firstNameController,
              hintText: "First Name",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 20,
          ),

          TextFieldInput(
              textEditingController: _lastNameController,
              hintText: "Last Name",
              textInputType: TextInputType.text),

          const SizedBox(
            height: 20,
          ),

          TextFieldInput(
              textEditingController: _ageController,
              hintText: "Age",
              textInputType: TextInputType.number),

          const SizedBox(
            height: 20,
          ),

          //email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress),

          const SizedBox(
            height: 20,
          ),

          //password
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: "Password",
            textInputType: TextInputType.text,
            isPass: true,
          ),

          const SizedBox(
            height: 20,
          ),

          //confirm password
          TextFieldInput(
            textEditingController: _confirmPasswordController,
            hintText: "Confirm Password",
            textInputType: TextInputType.text,
            isPass: true,
          ),

          const SizedBox(
            height: 20,
          ),


              const SizedBox(height: 20),

              InkWell(
                onTap: signUpUser,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.green,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor, // Use your color
                          ),
                        )
                      : const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account already?"),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
