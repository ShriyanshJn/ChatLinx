import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('C H A T L I N X'),
        centerTitle: true,
      ),
      body:const Center(child: Text('Logged in!',),),
    );
  }
}
