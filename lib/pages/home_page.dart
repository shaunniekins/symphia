// home_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ValueNotifier<bool> loginNotifier = ValueNotifier<bool>(false);

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // If the user cancels the sign-in process, return null
    if (googleUser == null) {
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Notify that the user has logged in
    loginNotifier.value = true;

    return userCredential;
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
                              Get.offAllNamed('/main');
                            }
                          } catch (e) {
                            // Handle the error
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