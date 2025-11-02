import 'package:flutter/material.dart';
import 'package:neo_auth_app/services/fake_firebase_services.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatelessWidget {
  PhoneScreen({super.key});

  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phone,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FakeFirebaseService().sendOTP(phone.text);
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (_) => OtpScreen()),
                );
              },
              child: Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
