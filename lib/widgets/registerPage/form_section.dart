import 'package:brainys/screens/authentication/splash.dart';
import 'package:brainys/screens/authentication/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:brainys/widgets/registerPage/text_register.dart';
import '../../services/api.dart';
// import 'package:brainys/screens/authentication/verify_otp.dart';
// import 'package:brainys/services/auth_service.dart';

class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  Color passwordTextColor = Colors.black; // Warna default untuk text

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 8) {
      return 'Password harus lebih dari 8 karakter';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords tidak sama';
    }
    return null;
  }

  // Fungsi untuk cek panjang password dan ubah warna teks
  void checkPasswordLength(String value) {
    setState(() {
      if (value.isEmpty) {
        passwordTextColor = Colors.black; // Default hitam jika belum ada input
      } else if (value.length < 8) {
        passwordTextColor = Colors.red; // Merah jika kurang dari 8 karakter
      } else {
        passwordTextColor = Colors.green; // Hijau jika 8 karakter atau lebih
      }
    });
  }

  Widget buildTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Registrasi',
        style: TextStyle(
          fontFamily: 'poppins',
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget buildUsernameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
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

  Widget buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: !_isPasswordVisible,
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
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
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black45,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          onChanged:
              checkPasswordLength, // Setiap kali password diubah, cek panjang
          validator: validatePassword,
        ),
        const SizedBox(height: 5),
        Text(
          'Minimal password 8 karakter',
          style: TextStyle(
            color: passwordTextColor, // Warna teks sesuai panjang password
            fontSize: 12,
            fontFamily: 'poppins',
          ),
        ),
      ],
    );
  }

  Widget buildConfirmPasswordTextField() {
    return TextFormField(
      obscureText: !_isConfirmPasswordVisible,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
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
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      validator: validateConfirmPassword,
    );
  }

  void handleRegisterButtonPressed() async {
    String? usernameError = validateUsername(_usernameController.text);
    String? passwordError = validatePassword(_passwordController.text);
    String? confirmPasswordError =
        validateConfirmPassword(_confirmPasswordController.text);

    if (usernameError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Panggil fungsi register
        final response = await AuthService().register(
          _usernameController.text,
          _passwordController.text,
          _confirmPasswordController.text,
        );

        // Debug log untuk memastikan respons
        print('Register Response: $response');

        // Verifikasi status respon API
        if (response['status'] == true) {
          // Periksa status true
          // Tampilkan success snackbar
          showSuccessSnackBar(response['message'] ?? 'Pendaftaran berhasil!');
          // Navigasi ke layar OTP
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OTPScreen(email: _usernameController.text,),
            ),
          );
        } else if (response['status'] == false) {
          // Jika status adalah false, periksa apakah ada error pada email
          if (response['data'] != null && response['data']['email'] != null) {
            // Jika email sudah digunakan
            if (response['data']['email'].contains('validation.unique')) {
              showErrorSnackBar('Email sudah digunakan');
            } else {
              // Menampilkan error message lain jika ada
              showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
            }
          } else {
            showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
          }
        } else {
          // Default error handling jika status tidak dikenali
          showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
        }
      } catch (error) {
        // Tampilkan pesan error jika terjadi exception
        final errorMessage = error is String ? error : 'Terjadi kesalahan.';
        showErrorSnackBar(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Tampilkan validasi error jika ada
      if (usernameError != null) showErrorSnackBar(usernameError);
      if (passwordError != null) showErrorSnackBar(passwordError);
      if (confirmPasswordError != null) showErrorSnackBar(confirmPasswordError);
    }
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

  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : handleRegisterButtonPressed,
      child: _isLoading
          ? const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey,
            )
          : const Text('Sign Up'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF144cd3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
    );
  }

  Widget buildOrDivider() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "atau",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget buildLoginGoogle() {
    return ElevatedButton(
      onPressed: _isGoogleLoading
          ? null
          : () {
              setState(() {
                _isGoogleLoading = true;
              });

              // Simulasi proses login Google
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  _isGoogleLoading = false;
                });
              });
            },
      child: _isGoogleLoading
          ? CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey,
            )
          : const Text('Sign in with Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    buildTitle(),
                    const SizedBox(height: 15),
                    buildUsernameTextField(),
                    const SizedBox(height: 10),
                    buildPasswordTextField(),
                    const SizedBox(height: 10),
                    buildConfirmPasswordTextField(),
                    const SizedBox(height: 10),
                    buildLoginButton(),
                    const SizedBox(height: 15),
                    buildOrDivider(),
                    const SizedBox(height: 15),
                    buildLoginGoogle(),
                    const SizedBox(height: 15),
                    TextRegister(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
