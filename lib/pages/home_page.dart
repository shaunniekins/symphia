// home_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:symphia/services/database_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ValueNotifier<bool> loginNotifier = ValueNotifier<bool>(false);

  Future<UserCredential?> signInWithGoogle() async {
    print('Google sign-in process started');

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('Google sign-in dialog shown');

      // If the user cancels the sign-in process, return null
      if (googleUser == null) {
        print('Google sign-in canceled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Google sign-in authentication obtained');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('Google sign-in credentials created');

      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print('Google sign-in successful, user: ${userCredential.user?.email}');

      // Notify that the user has logged in
      loginNotifier.value = true;
      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple,
              Colors.deepPurple,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/symphia-logo.svg',
                          height: 35),
                      const SizedBox(width: 5),
                      const Text(
                        'symphia',
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'By clicking Log in, you agree with our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' and that you have read our '),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            UserCredential? userCredential =
                                await signInWithGoogle();
                            // Navigate to the next screen if the sign-in was successful
                            if (userCredential != null) {
                              final databaseService = DatabaseService();
                              final userProfileStream =
                                  databaseService.getUser();
                              final userProfileSnapshot =
                                  await userProfileStream.first;

                              if (userProfileSnapshot != null) {
                                // User data exists in Firestore, navigate to '/main'
                                Get.offAllNamed('/main');
                              } else {
                                // User data does not exist in Firestore, navigate to '/name'
                                Get.offAllNamed('/name');
                              }
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageIcon(AssetImage('assets/images/google.png')),
                            Text('LOG IN WITH GOOGLE'),
                            Opacity(
                              opacity: 0,
                              child: ImageIcon(
                                  AssetImage('assets/images/google.png')),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      )),
    );
  }
}
