import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

// Re-using the User model definition for consistency
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

class ActiveUserListScreen extends StatelessWidget {
  const ActiveUserListScreen({super.key});

  // Dummy data for active users
  final List<User> activeUsers = const [
    User(id: '1', name: 'John Doe', email: 'john.d@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d'),
    User(id: '3', name: 'Jane Smith', email: 'jane.s@example.com', userType: 'Consumer', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704e'),
    User(id: '4', name: 'Ayesha Khan', email: 'owner@greengrocers.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704a'),
    User(id: '7', name: 'Farah Islam', email: 'owner@gadgethub.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704g'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Users Today'),
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
          itemCount: activeUsers.length,
          separatorBuilder: (context, index) => const Divider(indent: 80, height: 1),
          itemBuilder: (context, index) {
            final user = activeUsers[index];
            final bool isShopOwner = user.userType == 'Shop Owner';
            return ListTile(
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(user.imageUrl),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  )
                ],
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
