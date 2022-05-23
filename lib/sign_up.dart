import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              controller: emailController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () => signUp(),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signUp() async {
    try {
      var response =
          await http.post(Uri.parse('https://reqres.in/api/register'), body: {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      if (response.statusCode == 200) {
        print("Login successful!");
        var responseData = jsonDecode(response.body.toString());
        Navigator.pushNamed(context, '/home');
      } else {
        print("Login failed.");
      }
    } catch (e) {
      print(e);
    }
  }
}
