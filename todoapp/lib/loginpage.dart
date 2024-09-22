import 'package:flutter/material.dart';
import 'package:todoapp/todopage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String hardcodedUserName = "alby";
  String hardcodedPassword = "12345";
  bool _isPasswordObscured = true;

  final TextEditingController usernameController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController PasswordController = TextEditingController();

  bool passwordVisible = false;
  @override
  void dispose() {
    // Dispose controllers when no longer needed
    usernameController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network("https://cdn-icons-png.flaticon.com/512/906/906334.png",
              width: 150, height: 70),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Username TextField
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                // Password TextField
                TextFormField(
                  controller: PasswordController,
                  obscureText: _isPasswordObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 150, right: 150, top: 20),
            child: MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                if (hardcodedUserName == usernameController.text &&
                    hardcodedPassword == PasswordController.text) {
                  // await saveBoolData(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoApp(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 500),
                      content: Row(
                        children: [
                          Icon(Icons.warning),
                          Text("Invalid user name and password"),
                        ],
                      )));
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
