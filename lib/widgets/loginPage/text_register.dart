import 'package:flutter/material.dart';


class TextRegister extends StatelessWidget {
  const TextRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Belum Punya Akun ? '),
            GestureDetector(
              onTap: () {
               Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Register',
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
