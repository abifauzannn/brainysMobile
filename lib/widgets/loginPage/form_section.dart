import 'package:brainys/screens/authentication/splash.dart';
import 'package:brainys/screens/mainscreen/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:brainys/widgets/loginPage/text_forget.dart';
import 'package:brainys/widgets/loginPage/text_register.dart';
import '../../services/api.dart';

class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Tambahkan variabel _isLoading
  bool _isGoogleLoading = false;

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

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password cannot be empty';
    }

    return null;
  }

  Widget buildTitle() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Login',
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
    return TextFormField(
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
    String? passwordError = validatePassword(_passwordController.text);

    if (usernameError == null && passwordError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await AuthService().login(
          _usernameController.text,
          _passwordController.text,
        );

        if (response['status'] == 'success') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
          showSuccessSnackBar("Login Successful");
        }
      } catch (error) {
        // Display only the server error message
        final errorMessage = error is String ? error : 'An error occurred';
        showErrorSnackBar(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (usernameError != null) {
        showErrorSnackBar(usernameError);
      }
      if (passwordError != null) {
        showErrorSnackBar(passwordError);
      }
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
          : const Text('Login'), // Tampilkan teks Login jika _isLoading false
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
                    buildLoginButton(),
                    const SizedBox(height: 10),
                    TextForget(),
                    const SizedBox(height: 10),
                    buildOrDivider(),
                    const SizedBox(height: 10),
                    buildLoginGoogle(),
                    const SizedBox(height: 20),
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
