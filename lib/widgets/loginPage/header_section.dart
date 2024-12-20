import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20), // Padding kanan dan kiri
        child: Row(
          // Row untuk mengelompokkan gambar dan teks
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan elemen secara vertikal
          children: [
            const Text(
              'OASYS',
              style: TextStyle(
                fontFamily: 'poppins',
                fontSize: 38,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 20), // Jarak antara gambar dan teks
          ],
        ),
      ),
    );
  }
}
