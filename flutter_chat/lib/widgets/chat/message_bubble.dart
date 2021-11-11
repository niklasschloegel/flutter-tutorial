import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String userName;
  final String? imageUrl;
  final bool isMe;
  final String dateString;
  const MessageBubble({
    Key? key,
    required this.text,
    required this.userName,
    this.imageUrl,
    required this.isMe,
    required this.dateString,
  }) : super(key: key);

  static const _IMG_RADIUS = 20.0;

  CircleAvatar get _profilePic => CircleAvatar(
        radius: _IMG_RADIUS,
        backgroundImage: imageUrl == null
            ? AssetImage("assets/images/defaultProfilePic.png")
            : NetworkImage(imageUrl!) as ImageProvider,
      );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!isMe) _profilePic,
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isMe ? colorScheme.primary : Colors.grey.shade700,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(!isMe ? 0 : 12),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: (deviceWidth * 0.9) - _IMG_RADIUS - 16,
                      minWidth: 140,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                          ),
                        ),
                        Text(
                          text,
                          style: TextStyle(
                            color:
                                isMe ? colorScheme.onPrimary : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: Text(
                      dateString,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (isMe) _profilePic,
            ],
          ),
        ],
      ),
    );
  }
}
