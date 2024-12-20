import 'package:brainys/screens/authentication/splash.dart';
import 'package:flutter/material.dart';
import '../../services/api.dart'; // Import the ApiService
import 'profile_page.dart'; 

class OTPScreen extends StatefulWidget {
  String email;

  OTPScreen({required this.email});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _isLoading = false; // Add _isLoading variable

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool isOTPComplete() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Success!',
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
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ],
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
            const Icon(Icons.error, color: Colors.red),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Expanded(
              child: Column(
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
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F7FA),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.all(12),
                  splashRadius: 24,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                'Masukkan OTP yang Anda terima melalui Email ${widget.email} untuk verifikasi:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for (var i = 0; i < 6; i++)
                    SizedBox(
                      width: 40.0,
                      child: TextFormField(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            if (i > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[i - 1]);
                            }
                          } else {
                            if (i < 5) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[i + 1]);
                            } else {
                              _focusNodes[i].unfocus();
                            }
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isOTPComplete() ? const Color(0xFF144cd3) : Colors.grey,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
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
                onPressed: isOTPComplete() && !_isLoading
                    ? () async {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          // Buat instance dari AuthService
                          final authService = AuthService();

                          // Collect the OTP from the controllers
                          String email =
                              widget.email; // Replace with actual email
                          String otp = _controllers.map((e) => e.text).join();

                          // Gunakan instance untuk memanggil verifyOtp
                          final response =
                              await authService.verifyOtp(email, otp);

                          setState(() {
                            _isLoading = false;
                          });

                          if (response['status'] == true) {
                            // Navigate to ProfilePage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                            showSuccessSnackBar(response['message']);
                          } else {
                            showErrorSnackBar(response['message']);
                          }
                        } catch (error) {
                          setState(() {
                            _isLoading = false;
                          });
                          showErrorSnackBar(
                              'Terjadi kesalahan. Silakan coba lagi.');
                        }
                      }
                    : null,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Verifikasi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
