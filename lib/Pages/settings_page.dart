import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onoshop/main.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  final userNameController = TextEditingController();
  
  @override
  void dispose() {
    userNameController.dispose();

    super.dispose();
  }


  changeUserName() {
    user.updateDisplayName(userNameController.text.trim());
  }

  Future<void> changeNameDialog() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Username Change'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to change username?'),
                SizedBox(height: 15),
                Text('You must logout for changes to take effect.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Accept and Logout'),
              onPressed: () {
                changeUserName();
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
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      
            const CircleAvatar(radius: 60.0, backgroundImage: NetworkImage('https://cdn.vectorstock.com/i/preview-1x/32/12/default-avatar-profile-icon-vector-39013212.jpg')),
      
            const SizedBox(height: 10),

            //User Name
            (user.displayName == null)
            ? const Text('Unnamed User', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
            : Text(user.displayName.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //End of User Name
      
            const SizedBox(height: 20.0, width: 150, child: Divider(color: Colors.blue)),

            //Dark and Light Mode Switch
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Switch between light and dark mode"),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.grey.shade200,
                    activeColor: Colors.grey.shade600,
                    inactiveTrackColor: Colors.grey.shade600,
                    inactiveThumbColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            //End of Dark and Light Mode Switch
      
            //Text Form Field
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: userNameController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Enter a username',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (username) => username != null && username.length < 4
                    ? "Username must be at least 4 characters"
                    : null,
              ),
            ),
            //End of Text Form Field

            //Change Name Button
            ElevatedButton(
              onPressed: changeNameDialog,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue[900]), fixedSize: MaterialStateProperty.all(const Size(180, 40))),
              child: const Text("Change User Name")
            ),
            // End of Change Name Button

          ],
        ),
    );
  }
}
