import '../core/api_client.dart';
import '../models/models.dart';

class AppRepository {
  AppRepository(this.api);
  final ApiClient api;

  Future<List<ServiceItem>> services() async => (await api.request('GET', '/services', auth: false))['items'].map<ServiceItem>((e) => ServiceItem.fromJson(e)).toList();
  Future<List<LocationItem>> locations(String serviceId) async => (await api.request('GET', '/services/$serviceId/locations', auth: false))['items'].map<LocationItem>((e) => LocationItem.fromJson(e)).toList();
  Future<List<SlotItem>> slots({required String serviceId, required String locationId, required String date}) async => (await api.request('GET', '/slots?service_id=$serviceId&location_id=$locationId&date=$date', auth: false))['items'].map<SlotItem>((e) => SlotItem.fromJson(e)).toList();
  Future<Map<String, dynamic>> sendOtp(String phone) => api.request('POST', '/auth/phone/request', body: {'phone': phone}, auth: false);
  Future<Map<String, dynamic>> verifyOtp(String phone, String code) => api.request('POST', '/auth/phone/verify', body: {'phone': phone, 'code': code}, auth: false);
  Future<Map<String, dynamic>> googleAuth(String idToken) => api.request('POST', '/auth/google', body: {'id_token': idToken}, auth: false);
  Future<Map<String, dynamic>> me() => api.request('GET', '/me');
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> body) => api.request('POST', '/bookings', body: body);
  Future<List<BookingItem>> myBookings() async => (await api.request('GET', '/bookings/me'))['items'].map<BookingItem>((e) => BookingItem.fromJson(e)).toList();
  Future<void> cancelBooking(String id) async { await api.request('POST', '/bookings/$id/cancel'); }
}
