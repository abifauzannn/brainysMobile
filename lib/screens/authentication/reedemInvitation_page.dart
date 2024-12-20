import 'package:flutter/material.dart';
import '../../widgets/reedemInvitationPage/form_section.dart';


class ReedemInvitationPage extends StatefulWidget {
  @override
  _ReedemInvitationPageState createState() => _ReedemInvitationPageState();
}

class _ReedemInvitationPageState extends State<ReedemInvitationPage> {
  @override
  void initState() {
    super.initState();
  }

  // Method to print the auth token from SharedPreferences

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
              FormSection(),
            ],
          ),
        ),
      ),
    );
  }
}
