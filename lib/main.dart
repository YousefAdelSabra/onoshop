import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onoshop/Logic/utils.dart';
import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/signup_screen.dart';
import 'Pages/checkout_page.dart';

bool isSwitched = false;
final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isSwitched? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, shot) {
            if (shot.connectionState == ConnectionState.done) {
              return StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const HomeScreen();
                  } else {
                    return const LoginScreen();
                  }
                }
              );
            } else {
              return const Center(child: Text("Error: Can't connect to firebase", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold, decoration: TextDecoration.none)));
            }
          }
      ),
      routes: {
        "home": (context) => const HomeScreen(),
        "signup": (context) => const SignUpScreen(),
        "login": (context) => const LoginScreen(),
        "checkout": (context) => const CheckoutPage(),
        "cash": (context) => const CashCheckout(),
        "card": (context) => const CardCheckout(),
      },
    );
  }
}
