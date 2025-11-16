import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// Dummy User Model
class User {
  final String id;
  final String name;
  final String email;
  final String userType; // 'Consumer' or 'Shop Owner'
  final String imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.imageUrl,
  });
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  // Dummy data for users
  final List<User> users = const [
    User(id: '1', name: 'John Doe', email: 'john.d@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
    User(id: '2', name: 'Sabbir Ahmed', email: 'owner@sabbirselectronics.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704c'),
    User(id: '3', name: 'Jane Smith', email: 'jane.s@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704e'),
    User(id: '4', name: 'Ayesha Khan', email: 'owner@greengrocers.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704a'),
    User(id: '5', name: 'Alex Johnson', email: 'alex.j@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704f'),
    User(id: '6', name: 'Imran Chowdhury', email: 'owner@bookworm.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704b'),
    User(id: '7', name: 'Farah Islam', email: 'owner@gadgethub.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704g'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: ListView.separated(
          itemCount: users.length,
          separatorBuilder: (context, index) => const Divider(indent: 80, height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            final bool isShopOwner = user.userType == 'Shop Owner';
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.email),
              trailing: Chip(
                label: Text(
                  user.userType,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: isShopOwner ? AppColors.accentShopOwner : Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
