import 'package:flutter/material.dart';
import 'package:vpost_2/resources/auth_methods.dart';
import 'package:vpost_2/responsive/mobile_screen_layout.dart';
import 'package:vpost_2/responsive/responsive_layout.dart';
import 'package:vpost_2/responsive/web_layout.dart';
import 'package:vpost_2/screens/register.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/utils/utils.dart';
import 'package:vpost_2/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLocationListVisible = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Add focus listeners
    _emailFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        isLocationListVisible = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToRegister() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
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
          //LOGO
          Image.asset(
            'assets/images/vpost-dark.png',
            height: 180,
            width: 180,
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

          //Login
          InkWell(
            onTap: loginUser,
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
              GestureDetector(
                onTap: navigateToRegister,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Sign Up",
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
