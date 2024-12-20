import 'package:flutter/material.dart';

class OnboardingSection extends StatelessWidget {
  const OnboardingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 100 / 70,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.topCenter,
              image: AssetImage('assets/images/newlogo.png'), // Path gambar dari assets
            ),
          ),
        ),
      ),
    );
  }
}
