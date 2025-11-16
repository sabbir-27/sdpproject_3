import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../models/message.dart';
import '../../models/shop.dart';
import '../../theme/app_colors.dart';

class CustomerChatScreen extends StatefulWidget {
  const CustomerChatScreen({super.key});

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [
    Message(text: 'Hi there! I have a question about my recent order.', senderId: 'customer', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
    Message(text: 'Hello! I can help with that. What is your order number?', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 4))),
    Message(text: 'It is #12345. I was wondering about the shipping status.', senderId: 'customer', timestamp: DateTime.now().subtract(const Duration(minutes: 3))),
    Message(text: 'Let me check that for you right now.', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 2))),
    Message(text: 'It looks like your order has been shipped and is scheduled to arrive tomorrow!', senderId: 'owner', timestamp: DateTime.now().subtract(const Duration(minutes: 1))),
    Message(text: 'That\'s great news! Thank you so much for your help.', senderId: 'customer', timestamp: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(Message(text: _controller.text, senderId: 'customer', timestamp: DateTime.now()));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = ModalRoute.of(context)!.settings.arguments as Shop? ??
        const Shop(
            id: 'fallback',
            name: 'Unknown Shop',
            description: '',
            rating: 0,
            distance: '',
            imageUrl: 'https://i.pravatar.cc/150',
            products: [],
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, shop),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCustomer = message.senderId == 'customer';
                return _buildMessageBubble(message, isCustomer, index);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Shop shop) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: AppColors.primary),
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(shop.imageUrl), radius: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.name, style: const TextStyle(color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('Active now', style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, bool isCustomer, int index) {
    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: isCustomer ? const LinearGradient(colors: [Color(0xFF00B2FF), Color(0xFF006AFF)], begin: Alignment.topRight, end: Alignment.bottomLeft) : null,
          color: !isCustomer ? const Color(0xFFF0F2F5) : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isCustomer ? Colors.white : AppColors.textDark, fontSize: 15),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).moveX(begin: isCustomer ? 40 : -40, curve: Curves.easeOutCubic);
  }

  Widget _buildMessageComposer() {
    final hasText = _controller.text.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
      child: SafeArea(
        child: Row(
          children: [
            if (!hasText)
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.mic, color: AppColors.primary), onPressed: () {}),
                ],
              ).animate().fadeIn(duration: 200.ms),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(24.0)),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Aa', border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(hasText ? Icons.send : Icons.thumb_up_alt_rounded, color: AppColors.primary),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
