// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onoshop/Screens/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;
  String itemName = "Default";
  String itemImage = "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg";
  int itemPrice = 0;

  void addToCart() {
     FirebaseFirestore.instance.collection("cart_${user.email.toString()}").add({"Name": itemName, "Image": itemImage, "Price": itemPrice});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Items").snapshots(),
      builder: (context, snapshots) {
        return GridView.builder(
          itemCount: snapshots.data?.docs.length,
          itemBuilder: (context, i) => Container(
            key: ValueKey(FirebaseFirestore.instance.collection("Items").doc(snapshots.data?.docs[i].id)),
            child: (snapshots.data != null)
            ? GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.grey.shade700,
                  trailing: IconButton(splashRadius: 1, iconSize: 20,
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    onPressed: () {
                      itemName = snapshots.data?.docs[i]["Name"];
                      itemImage = snapshots.data?.docs[i]["Image"];
                      itemPrice = snapshots.data?.docs[i]["Price"];
                      currCart++;
                      totalCost += snapshots.data?.docs[i]["Price"];
                      addToCart();
                    },
                  ),
                  title: Text(snapshots.data?.docs[i]["Name"], style: TextStyle(fontSize: 12)),
                  subtitle: Text("${snapshots.data?.docs[i]["Price"]} EGP", style: TextStyle(fontSize: 10)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    border: Border.all(color: Colors.blue), 
                    borderRadius:BorderRadius.circular(2)
                  ),
                  child: Image.network(snapshots.data?.docs[i]["Image"], fit: BoxFit.fitWidth, alignment: Alignment.center,)
                )
              )
            : SpinKitDoubleBounce(color: Colors.blue)
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 1,
            childAspectRatio: 1 / 2,
          ),
        );
      },
    );
  }
}