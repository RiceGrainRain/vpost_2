import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _confirmPasswordController =TextEditingController();
  Uint8List? _image;

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

          const Text(
              textAlign: TextAlign.center,
              "Ready to volunteer?",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              )),

          const SizedBox(height: 40),

          Stack(
            children: [
              const CircleAvatar(radius: 64, backgroundImage: NetworkImage("https://static01.nyt.com/images/2023/06/06/science/06tb-croc/06tb-croc-videoSixteenByNine3000.jpg")),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

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

          //Register
          InkWell(
            onTap: () async {
              String res = await AuthMethods().signUpUser(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  firstName: _firstNameController.text.trim(),
                  lastName: _lastNameController.text.trim(),
                  userAge: _ageController.text.trim(),
                  confirmPassword: _confirmPasswordController.text.trim());
              print(res);
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                color: greenColor,
              ),
              child: const Text(
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
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Login Now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: blueColor),
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
