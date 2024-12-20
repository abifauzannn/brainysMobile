import 'package:flutter/material.dart';
import 'package:brainys/widgets/subscriptionPage/form_section.dart';
import '../../services/api.dart';

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  bool isLoading = true;
  String userName = '';
  String userSchool = '';
  String userCredit = '0';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final data = await AuthService().fetchUserProfile();

      setState(() {
        userName = data['data']['name'] ?? 'Unknown';
        userSchool = data['data']['school_name'] ?? 'Unknown';
        userCredit = data['data']['credit_balance'] ?? '0';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar Section
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF0C3B98),
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User Name
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              userName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(height: 5),

                      // User School
                      isLoading
                          ? SizedBox.shrink()
                          : Text(
                              userSchool,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // Credit Balance Section
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: const Color(0xFF0C3B98),
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Credit Balance',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$$userCredit',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black38,
                        size: 18,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Main Content Section
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Adjust height dynamically
                  child: DetailInformation(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
