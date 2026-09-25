import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/api_client.dart';
import 'repositories/app_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/provider/provider_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';

void main() => runApp(const ServiceBookingApp());

class ServiceBookingApp extends StatelessWidget {
  const ServiceBookingApp({super.key});
  @override
  Widget build(BuildContext context) {
    final api = ApiClient();
    final repo = AppRepository(api);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Booking',
      theme: buildTheme(),
      home: LoginScreen(api: api, repository: repo),
      routes: {'/home': (_) => HomeScreen(api: api, repository: repo), '/provider': (_) => const ProviderDashboard(), '/admin': (_) => const AdminDashboard()},
    );
  }
}
