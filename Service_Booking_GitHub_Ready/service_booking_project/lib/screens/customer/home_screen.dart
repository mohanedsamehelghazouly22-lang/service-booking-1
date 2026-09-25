import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import '../../models/models.dart';
import '../../repositories/app_repository.dart';
import '../../widgets/section_title.dart';
import 'booking_flow.dart';
import 'my_bookings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.api, required this.repository});
  final ApiClient api; final AppRepository repository;
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int tab = 0; List<ServiceItem> services = []; bool loading = true; String? error;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { try { final s = await widget.repository.services(); if (mounted) setState(() { services = s; loading = false; }); } catch (e) { if (mounted) setState(() { error = e.toString(); loading = false; }); } }

  @override Widget build(BuildContext context) {
    final body = tab == 0 ? _homeBody() : tab == 1 ? const MyBookingsScreen() : _profile();
    return Scaffold(backgroundColor: AppColors.peach, body: SafeArea(child: body), bottomNavigationBar: NavigationBar(backgroundColor: AppColors.ink, indicatorColor: AppColors.orange, selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Bookings'), NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile')]));
  }
  Widget _homeBody() => RefreshIndicator(onRefresh: _load, child: ListView(padding: const EdgeInsets.fromLTRB(20, 14, 20, 24), children: [
    Row(children: [const Expanded(child: Text('Service Booking', style: TextStyle(color: AppColors.ink, fontSize: 22, fontWeight: FontWeight.w900)),), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppColors.ink))]),
    const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(28)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('What do you need today?', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)), const SizedBox(height: 8), const Text('Choose a service, location and time.', style: TextStyle(color: Colors.white70)), const SizedBox(height: 20), Container(height: 52, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(17)), child: const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search services', fillColor: Colors.transparent)))])),
    const SizedBox(height: 28), const SectionTitle('Popular services'), const SizedBox(height: 14),
    if (loading) const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
    else if (error != null) _errorCard(error!)
    else if (services.isEmpty) _empty('No services available yet')
    else ...services.map((s) => _serviceCard(s)),
    const SizedBox(height: 12),
    const Text('Available slots update in real time.', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
  ]));
  Widget _serviceCard(ServiceItem s) => GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingFlow(repository: widget.repository, service: s))), child: Container(margin: const EdgeInsets.only(bottom: 14), height: 142, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24), image: s.imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(s.imageUrl), fit: BoxFit.cover, opacity: .55) : null), child: Padding(padding: const EdgeInsets.all(18), child: Align(alignment: Alignment.bottomLeft, child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(s.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)), if (s.description.isNotEmpty) Text(s.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70))]))));
  Widget _profile() => ListView(padding: const EdgeInsets.all(20), children: [const Text('Profile', style: TextStyle(color: AppColors.ink, fontSize: 32, fontWeight: FontWeight.w900)), const SizedBox(height: 20), _profileTile(Icons.person_outline, 'Personal details'), _profileTile(Icons.location_on_outlined, 'Governorate & city'), _profileTile(Icons.notifications_none, 'Notifications'), _profileTile(Icons.logout, 'Sign out')]);
  Widget _profileTile(IconData i, String t) => Card(color: AppColors.ink, child: ListTile(leading: Icon(i, color: AppColors.orange), title: Text(t), trailing: const Icon(Icons.chevron_right)));
  Widget _empty(String t) => Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)), child: Text(t));
  Widget _errorCard(String t) => _empty(t);
}
