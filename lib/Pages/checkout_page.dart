import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onoshop/Screens/home_screen.dart';
import 'package:onoshop/main.dart';

enum CheckoutMethod {cash, card}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final user = FirebaseAuth.instance.currentUser!;
  CheckoutMethod chosen = CheckoutMethod.card;

  Future deleteAllItems() async {
    var collection = FirebaseFirestore.instance.collection("cart_${user.email.toString()}");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("cart_${user.email.toString()}").snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Checkout"),
            backgroundColor: Colors.blue[900],
            actions: const [
              Padding(padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.shopping_cart_checkout))
            ],
          ),
          body: Column(
            children: [
              Container(alignment: Alignment.topLeft, padding: const EdgeInsets.only(top: 20, bottom: 10, left: 14),
                child: const Text("Choose your payment method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19))
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Radio(value: CheckoutMethod.card, groupValue: chosen, onChanged: (value) {
                    setState(() {
                      chosen = value!;
                    });
                  }),
                  const Expanded(child: Text("Online Payment"))
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Radio(value: CheckoutMethod.cash, groupValue: chosen, onChanged: (value) {
                    setState(() {
                      chosen = value!;
                    });
                  }),
                  const Expanded(child: Text("Pay on Delivery"))
                ],
              ),
              Container(alignment: Alignment.topLeft, padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                    const TextSpan(text: "The total cost of your items is "),
                    TextSpan(text: "$totalCost", style: TextStyle(color: Colors.blue[400], fontWeight: FontWeight.bold)),
                    const TextSpan(text: " EGP"),
                    ],
                  ),
                ),
              ),
              Container(padding: const EdgeInsets.symmetric(vertical: 30),
                child: ElevatedButton(
                  onPressed: () {
                    (chosen == CheckoutMethod.cash)
                    ? {
                        Navigator.of(context).popAndPushNamed("cash"),
                        deleteAllItems(),
                        totalCost = 0,
                        currCart = 0,
                      }
                    
                    : {
                        Navigator.of(context).popAndPushNamed("card"),
                        deleteAllItems(),
                        totalCost = 0,
                        currCart = 0,
                      };
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[900]), fixedSize: MaterialStateProperty.all(const Size(180, 40))), 
                  child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                ),
              ),
            ],
          )
        );
      }
    );
  }
}

//------------------------------------------------------------------------------//

class CashCheckout extends StatefulWidget {
  const CashCheckout({super.key});

  @override
  State<CashCheckout> createState() => _CashCheckoutState();
}

class _CashCheckoutState extends State<CashCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            const Text("Thanks for ordering!"),

            const SizedBox(height: 20),

            const Text("You will receive and email with your receipt."),

            const SizedBox(height: 20),

            const Text("The delivery driver will take your funds."),
      
            Container(padding: const EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
                onPressed: () {
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[900]), fixedSize: MaterialStateProperty.all(const Size(250, 40))), 
                child: const Text("Back to main menu", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
              ),
            ),
      
          ],
        ),
      ),
      
    );
  }
}

//------------------------------------------------------------------------------//

class CardCheckout extends StatefulWidget {
  const CardCheckout({super.key});

  @override
  State<CardCheckout> createState() => _CardCheckoutState();
}

class _CardCheckoutState extends State<CardCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            const Text("Thanks for purchasing!"),

            const SizedBox(height: 20),

            const Text("You will receive and email with your receipt."),
      
            Container(padding: const EdgeInsets.symmetric(vertical: 30),
              child: ElevatedButton(
                onPressed: () {
                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[900]), fixedSize: MaterialStateProperty.all(const Size(250, 40))), 
                child: const Text("Back to main menu", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
              ),
            ),
      
          ],
        ),
      ),
      
    );
  }
}
