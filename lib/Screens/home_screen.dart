import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Pages/cart_page.dart';
import '/Pages/home_page.dart';
import '/Pages/settings_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int currCart = 0;
num totalCost = 0;

class _HomeScreenState extends State<HomeScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  String loggedAs = "";
  String emailLoggedAs = "";

  int currentIndex = 0;
  List<Widget> pages = [const HomePage(), const CartPage(), const SettingsPage()];
  List<String> headers = ["Home", "Cart - $totalCost EGP", "Settings"];

  Future<void> logoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (user.displayName == null){
      loggedAs = user.email.toString();
      emailLoggedAs = "";
    } else {
      loggedAs = user.displayName.toString();
      emailLoggedAs = user.email.toString();
    }

    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue.shade900,
              title: Text(headers[currentIndex]),
            ),

            //  Drawer  //
            drawer: 
              Drawer(backgroundColor: Colors.indigo[900],
                child: 
                  Padding(padding: const EdgeInsets.all(35),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 25),
                          child: Text("Logged in as", style: TextStyle(color: Colors.white, fontSize: 18))
                        ),

                        const SizedBox(height: 25),

                        Text(loggedAs, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

                        Text(emailLoggedAs, style: const TextStyle(color: Colors.white70, fontSize: 16)),

                        Expanded(
                          child: Align(alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () => logoutDialog(),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[900]), fixedSize: MaterialStateProperty.all(const Size(180, 40))), 
                              child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
              ),
            //  Drawer End  //

            body: pages[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.home),
                  icon: const Icon(Icons.home_outlined),
                  label: "Home",
                  backgroundColor: Colors.blue.shade900),
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.shopping_cart),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: "Cart $currCart",
                  backgroundColor: Colors.blue.shade900),
                BottomNavigationBarItem(
                  activeIcon: const Icon(Icons.settings),
                  icon: const Icon(Icons.settings_outlined),
                  label: "Settings",
                  backgroundColor: Colors.blue.shade900),
              ],
            ),
          );
        
  }
}
