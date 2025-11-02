import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  String gender = "";
  String country = "";
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Registration")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: mobile,
              decoration: InputDecoration(labelText: "Mobile Number"),
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 15),
            Text("Gender"),
            SizedBox(height: 5),
            Wrap(
              spacing: 10,
              children: ["Male", "Female", "Other"]
                  .map(
                    (g) => ChoiceChip(
                      label: Text(g),
                      selected: gender == g,
                      onSelected: (_) => setState(() => gender = g),
                    ),
                  )
                  .toList(),
            ),

            SizedBox(height: 15),
            DropdownButtonFormField(
              items: [
                "India",
                "USA",
                "UAE",
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => country = v!,
              decoration: InputDecoration(labelText: "Select Country"),
            ),

            Row(
              children: [
                Checkbox(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v!),
                ),
                Text("Agree to terms"),
              ],
            ),

            ElevatedButton(
              onPressed: () async {
                await Future.delayed(Duration.zero);
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text("Register Now"),
            ),
          ],
        ),
      ),
    );
  }
}
