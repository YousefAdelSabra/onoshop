import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onoshop/Screens/home_screen.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final user = FirebaseAuth.instance.currentUser!;

  Future<void> emptyCartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Cart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You cannot proceed to payment with an empty cart!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("cart_${user.email.toString()}").snapshots(),
      builder: (context, snapshots) {
        if (snapshots.data == null) {
          return const Center(
            child: Text("Your cart is empty", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22)),
          );
        } else {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                (totalCost != 0)
                ? Navigator.of(context).pushNamed("checkout")
                : emptyCartDialog();
              },
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.shopping_cart_checkout, color: Colors.white)),
            body: ListView.builder(
              itemCount: snapshots.data?.docs.length,
              itemBuilder: (context, i) => Dismissible(direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete)
                  )
                ),
                key: ValueKey(FirebaseFirestore.instance.collection("cart_${user.email.toString()}").doc(snapshots.data?.docs[i].id)),
                onDismissed: (direction) {
                  FirebaseFirestore.instance.collection("cart_${user.email.toString()}").doc(snapshots.data?.docs[i].id).delete();
                  totalCost -= snapshots.data?.docs[i]["Price"];
                  currCart--;
                },
                child: Container(height: 75,
                  decoration: const BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.blue, width: 0.2))),
                  child: Center(
                    child: ListTile(
                      leading: CircleAvatar(radius: 24, backgroundImage: NetworkImage(snapshots.data?.docs[i]["Image"])),
                      title: Text(snapshots.data?.docs[i]["Name"]),
                      subtitle: Text("${snapshots.data?.docs[i]["Price"]} EGP"),
                    ),
                  )
                )
              )
            ),
          );
        }
      }
    );
  }
}