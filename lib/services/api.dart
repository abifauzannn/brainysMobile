import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Endpoint untuk login
  static const String _loginUrl = 'https://testing.brainys.oasys.id/api/login';

  // Instance FlutterSecureStorage untuk menyimpan token
  final _secureStorage = FlutterSecureStorage();

  // Method untuk login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['status'] == 'success') {
          String? token = data['data']['token'];

          if (token != null) {
            await _secureStorage.write(key: 'token', value: token);
            print('Login successful and token stored securely.');

            // Store user data (optional)
            if (data['user'] != null) {
              await _secureStorage.write(
                  key: 'userData', value: jsonEncode(data['user']));
            }

            return data;
          } else {
            throw Exception('Token not found in response');
          }
        } else {
          throw data['message'] ?? 'Login failed';
        }
      } else {
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'An error occurred';
      }
    } catch (error) {
      print('Login error: $error');
      rethrow;
    }
  }

  // Method untuk mendapatkan data user profile
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      const String userProfileUrl =
          'https://testing.brainys.oasys.id/api/user-profile';

      // Ambil token dari secure storage
      final token = await getToken();

      if (token == null) {
        throw 'Token is missing. Please log in again.';
      }

      // Request data user profile
      final response = await http.get(
        Uri.parse(userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'success') {
          throw data['message'] ?? 'Failed to fetch user profile';
        }

        return data;
      } else {
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'Failed to fetch user profile';
      }
    } catch (error) {
      print('Fetch user profile error: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserStatus() async {
    try {
      const String userProfileUrl =
          'https://testing.brainys.oasys.id/api/user-status';

      // Ambil token dari secure storage
      final token = await getToken();

      if (token == null) {
        throw 'Token is missing. Please log in again.';
      }

      // Request data user profile
      final response = await http.get(
        Uri.parse(userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'success') {
          throw data['message'] ?? 'Failed to fetch user profile';
        }

        return data;
      } else {
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'Failed to fetch user profile';
      }
    } catch (error) {
      print('Fetch user profile error: $error');
      rethrow;
    }
  }

  // Method untuk logout (hapus token)
  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String confirmationPassword) async {
    final String registerUrl =
        'https://testing.brainys.oasys.id/api/register'; // Ganti dengan URL endpoint yang benar

    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': username,
          'password': password,
          'password_confirmation': confirmationPassword,
        }),
      );

      // Tampilkan respons lengkap di konsol
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final Map<String, dynamic> data = json.decode(response.body);

      // Cek jika status adalah success
      if (data['status'] == 'success') {
        return {
          'status': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        // Tangani error jika status bukan success (error dalam response)
        if (data['data'] != null && data['data']['email'] != null) {
          // Periksa jika ada kesalahan spesifik pada email
          final emailErrors = data['data']['email'];
          if (emailErrors.contains('validation.unique')) {
            return {
              'status': false,
              'message': 'Email sudah digunakan.',
            };
          }
        }

        // Fallback untuk pesan error lainnya jika tidak ada kesalahan spesifik pada email
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
          'errors': data['data'] ?? {},
        };
      }
    } catch (error) {
      // Tangani exception jika terjadi error selama permintaan API
      print('Error saat registrasi: $error');
      return {
        'status': false,
        'message': 'Gagal mendaftarkan akun. Silakan coba lagi.',
      };
    }
  }

  // Verifikasi OTP method (no longer static)
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    const String _verifyOtpUrl =
        'https://testing.brainys.oasys.id/api/verify-otp';
    try {
      // Request ke API
      final response = await http.post(
        Uri.parse(_verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Extract the token
        String token = data['data']['token'];

        // Store the token in secure storage
        await _secureStorage.write(key: 'token', value: token);

        // For debugging purposes only (remove in production)
        print('Stored Token: $token');

        return {
          'status': true,
          'message': data['message'],
          'token': token,
          'user': data['data']['user'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      return {
        'status': false,
        'message': 'Gagal verifikasi OTP. Silakan coba lagi.',
      };
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, dynamic>> profileCompleted(String name, String school_name,
      String profession, String school_level) async {
    String _profileCompletedUrl =
        'https://testing.brainys.oasys.id/api/profile';

    try {
      // Retrieve the stored token
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      // Make the request to the API with the token
      final response = await http.post(
        Uri.parse(_profileCompletedUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'school_name': school_name,
          'profession': profession,
          'school_level': school_level,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'status': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during profile completion: $error');
      return {
        'status': false,
        'message': 'Gagal melengkapi profil. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(String name, String school_name,
      String profession, String school_level) async {
    String _profileCompletedUrl =
        'https://testing.brainys.oasys.id/api/update-profile';

    try {
      // Retrieve the stored token
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      // Make the request to the API with the token
      final response = await http.post(
        Uri.parse(_profileCompletedUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'school_name': school_name,
          'profession': profession,
          'school_level': school_level,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'status': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during profile completion: $error');
      return {
        'status': false,
        'message': 'Gagal melengkapi profil. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> reedemInvitationCode(String code) async {
    String _reedemInvitationCodeUrl =
        'https://testing.brainys.oasys.id/api/user-invitations/redeem';

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(_reedemInvitationCodeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'invite_code': code}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'status': true,
          'message': data['message'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat redeem kode.',
        };
      }
    } catch (error) {
      print('Error during redeeming invitation code: $error');
      return {
        'status': false,
        'message': 'Gagal redeem kode undangan. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> generateModulAjar(String name, String phase,
      String subject, String element, String notes) async {
    String _generateModulAjarUrl =
        'https://testing.brainys.oasys.id/api/modul-ajar/generate';

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(_generateModulAjarUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'name': name,
          'phase': phase,
          'subject': subject,
          'element': element,
          'notes': notes
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Store user data in SharedPreferences
        return {
          'status': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      return {
        'status': false,
        'message': 'Gagal verifikasi OTP. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> generateSoal(
    String name,
    String phase,
    String subject,
    String element,
    String numberOfQuestion,
    String notes,
    String type,
  ) async {
    // Tentukan URL endpoint berdasarkan nilai `type`
    String url;
    if (type == 'multiple_choice') {
      url = 'https://testing.brainys.oasys.id/api/exercise-v2/generate-choice';
    } else if (type == 'essay') {
      url = 'https://testing.brainys.oasys.id/api/exercise-v2/generate-essay';
    } else {
      url = 'https://testing.brainys.oasys.id/api/modul-ajar/generate';
    }

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phase': phase,
          'subject': subject,
          'element': element,
          'number_of_questions': numberOfQuestion,
          'notes': notes,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Return the response data
        return {
          'status': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during soal generation: $error');
      return {
        'status': false,
        'message': 'Gagal membuat soal. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> GenerateBahanAjar(String name, String grade,
      String subject, String notes) async {
    String _generateModulAjarUrl =
        'https://testing.brainys.oasys.id/api/bahan-ajar/generate';

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(_generateModulAjarUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'name' : name,
          'grade' : grade,
          'subject' : subject,
          'notes' : notes,
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Store user data in SharedPreferences
        return {
          'status': true,
          'message': data['message'],
          'data': data['data'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      return {
        'status': false,
        'message': 'Gagal verifikasi OTP. Silakan coba lagi.',
      };
    }
  }
}
