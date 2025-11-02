import 'package:flutter/material.dart';
import 'package:neo_auth_app/screens/otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseService().resetPassword(email.text);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
