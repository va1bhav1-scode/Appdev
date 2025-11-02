import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/fake_firebase.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: otp,
              decoration: InputDecoration(labelText: "Enter OTP"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await fake_firebase.FakeFirebaseService().verifyOTP(otp.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Text("Verify & Login"),
            ),
          ],
        ),
      ),
    );
  }
}
