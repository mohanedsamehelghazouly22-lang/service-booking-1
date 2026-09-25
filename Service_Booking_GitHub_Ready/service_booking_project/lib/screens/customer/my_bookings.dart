import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../repositories/app_repository.dart';
import '../../core/api_client.dart';

class MyBookingsScreen extends StatefulWidget { const MyBookingsScreen({super.key}); @override State<MyBookingsScreen> createState() => _MyBookingsScreenState(); }
class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final repo = AppRepository(ApiClient()); List<BookingItem> items = []; bool loading = true;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { items = await repo.myBookings(); } catch (_) {} if (mounted) setState(() => loading = false); }
  @override Widget build(BuildContext context) => RefreshIndicator(onRefresh: () async { await _load(); }, child: ListView(padding: const EdgeInsets.all(20), children: [const Text('My Bookings', style: TextStyle(color: AppColors.ink, fontSize: 32, fontWeight: FontWeight.w900)), const SizedBox(height: 18), if (loading) const Center(child: CircularProgressIndicator()) else if (items.isEmpty) Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(24)), child: const Text('Your bookings will appear here.')) else ...items.map((b) => Card(color: AppColors.ink, margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text(b.serviceName, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('${b.locationName}\n${b.date} • ${b.time}'), isThreeLine: true, trailing: Text(b.status, style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w800))))]));
}
