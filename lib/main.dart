import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/accounting_store.dart';
import 'providers/complaint_provider.dart';
import 'providers/auth_provider.dart';

// --- Theme ---
import 'theme/app_themes.dart';

// --- Auth Screens ---
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// --- Customer Screens ---
import 'screens/customer/home_screen.dart';
import 'screens/customer/shop_detail_screen.dart';
import 'screens/customer/product_detail_screen.dart';
import 'screens/customer/complaint_screen.dart';
import 'screens/customer/file_complaint_screen.dart';
import 'screens/customer/customer_chat_screen.dart';
import 'screens/customer/qr_scanner_screen.dart';
import 'screens/customer/notifications_screen.dart';
import 'screens/customer/favorites_screen.dart';
import 'screens/customer/bkash_payment_screen.dart';
import 'screens/customer/card_payment_screen.dart';
import 'screens/customer/nagad_payment_screen.dart';
import 'screens/customer/rocket_payment_screen.dart';
import 'screens/customer/profile_screen.dart';

// --- Shop Owner Screens ---
import 'screens/shop_owner/dashboard_screen.dart' as owner;
import 'screens/shop_owner/products_screen.dart';
import 'screens/shop_owner/orders_screen.dart';
import 'screens/shop_owner/chat_screen.dart';
import 'screens/shop_owner/chat_list_screen.dart';
import 'screens/shop_owner/owner_complaints_screen.dart';
import 'screens/shop_owner/accounting_screen.dart';
import 'screens/shop_owner/charts_screen.dart';
import 'screens/shop_owner/trends_screen.dart';
import 'screens/shop_owner/qr_code_screen.dart';
import 'screens/shop_owner/settings_screen.dart';

// --- Police Screens ---
import 'screens/police/dashboard_screen.dart' as police;
import 'screens/police/map_screen.dart';
import 'screens/police/report_screen.dart';
import 'screens/police/user_list_screen.dart';
import 'screens/police/active_user_list_screen.dart';
import 'screens/police/consumer_list_screen.dart';
import 'screens/police/shop_owner_list_screen.dart';
import 'screens/police/complaint_list_screen.dart';
import 'screens/police/pending_complaint_list_screen.dart';
import 'screens/police/in_review_complaint_list_screen.dart';
import 'screens/police/assigned_complaint_list_screen.dart';
import 'screens/police/rejected_complaint_list_screen.dart';
import 'screens/police/high_priority_complaint_list_screen.dart';
import 'screens/police/police_notifications_screen.dart';
import 'screens/police/system_health_screen.dart';
import 'screens/police/shop_management_screen.dart';
import 'screens/police/shop_details_for_police_screen.dart';
import 'screens/police/resolved_complaint_list_screen.dart';

void main() {
  runApp(const SmartShopConnectApp());
}

class SmartShopConnectApp extends StatelessWidget {
  const SmartShopConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(null, const []),
          update: (context, auth, previous) => ProductProvider(auth, previous?.products ?? const []),
        ),
        ChangeNotifierProvider(create: (_) => AccountingStore()),
        ChangeNotifierProvider(create: (_) => ComplaintProvider()),
      ],
      child: MaterialApp(
        title: 'SmartShop Connect',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,

        // AuthWrapper handles initial redirection based on login state
        home: const AuthWrapper(), 

        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/customer_home': (_) => const HomeScreen(),
          '/shop_detail': (_) => const ShopDetailScreen(),
          '/product_detail': (_) => const ProductDetailScreen(),
          '/card_payment': (_) => const CardPaymentScreen(),
          '/bkash_payment': (_) => const BkashPaymentScreen(),
          '/nagad_payment': (_) => const NagadPaymentScreen(),
          '/rocket_payment': (_) => const RocketPaymentScreen(),
          '/customer_chat': (_) => const CustomerChatScreen(),
          '/complaint': (_) => const ComplaintScreen(),
          '/file_complaint': (_) => const FileComplaintScreen(),
          '/qr_scanner': (_) => const QrScannerScreen(),
          '/notifications': (_) => const NotificationsScreen(),
          '/favorites': (_) => const FavoritesScreen(),
          '/profile': (_) => const ProfileScreen(),

          '/owner_dashboard': (_) => const owner.DashboardScreen(),
          '/products': (_) => const ProductsScreen(),
          '/orders': (_) => const OrdersScreen(),
          '/owner_chat': (_) => const ChatScreen(),
          '/owner_chat_list': (_) => const ChatListScreen(),
          '/owner_complaints': (_) => const OwnerComplaintsScreen(), // Made const
          '/owner_accounting': (_) => const AccountingScreen(),
          '/owner_charts': (_) => const ChartsScreen(),
          '/owner_trends': (_) => const TrendsScreen(),
          '/owner_qr_code': (_) => const QrCodeScreen(),
          '/owner_settings': (_) => const SettingsScreen(),

          '/police_dashboard': (_) => const police.PoliceDashboardScreen(),
          '/police_map': (_) => const PoliceMapScreen(),
          '/police_report': (_) => const ReportScreen(),
          '/police_users': (_) => const UserListScreen(),
          '/police_active_users': (_) => const ActiveUserListScreen(),
          '/police_consumers': (_) => const ConsumerListScreen(),
          '/police_shop_owners': (_) => const ShopOwnerListScreen(),
          '/police_complaints': (_) => const ComplaintListScreen(),
          '/police_pending_complaints': (_) => const PendingComplaintListScreen(),
          '/police_in_review_complaints': (_) => const InReviewComplaintListScreen(),
          '/police_assigned_complaints': (_) => const AssignedComplaintListScreen(),
          '/police_rejected_complaints': (_) => const RejectedComplaintListScreen(),
          '/police_resolved_complaints': (_) => const ResolvedComplaintListScreen(),
          '/police_high_priority_complaints': (_) => const HighPriorityComplaintListScreen(),
          '/police_notifications': (_) => const PoliceNotificationsScreen(),
          '/police_system_health': (_) => const SystemHealthScreen(),
          '/police_shops': (_) => const ShopManagementScreen(),
          '/police_shop_details': (_) => const ShopDetailsForPoliceScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          if (auth.role == 'customer') return const HomeScreen();
          if (auth.role == 'shopOwner') return const owner.DashboardScreen();
          if (auth.role == 'admin') return const police.PoliceDashboardScreen();
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
