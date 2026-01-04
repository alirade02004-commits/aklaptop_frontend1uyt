import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userCont = TextEditingController();
  final passCont = TextEditingController();
  final String apiUrl = "https://campus-backend-1-jxul.onrender.com";

  Future<void> register() async {
    await http.post(
      Uri.parse("$apiUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": userCont.text, "password": passCont.text}),
    );
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: userCont, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: passCont, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("CREATE ACCOUNT")),
          ],
        ),
      ),
    );
  }
}