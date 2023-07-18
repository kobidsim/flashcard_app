import 'package:flashcard_app/providers/user_data.dart';
import 'package:flashcard_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var usernameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var signUp = Provider.of<UserData>(context, listen: false).signUp;

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Column(children: [
        TextField(
          obscureText: false,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Enter your username"),
          controller: usernameController,
        ),
        TextField(
          obscureText: false,
          enableSuggestions: true,
          autocorrect: true,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Enter email address"),
          controller: emailController,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Create a new password"),
          controller: passwordController,
        ),
        ElevatedButton(
            onPressed: () async {
              bool loggedIn = false;
              await signUp(usernameController.text, emailController.text,
                      passwordController.text)
                  .then((value) => loggedIn = value);
              if (loggedIn) {
                usernameController.text = "";
                emailController.text = "";
                passwordController.text = "";
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyHomePage()));
              } else {
                const SnackBar(
                  content: Text("Error signing up!"),
                );
              }
            },
            child: const Text("Sign Up"))
      ]),
    );
  }
}
