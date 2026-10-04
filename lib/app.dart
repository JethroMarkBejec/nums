import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'providers/auth_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/order_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class NumSApp extends StatelessWidget {
  const NumSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => BatchProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: 'nums',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.welcome,
        routes: AppRoutes.routes,
      ),
    );
  }
}
