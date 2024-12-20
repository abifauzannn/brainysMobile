import 'package:brainys/services/api.dart';
import 'package:flutter/material.dart';
import 'package:brainys/screens/authentication/login_page.dart';
import 'package:brainys/widgets/loginPage/text_forget.dart';
import 'package:brainys/widgets/loginPage/text_register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../screens/mainscreen/mainscreen.dart';
// Import the auth service


class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage(); // Tambahkan ini
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Tambahkan variabel _isLoading
  bool _isLogout = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Email cannot be empty';
    }
    return null;
  }

  Widget buildTitle() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Reedem Invitation Code',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Silakan periksa kode undangan di inbox (Kotak Masuk) email Anda! Jika tidak ada, silahkan cek dibagian spam ',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildDescription() {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        '',
        style: TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: 'Invitation Code',
        filled: true,
        fillColor: const Color(0xFFF6F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  void showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.red),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.dangerous, color: Colors.red),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
                Text(
                  error,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.green),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Successful!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleLoginButtonPressed() async {
    String? usernameError = validateUsername(_usernameController.text);

    // Check if there's a validation error for the username
    if (usernameError != null) {
      showErrorSnackBar(
          usernameError); // Show error if username validation fails
      return; // Exit early to prevent further processing
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Try to redeem the invitation code
      final response = await AuthService().reedemInvitationCode(
        _usernameController.text,
      );

      print('Response: $response'); // Debug log for the response

      // Compare response status safely
      if (response['status'] == true) {
        // If the response status is success, navigate to the main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        showSuccessSnackBar(response['message'] ?? 'Pendaftaran berhasil!');
      } else {
        // If the response status is not success, show an error message
        showErrorSnackBar(response['message'] ?? 'An unknown error occurred');
      }
    } catch (error) {
      // Display only the server error message in case of an exception
      String errorMessage = error is String ? error : 'An error occurred';
      showErrorSnackBar(errorMessage);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _logout() async {
  try {
    // Clear the token and user data from secure storage
    await _secureStorage.delete(key: 'token'); // Remove the token
    await _secureStorage.delete(key: 'user');  // Remove the user data

    // Redirect to the LoginPage after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  } catch (error) {
    print('Error during logout: $error');
    // Handle logout error (optional)
    showErrorSnackBar('Gagal logout. Silakan coba lagi.');
  }
}


  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : handleLoginButtonPressed, // Tambahkan kondisi _isLoading
      child: _isLoading
          ? CircularProgressIndicator(
              strokeWidth: 2, // Ketebalan garis lingkaran
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue), // Warna indikator
              backgroundColor: Colors
                  .grey, // Warna latar belakang indikator// Ubah ukuran sesuai kebutuhan Anda
            ) // Tampilkan CircularProgressIndicator jika _isLoading true
          : const Text('Submit'), // Tampilkan teks Login jika _isLoading false
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
    );
  }

  Widget buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout, // Tambahkan kondisi _isLoading
      child: _isLogout
          ? CircularProgressIndicator(
              strokeWidth: 2, // Ketebalan garis lingkaran
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue), // Warna indikator
              backgroundColor: Colors
                  .grey, // Warna latar belakang indikator// Ubah ukuran sesuai kebutuhan Anda
            ) // Tampilkan CircularProgressIndicator jika _isLoading true
          : const Text('Logout'), // Tampilkan teks Login jika _isLoading false
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF144cd3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        textStyle: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
    );
  }

  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Atur posisi tombol di tengah
      children: [
        Expanded(
          child: buildLoginButton(), // Tombol Submit
        ),
        const SizedBox(width: 10), // Jarak antar tombol
        Expanded(
          child: buildLogoutButton(), // Tombol Logout
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Center(
        // Tambahkan Center untuk memastikan teks berada di tengah
        child: SingleChildScrollView(
          // Untuk mendukung layar kecil
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Pusatkan konten secara vertikal
                children: [
                  const SizedBox(height: 30),
                  buildTitle(),
                  const SizedBox(height: 15),
                  buildUsernameTextField(),
                  const SizedBox(height: 10),
                  buildButtonRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
