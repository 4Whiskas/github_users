import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_users/presentation/screens/users/view/users_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInputView extends StatefulWidget {
  const TokenInputView({super.key});

  @override
  State<TokenInputView> createState() => _TokenInputViewState();
}

class _TokenInputViewState extends State<TokenInputView> {
  final tokenController = TextEditingController();

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This app needs your Github auth token to work',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(
                hintText: 'Input your github token to use this app',
              ),
            ),
            const SizedBox(height: 24),
            CupertinoButton(
              onPressed: () async {
                final storage = await SharedPreferences.getInstance();
                await storage.setString(
                  'token',
                  tokenController.text,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UsersView(),
                  ),
                );
              },
              minSize: 0,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
              child: const Text(
                'Submit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
