import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isLastInGroup;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isLastInGroup,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? AppColors.primary : const Color(0xFFF0F2F5);
    final textColor = isMe ? Colors.white : AppColors.textDark;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(25),
      topRight: const Radius.circular(25),
      bottomLeft: isMe ? const Radius.circular(25) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(25),
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: EdgeInsets.only(top: isLastInGroup ? 8.0 : 2.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Text(text, style: TextStyle(color: textColor, fontSize: 15)),
        ).animate().fadeIn(duration: 400.ms).moveX(begin: isMe ? 20 : -20),
      ],
    );
  }
}
