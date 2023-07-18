import 'package:flashcard_app/providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var signIn = Provider.of<UserData>(context, listen: false).signIn;

    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Column(children: [
        TextField(
          obscureText: false,
          enableSuggestions: true,
          autocorrect: true,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your email address"),
          controller: emailController,
        ),
        TextField(
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Enter your password"),
          controller: passwordController,
        ),
        ElevatedButton(
            onPressed: () async {
              bool loggedIn = false;
              await signIn(emailController.text, passwordController.text)
                  .then((value) => loggedIn = value);
              if (loggedIn) {
                emailController.text = "";
                passwordController.text = "";
                Navigator.of(context).pop();
              } else {
                const SnackBar(
                  content: Text("Error signing in!"),
                );
              }
            },
            child: const Text("Sign In"))
      ]),
    );
  }
}
