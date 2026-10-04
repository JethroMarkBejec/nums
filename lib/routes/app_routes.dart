import 'package:flutter/material.dart';

import '../screens/auth/loading_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/verification_screen.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/design_preview_screen.dart';
import '../screens/customer/customer_shell.dart';
import '../screens/customer/home_screen.dart';
import '../screens/customer/menu_screen.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/orders_screen.dart';
import '../screens/customer/history_screen.dart';
import '../screens/customer/notifications_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/customer/ordering/solo_order_screen.dart';
import '../screens/customer/ordering/assistant_screen.dart';
import '../screens/customer/ordering/customization_screen.dart';
import '../screens/customer/ordering/order_summary_screen.dart';
import '../screens/customer/ordering/payment_screen.dart';
import '../screens/customer/ordering/confirmation_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/orders_management_screen.dart';
import '../screens/admin/order_details_screen.dart';
import '../screens/admin/inventory_screen.dart';
import '../screens/admin/batch_management_screen.dart';
import '../screens/admin/admin_profile_screen.dart';

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

  static Map<String, WidgetBuilder> get routes => {
        loading: (context) => const LoadingScreen(),
        preview: (context) => const DesignPreviewScreen(),
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        verification: (context) => const VerificationScreen(),
        customerShell: (context) => const CustomerShell(),
        home: (context) => const HomeScreen(),
        menu: (context) => const MenuScreen(),
        cart: (context) => const CartScreen(),
        orders: (context) => const OrdersScreen(),
        history: (context) => const HistoryScreen(),
        notifications: (context) => const NotificationsScreen(),
        profile: (context) => const ProfileScreen(),
        soloOrder: (context) => const SoloOrderScreen(),
        assistant: (context) => const AssistantScreen(),
        customization: (context) => const CustomizationScreen(),
        orderSummary: (context) => const OrderSummaryScreen(),
        payment: (context) => const PaymentScreen(),
        confirmation: (context) => const ConfirmationScreen(),
        adminDashboard: (context) => const AdminDashboardScreen(),
        adminOrders: (context) => const OrdersManagementScreen(),
        adminOrderDetails: (context) => const OrderDetailsScreen(),
        adminInventory: (context) => const InventoryScreen(),
        adminBatch: (context) => const BatchManagementScreen(),
        adminProfile: (context) => const AdminProfileScreen(),
      };
}
