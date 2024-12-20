import 'package:flutter/material.dart';
import 'package:brainys/widgets/registerPage/form_section.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    // Menggunakan Row untuk meletakkan gambar di pinggir kiri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Gambar di kiri
                      children: [
                        Image.asset(
                          'assets/images/newicon.png',
                          width: screenWidth * 0.3, // Contoh penggunaan screenWidth
                          height: screenHeight * 0.1,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
