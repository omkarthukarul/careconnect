import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

abstract class IAuthRepository {
  Future<UserModel> login({required String identifier, required String password, required UserRole role});
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class MockAuthRepository implements IAuthRepository {
  final StorageService _storage;
  UserModel? _currentUser;

  MockAuthRepository({StorageService? storage}) : _storage = storage ?? StorageService();

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
    required UserRole role,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final user = UserModel(
      id: 'USR-${role.name.toUpperCase()}-001',
      name: _getDefaultNameForRole(role),
      email: identifier.contains('@') ? identifier : 'user@careconnect.mh.gov.in',
      mobile: identifier.contains('@') ? '9876543210' : identifier,
      role: role,
      facilityName: _getDefaultFacilityForRole(role),
      district: 'Pune',
    );

    _currentUser = user;
    await _storage.saveToken('mock_jwt_token_for_${role.name}');
    await _storage.saveUserRole(role.name);
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _storage.clearAll();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  String _getDefaultNameForRole(UserRole role) {
    switch (role) {
      case UserRole.medicalOfficer:
        return 'Dr. Sunil Deshmukh, MBBS';
      case UserRole.hospitalStaff:
        return 'Sister Sunita More (Bed Manager)';
      case UserRole.ambulanceEMS:
        return 'Sambhaji Shinde (Pilot, ALS 108)';
      case UserRole.patient:
        return 'Ramesh Balasaheb Patil';
    }
  }

  String _getDefaultFacilityForRole(UserRole role) {
    switch (role) {
      case UserRole.medicalOfficer:
        return 'Shirur Primary Health Centre (PHC)';
      case UserRole.hospitalStaff:
        return 'District Hospital Pune (Aundh)';
      case UserRole.ambulanceEMS:
        return '108 Ambulance Hub - Shirur Unit';
      case UserRole.patient:
        return 'Shirur, Pune';
    }
  }
}

/// Production implementation ready to bind with real Node.js REST API
class ApiAuthRepository implements IAuthRepository {
  final ApiService _api;
  final StorageService _storage;

  ApiAuthRepository({required ApiService api, required StorageService storage})
      : _api = api,
        _storage = storage;

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
    required UserRole role,
  }) async {
    final response = await _api.post('/auth/login', data: {
      'identifier': identifier,
      'password': password,
      'role': role.name,
    });
    final token = response.data['token'] as String;
    final userData = UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    await _storage.saveToken(token);
    await _storage.saveUserRole(role.name);
    return userData;
  }

  @override
  Future<void> logout() async {
    await _storage.clearAll();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _api.get('/auth/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
