import 'package:blogapp/screens/home_screen.dart';
import 'package:blogapp/screens/login_screen.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/round_button.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    _signOutFromGoogle();
  }

  Future<void> _signOutFromGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Google Sign-Out Error: $error');
    }
  }

  _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange[100],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage('images/logo1.png')),
                const SizedBox(height: 30,),

                RoundButton(title: 'Already have an account! Login', onPress: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }),

                const SizedBox(height: 30,),
                RoundButton(title: "Don't have an account! Register", onPress: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SignIn()));
                }),

                const SizedBox(height: 20),
                const Text(
                  'Or login with',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                InkWell(
                  onTap: _handleGoogleSignIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'images/Glogo.svg',
                        width: 50,
                        height: 50,
                      ),

                      SizedBox(width: 10),
                      Text(
                        'Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
