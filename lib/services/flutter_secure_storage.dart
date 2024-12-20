import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = FlutterSecureStorage();

  // Save profile data to storage
  Future<void> saveProfileData(Map<String, String> profileData) async {
    await _storage.write(key: 'userName', value: profileData['name']);
    await _storage.write(key: 'userSchool', value: profileData['school_name']);
    await _storage.write(key: 'userCredit', value: profileData['credit_balance']);
  }

  // Get profile data from storage
  Future<Map<String, String>> getProfileData() async {
    String userName = await _storage.read(key: 'userName') ?? 'Unknown';
    String userSchool = await _storage.read(key: 'userSchool') ?? 'Unknown';
    String userCredit = await _storage.read(key: 'userCredit') ?? '0';
    return {
      'name': userName,
      'school_name': userSchool,
      'credit_balance': userCredit,
    };
  }
}
