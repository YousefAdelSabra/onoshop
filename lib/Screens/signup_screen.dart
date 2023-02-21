import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onoshop/main.dart';
import 'package:onoshop/Logic/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final formKey = GlobalKey<FormState>();
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
          title: const Text("Sign Up"),
          backgroundColor: Colors.blue.shade900,
      ),

      body: Container(
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              children: [
          
                const SizedBox(height: 15,),
          
                Image.asset(width: 150,'assets/images/onoLogo.png'),
          
                Padding(padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => 
                      email != null && !EmailValidator.validate(email)
                        ? "Enter a valid email"
                        : null,
                  ),
                ),
          
                Padding(padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Create a password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => 
                      password != null && password.length < 6
                        ? "Password must be at least 6 characters"
                        : null,
                  ),
                ),
          
                ElevatedButton.icon(
                  onPressed: signUp,
                  style: ButtonStyle(fixedSize: MaterialStateProperty.all(const Size(180, 40))),
                  label: const Text("Sign Up"),
                  icon: const Icon(Icons.arrow_outward)
                ),
              ],
            ),
          )
      ),

    );
  }
  Future signUp() async {

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
      );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());      
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}