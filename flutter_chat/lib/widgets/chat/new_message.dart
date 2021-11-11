import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
  final _controller = TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    final data = {
      "text": _enteredMessage.trim(),
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData["username"],
    };

    final containsImageUrl = userData.data()?.containsKey("image_url") ?? false;
    if (containsImageUrl) data["userImage"] = userData["image_url"];

    FirebaseFirestore.instance.collection("chat").add(data);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(labelText: "Send message"),
              onChanged: (val) => setState(() => _enteredMessage = val),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send,
                color: _enteredMessage.trim().isEmpty
                    ? Colors.white30
                    : Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
