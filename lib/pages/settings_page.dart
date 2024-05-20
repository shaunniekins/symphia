// settings_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:symphia/services/database_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/');
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    // Reauthenticate the user
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await user?.reauthenticateWithCredential(credential);
    FirebaseFirestore.instance.collection('users').doc(user?.uid).delete();
    await user?.delete();
    Get.offAllNamed('/');
  }

  final databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              height: 5,
            ),
            const ListTile(
              title: Text(
                'About You',
                style: TextStyle(fontSize: 14),
              ),
              minTileHeight: 0,
              // minVerticalPadding: 0,
            ),
            const ListTile(
              title: Text('Personal Details',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ),
            const ListTile(
              title: Text('Preferences',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              height: 5,
              color: Colors.grey[200],
            ),
            // AI
            const ListTile(
              title: Text(
                'Artificial Intelligence',
                style: TextStyle(fontSize: 14),
              ),
              minTileHeight: 0,
              // minVerticalPadding: 0,
            ),
            ListTile(
              title: const Text('Style',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ),
            ListTile(
              title: const Text('Voice',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              height: 5,
              color: Colors.grey[200],
            ),
            // Help and feedback section
            const ListTile(
              title: Text(
                'Support & Policies',
                style: TextStyle(fontSize: 14),
              ),
              minTileHeight: 0,
              // minVerticalPadding: 0,
            ),
            ListTile(
              title: const Text('Help & Feedback',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ),
            ListTile(
              title: const Text('Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              height: 5,
              color: Colors.grey[200],
            ),
            // Account
            const ListTile(
              title: Text(
                'Account',
                style: TextStyle(fontSize: 14),
              ),
              minTileHeight: 0,
              // minVerticalPadding: 0,
            ),
            ListTile(
              title: const Text('Delete Account',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w500)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: const Text(
                          'Are you sure you want to delete your account?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            _deleteAccount();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Logout',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w500)),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
