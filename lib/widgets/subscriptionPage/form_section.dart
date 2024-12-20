import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/api.dart';
import 'package:brainys/screens/authentication/login_page.dart';

class DetailInformation extends StatefulWidget {
  const DetailInformation({Key? key}) : super(key: key);

  @override
  _DetailInformationState createState() => _DetailInformationState();
}

class _DetailInformationState extends State<DetailInformation> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _professionController = TextEditingController();
  final _secureStorage = FlutterSecureStorage();
  bool _isEditing = false;
  bool _isLoading = false;
  String? _selectedLevel;
  String _errorMessage = ''; // For displaying errors

  // Instance of AuthService
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch the user profile
  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset error message
    });

    try {
      final userProfile = await _authService.fetchUserProfile();

      // Populate controllers with user profile data
      _usernameController.text = userProfile['data']['name'];
      _schoolController.text = userProfile['data']['school_name'];
      _professionController.text = userProfile['data']['profession'];

      // Set the dropdown value according to the fetched school level
      setState(() {
        _selectedLevel =
            userProfile['data']['school_level']; // Set the school_level
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString(); // Capture the error message
      });
    }
  }

  Future<void> _logout() async {
    // Clear the token from SharedPreferences (or wherever it's stored)
    await _secureStorage.delete(key: 'token');

    // After removing the token, redirect to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Jenjang',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLevel,
          items: [
            {'label': 'SD/MI Sederajat', 'value': 'sd'},
            {'label': 'SMP/MTs Sederajat', 'value': 'smp'},
            {'label': 'SMA/SMK/MA Sederajat', 'value': 'sma'},
            {'label': 'Pendidikan Kesetaraan Paket A', 'value': 'paketa'},
            {'label': 'Pendidikan Kesetaraan Paket B', 'value': 'paketb'},
            {'label': 'Pendidikan Kesetaraan Paket C', 'value': 'paketc'},
          ].map((level) {
            return DropdownMenuItem<String>(
              value: level['value'],
              child: Text(level['label']!),
            );
          }).toList(),
          onChanged: _isEditing
              ? (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Jenjang tidak boleh kosong';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: _isEditing ? const Color(0xFFF6F7FA) : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? const Color(0xFFF6F7FA) : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildActionButtons() {
    return _isEditing
        ? Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: handleSave,
                  icon: const Icon(
                    Icons.save,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C3B98), // Warna dasar (primary)
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: handleCancel,
                  icon: const Icon(
                    Icons.cancel,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('Batalkan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF092C73), // Warna gelap (dark)
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: handleEdit,
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2453B4), // Warna sedang (medium)
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF092C73), // Warna gelap untuk logout
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.red),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.dangerous, color: Colors.red),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
                Text(
                  error,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.green),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Successful!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: 'poppins',
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void handleCancel() {
    setState(() {
      _isEditing = false;
    });
  }

  void handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if all required fields are selected
      if (_usernameController.text.isEmpty ||
          _schoolController.text.isEmpty ||
          _professionController.text.isEmpty ||
          _selectedLevel == null) {
        showErrorSnackBar('Semua kolom harus diisi.');
        return;
      }

      setState(() {
        _isLoading =
            true; // Show loading indicator while the API request is being processed
      });

      try {
        final response = await AuthService().updateProfile(
          _usernameController.text,
          _schoolController.text,
          _professionController.text,
          _selectedLevel!,
        );

        if (response['status'] == true) {
          print('$response');
          showSuccessSnackBar(response['message']);

          // After successful update, call _fetchUserProfile again to fetch the updated data
          await _fetchUserProfile(); // Fetch updated profile
        } else {
          showErrorSnackBar(response['message']);
        }
      } catch (error) {
        // Handle error response from API call
        final errorMessage = error is String ? error : 'Terjadi kesalahan';
        showErrorSnackBar(errorMessage);
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _schoolController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: ScrollBehavior()
            .copyWith(scrollbars: false), // Removes the scroll indicator
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty)
                  Center(
                      child: Text(_errorMessage,
                          style: TextStyle(color: Colors.red))),
                buildTextField(
                  label: 'Nama Lengkap',
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ),
                buildTextField(
                  label: 'Asal Sekolah',
                  controller: _schoolController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Asal Sekolah tidak boleh kosong';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ),
                buildTextField(
                  label: 'Profesi',
                  controller: _professionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Profesi tidak boleh kosong';
                    }
                    return null;
                  },
                  enabled: _isEditing,
                ),
                buildDropdown(),
                buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
