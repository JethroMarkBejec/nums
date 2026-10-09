import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/loading_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/verification_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/design_preview_screen.dart';
import '../screens/customer/customer_shell.dart';
import '../screens/customer/menu_screen.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/orders_screen.dart';
import '../screens/customer/flavor_ideas_screen.dart';
import '../screens/customer/custom_request_screen.dart';
import '../screens/customer/history_screen.dart';
import '../screens/customer/notifications_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/customer/ordering/solo_order_screen.dart';
import '../screens/customer/ordering/assistant_screen.dart';
import '../screens/customer/ordering/customization_screen.dart';
import '../screens/customer/ordering/order_summary_screen.dart';
import '../screens/customer/ordering/payment_screen.dart';
import '../screens/customer/ordering/confirmation_screen.dart';
import '../screens/customer/ordering/build_box_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/orders_management_screen.dart';
import '../screens/admin/order_details_screen.dart';
import '../screens/admin/inventory_screen.dart';
import '../screens/admin/batch_management_screen.dart';
import '../screens/admin/admin_profile_screen.dart';
import '../screens/admin/requests_screen.dart';

class AppRoutes {
  static const String loading = '/loading';
  static const String preview = '/preview';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String verification = '/verification';
  static const String customerShell = '/customer-shell';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String history = '/history';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String soloOrder = '/solo-order';
  static const String buildBox = '/build-box';
  static const String flavorIdeas = '/flavor-ideas';
  static const String customRequest = '/custom-request';
  static const String assistant = '/assistant';
  static const String customization = '/customization';
  static const String orderSummary = '/order-summary';
  static const String payment = '/payment';
  static const String confirmation = '/confirmation';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminOrders = '/admin-orders';
  static const String adminOrderDetails = '/admin-order-details';
  static const String adminInventory = '/admin-inventory';
  static const String adminBatch = '/admin-batch';
  static const String adminProfile = '/admin-profile';
  static const String adminRequests = '/admin-requests';

  static Map<String, WidgetBuilder> get routes => {
        loading: (context) => const LoadingScreen(),
        preview: (context) => const DesignPreviewScreen(),
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        verification: (context) => const VerificationScreen(),
        customerShell: (context) => const CustomerShell(),
        // The Home tab needs the shell's Scaffold/Material and bottom nav.
        home: (context) => const CustomerShell(),
        menu: (context) => const MenuScreen(),
        cart: (context) => const CartScreen(),
        orders: (context) => const OrdersScreen(),
        history: (context) => const HistoryScreen(),
        notifications: (context) => const NotificationsScreen(),
        profile: (context) => const ProfileScreen(),
        soloOrder: (context) => const SoloOrderScreen(),
        buildBox: (context) => const BuildBoxScreen(),
        flavorIdeas: (context) => const FlavorIdeasScreen(),
        customRequest: (context) => const CustomRequestScreen(),
        assistant: (context) => const AssistantScreen(),
        customization: (context) => const CustomizationScreen(),
        orderSummary: (context) => const OrderSummaryScreen(),
        payment: (context) => const PaymentScreen(),
        confirmation: (context) => const ConfirmationScreen(),
        adminDashboard: (context) => _AdminRouteGate(
              child: const AdminDashboardScreen(),
            ),
        adminOrders: (context) => _AdminRouteGate(
              child: const OrdersManagementScreen(),
            ),
        adminOrderDetails: (context) => _AdminRouteGate(
              child: const OrderDetailsScreen(),
            ),
        adminInventory: (context) => _AdminRouteGate(
              child: const InventoryScreen(),
            ),
        adminBatch: (context) => _AdminRouteGate(
              child: const BatchManagementScreen(),
            ),
        adminProfile: (context) => _AdminRouteGate(
              child: const AdminProfileScreen(),
            ),
        adminRequests: (context) =>
            _AdminRouteGate(child: const RequestsScreen()),
      };
}

class _AdminRouteGate extends StatelessWidget {
  final Widget child;

  const _AdminRouteGate({required this.child});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().role == 'admin') return child;

    return Scaffold(
      appBar: AppBar(title: const Text('Staff access')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 42),
              const SizedBox(height: 12),
              const Text(
                'Sign in with a staff demo account to open this screen.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                ),
                child: const Text('Go to sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
