import 'package:flutter/material.dart';
import '../../widgets/loginPage/form_section.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  // Method to print th

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Mengambil ukuran SafeArea (width dan height)
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/newlogo.png',
                      width: screenWidth * 0.5, // Contoh penggunaan screenWidth
                      height: screenHeight * 0.1,
                      // fit: BoxFit.cover, // Contoh penggunaan screenHeight
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    FormSection(),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
