import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final bool isSmall;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 100, // This width will be constrained by the parent
      height: isSmall ? 80 : 120, // Adjust height based on isSmall
      borderRadius: 20,
      blur: 10,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.35)],
      ),
      borderGradient: LinearGradient(
        colors: [color.withOpacity(0.6), Colors.white.withOpacity(0.4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isSmall) Icon(icon, color: color, size: 30),
          if (!isSmall) const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: isSmall ? 18 : 22, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(fontSize: isSmall ? 12 : 14)),
        ],
      ),
    );
  }
}
