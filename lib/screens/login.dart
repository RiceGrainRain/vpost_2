import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Scaffold(
          body: SafeArea(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(flex: 2, child: Container()),
              const SizedBox(
                height: 20,
              ),
              //LOGO
              Image.asset(
                'assets/images/vpost-dark.png',
                height: 180,
                width: 180,
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
          
              //Login
              InkWell(
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
                    "Log in",
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
                    child: const Text("Don't have an account?"),
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign Up",
                        style:
                            TextStyle(fontWeight: FontWeight.bold,),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          )),
        ),
      ),
    );
  }
}
