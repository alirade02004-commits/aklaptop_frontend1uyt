import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_page.dart';
import 'dashboard_page.dart';

void main() => runApp(const MaterialApp(home: LoginPage(), debugShowCheckedModeBanner: false));

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final userCont = TextEditingController();
  final passCont = TextEditingController();
  final String apiUrl = "https://campus-backend-1-jxul.onrender.com";

  Future<void> login() async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": userCont.text, "password": passCont.text}),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          DashboardPage(userId: data['userId'], username: userCont.text)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Campus Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: userCont, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: passCont, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("LOGIN")),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                child: const Text("Register Account"))
          ],
        ),
      ),
    );
  }
}