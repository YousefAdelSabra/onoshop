import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onoshop/main.dart';
import '../Logic/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.blue.shade900,
      ),

      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [

              const SizedBox(height: 15,),

              Image.asset(width: 150, 'assets/images/onoLogo.png'),

              Padding(padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),

              Padding(padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: logIn,
                style: ButtonStyle(fixedSize: MaterialStateProperty.all(const Size(180, 40))),
                label: const Text("Login"),
                icon: const Icon(Icons.lock_open)
              ),

              const Padding(padding: EdgeInsets.only(top: 45),
                child: Text("Don't have an account?", style: TextStyle(fontWeight: FontWeight.bold))
              ),

              TextButton(onPressed: () {
                Navigator.of(context).pushNamed("signup");
              },
              child: const Text("Sign Up")
              ),
            ],
          )
      ),

    );
  }
  Future logIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
      );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}