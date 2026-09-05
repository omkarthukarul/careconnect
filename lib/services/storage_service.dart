import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: AppConstants.keyAuthToken, value: token);
    } catch (_) {}
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.keyAuthToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUserRole(String role) async {
    try {
      await _storage.write(key: AppConstants.keyUserRole, value: role);
    } catch (_) {}
  }

  Future<String?> getUserRole() async {
    try {
      return await _storage.read(key: AppConstants.keyUserRole);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }
}
