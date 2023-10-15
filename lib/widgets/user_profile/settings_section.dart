import 'package:flutter/material.dart';
import 'package:vpost_2/resources/auth_methods.dart';
import 'package:vpost_2/screens/login.dart';
import 'package:vpost_2/utils/colors.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: blackColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              onTap: () {
                AuthMethods().signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              leading: const Icon(Icons.logout_rounded,
                  color: Color.fromARGB(255, 251, 46, 62)),
              title: const Text("Log Out",
                  style: TextStyle(
                    color: Color.fromARGB(255, 251, 46, 62),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
