import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/customer/home_screen.dart';
import '../screens/customer/shop_detail_screen.dart';
import '../screens/customer/complaint_screen.dart';
import '../screens/shop_owner/dashboard_screen.dart';
import '../screens/shop_owner/products_screen.dart';
import '../screens/shop_owner/chat_screen.dart';
import '../screens/shop_owner/qr_code_screen.dart';
import '../screens/shop_owner/settings_screen.dart';
import '../screens/police/dashboard_screen.dart';
import '../screens/police/map_screen.dart';
import '../screens/police/report_screen.dart';
import '../screens/customer/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String customerHome = '/customer_home';
  static const String shopDetail = '/shop_detail';
  static const String complaint = '/complaint';
  static const String ownerDashboard = '/owner_dashboard';
  static const String products = '/products';
  static const String ownerChat = '/owner_chat';
  static const String ownerQrCode = '/owner_qr_code';
  static const String ownerSettings = '/owner_settings';
  static const String policeDashboard = '/police_dashboard';
  static const String policeMap = '/police_map';
  static const String policeReport = '/police_report';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        customerHome: (_) => const HomeScreen(),
        shopDetail: (_) => const ShopDetailScreen(),
        complaint: (_) => const ComplaintScreen(),
        ownerDashboard: (_) => const DashboardScreen(),
        products: (_) => const ProductsScreen(),
        ownerChat: (_) => const ChatScreen(),
        ownerQrCode: (_) => const QrCodeScreen(),
        ownerSettings: (_) => const SettingsScreen(),
        policeDashboard: (_) => const PoliceDashboardScreen(),
        policeMap: (_) => const PoliceMapScreen(),
        policeReport: (_) => const ReportScreen(),
        profile: (_) => const ProfileScreen(),
      };
}
