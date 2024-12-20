import 'package:flutter/material.dart';


class TextForget extends StatelessWidget {
  const TextForget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
               
              },
              child: Text(
                'Lupa Password ?',
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: const Color(0xFF144cd3),// Mengubah warna ke format yang valid
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
