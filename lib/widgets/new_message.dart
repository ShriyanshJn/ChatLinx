import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage == null || enteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    // auth can be used to get the current logged in user
    final user = FirebaseAuth.instance.currentUser!;
    // retrieving user's data from users folder in firestore
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    // adding data to chat folder in firestore // collection.doc(ourgenerated user id), collection.add -> firestore sutomatically generates uid
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
        top: 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Message...',
              ),
            ),
          ),
          IconButton(
            onPressed: _submitMessage,
            icon: const Icon(
              Icons.send_rounded,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
