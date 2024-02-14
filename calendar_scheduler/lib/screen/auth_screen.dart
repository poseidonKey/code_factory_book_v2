import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Image.asset(
                  'assets/img/logo.png',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => onGoogleLoginPress(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: SECONDARY_COLOR,
              ),
              child: const Text(
                '구글로 로그인',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onGoogleLoginPress(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
      clientId: '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',
      serverClientId:
          '380088802231-09ksqckkh2dl4o8guqdj7nlnpj938687.apps.googleusercontent.com',
    );

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;

      if (googleAuth == null ||
          googleAuth.idToken == null ||
          googleAuth.accessToken == null) {
        throw Exception('로그인 실패');
      }

      await Supabase.instance.client.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패')),
      );
    }
  }
}
