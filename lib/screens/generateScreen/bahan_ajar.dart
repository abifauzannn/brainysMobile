import 'package:flutter/material.dart';
import '../../widgets/generatePage/form_bahanAjar.dart';

class GenerateBahanAjar extends StatefulWidget {
  @override
  _GenerateBahanAjarState createState() => _GenerateBahanAjarState();
}

class _GenerateBahanAjarState extends State<GenerateBahanAjar> {
  @override
  void initState() {
    super.initState();
    // Call method to print the auth token
    
  }

  // Method to print the auth token from SharedPreferences
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white, // Pastikan latar belakang Scaffold putih
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: IconButton(
                            icon:
                                Icon(Icons.arrow_back, color: Colors.grey[600]),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.all(12),
                            splashRadius: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: FormSection(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
