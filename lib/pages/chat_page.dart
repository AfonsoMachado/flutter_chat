import 'package:flutter/material.dart';
import 'package:flutter_chat/core/services/auth/auth_mock_service.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chat Page'),
            TextButton(
                onPressed: () {
                  AuthMockService().signout();
                },
                child: const Text('Sair'))
          ],
        ),
      ),
    );
  }
}
