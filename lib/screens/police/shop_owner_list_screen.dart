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

class ShopOwnerListScreen extends StatelessWidget {
  const ShopOwnerListScreen({super.key});

  // Dummy data for users, filtered to shop owners
  final List<User> shopOwners = const [
    User(id: '2', name: 'Sabbir Ahmed', email: 'owner@sabbirselectronics.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704c'),
    User(id: '4', name: 'Ayesha Khan', email: 'owner@greengrocers.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704a'),
    User(id: '6', name: 'Imran Chowdhury', email: 'owner@bookworm.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704b'),
    User(id: '7', name: 'Farah Islam', email: 'owner@gadgethub.com', userType: 'Shop Owner', imageUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704g'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Shop Owners'),
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
          itemCount: shopOwners.length,
          separatorBuilder: (context, index) => const Divider(indent: 80, height: 1),
          itemBuilder: (context, index) {
            final user = shopOwners[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.email),
              trailing: Chip(
                label: const Text(
                  'Shop Owner',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                backgroundColor: AppColors.accentShopOwner,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
