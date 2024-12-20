import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Mengambil ukuran SafeArea (width dan height)
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/newicon.png',
                      width: screenWidth * 0.2, // Contoh penggunaan screenWidth
                      height:
                          screenHeight * 0.10, // Contoh penggunaan screenHeight
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Brainys',
                      style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight
                              .w600 // Ukuran teks berdasarkan screenWidth
                          ),
                    ),
                    Text(
                      'Sistem AI yang cerdas untuk membantu guru mendapatkan referensi kreatif dan mempermudah administrasi akademik dengan cepat!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color:
                              Colors.grey // Ukuran teks berdasarkan screenWidth
                          ),
                    ),
                    Image.asset(
                      'assets/images/splash.jpg',
                      width: screenWidth * 0.9, // Contoh penggunaan screenWidth
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover, // Contoh penggunaan screenHeight
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      width: screenWidth, // Mengatur lebar sesuai screenWidth
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman LoginPage
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('Get Started', style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight
                              .w600,
                              color: Colors.white,
                              // Ukuran teks berdasarkan screenWidth
                        ),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(
                              0xFF144cd3), // Mengatur warna background button
                          padding: EdgeInsets.symmetric(
                            vertical: 14, // Padding vertikal sesuai screenHeight
                          ),
                        ),
                      ),
                    ),
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