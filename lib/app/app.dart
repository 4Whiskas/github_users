import 'package:flutter/material.dart';
import 'package:github_users/presentation/screens/token_input/token_input_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TokenInputView(),
    );
  }
}
