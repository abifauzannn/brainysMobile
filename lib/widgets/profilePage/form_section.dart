import 'package:brainys/screens/authentication/reedemInvitation_page.dart';
import 'package:flutter/material.dart';

import '../../services/api.dart';
class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _professionController = TextEditingController();

  bool _isLoading = false; // Tambahkan variabel _isLoading

   String? _selectedLevel;
  final List<Map<String, String>> _levels = [
    {'label': 'SD/MI Sederajat', 'value': 'sd'},
    {'label': 'SMP/MTs Sederajat', 'value': 'smp'},
    {'label': 'SMA/SMK/MA Sederajat', 'value': 'sma'},
    {'label': 'Pendidikan Kesetaraan Paket A', 'value': 'paketa'},
    {'label': 'Pendidikan Kesetaraan Paket B', 'value': 'paketb'},
    {'label': 'Pendidikan Kesetaraan Paket C', 'value': 'paketc'},
  ];
  @override
  void dispose() {
    _usernameController.dispose();
    _professionController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value!.isEmpty) {
      return 'Nama Lengkap tidak boleh kosong';
    }
    return null;
  }

  String? validateSchool(String? value) {
    if (value!.isEmpty) {
      return 'Asal Sekolah tidak boleh kosong';
    }
    return null;
  }

  String? validateProffesion(String? value) {
    if (value!.isEmpty) {
      return 'Profesi tidak boleh kosong';
    }
    return null;
  }


  Widget buildTitle() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Menyusun item di tengah secara vertikal
      crossAxisAlignment: CrossAxisAlignment.center, // Menyusun item di tengah secara horizontal
      children: const [
        Text(
          'Lengkapi Profil',
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center, // Memastikan teks sejajar di tengah
        ),
        SizedBox(height: 30), // Menambahkan jarak antar teks
        Text(
          'Silahkan lengkapi profile anda terlebih dahulu',
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 18, // Ukuran lebih kecil agar lebih proporsional
            color: Colors.black54,
          ),
          textAlign: TextAlign.center, // Memastikan teks sejajar di tengah
        ),
      ],
    ),
  );
}


  Widget buildFullNameTextField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        filled: true,
        fillColor: const Color(0xFFF6F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget buildSchoolTextField() {
    return TextFormField(
      controller: _schoolController,
      decoration: InputDecoration(
        labelText: 'Sekolah',
        filled: true,
        fillColor: const Color(0xFFF6F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
    }

    Widget buildProffesionTextField() {
    return TextFormField(
      controller: _professionController,
      decoration: InputDecoration(
        labelText: 'Profesi',
        filled: true,
        fillColor: const Color(0xFFF6F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        labelStyle: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
    }

    Widget buildDropdownSelect() {
    return DropdownButtonFormField<String>(
      value: _selectedLevel,
      decoration: InputDecoration(
        labelText: 'Pilih Jenjang',
        filled: true,
        fillColor: const Color(0xFFF6F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      items: _levels.map((level) {
        return DropdownMenuItem<String>(
          value: level['value'], // Gunakan nilai dari value
          child: Text(
            level['label']!, // Tampilkan label
            style: const TextStyle(fontFamily: 'poppins'),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLevel = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Jenjang tidak boleh kosong';
        }
        return null;
      },
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

 void handleLoginButtonPressed() async {
  String? usernameError = validateUsername(_usernameController.text);
    String? schoolError = validateSchool(_schoolController.text);
    String? professionError =
        validateProffesion(_professionController.text);

    if (usernameError == null &&
        schoolError == null &&
        professionError == null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Panggil fungsi register
        final response = await AuthService().profileCompleted(
          _usernameController.text,
          _schoolController.text,
         _professionController.text,
         _selectedLevel.toString(),
        );

        // Debug log untuk memastikan respons
        print('Register Response: $response');

        // Verifikasi status respon API
        if (response['status'] == true) {
          // Periksa status true
          // Tampilkan success snackbar
          showSuccessSnackBar(response['message'] ?? 'Pendaftaran berhasil!');
          // Navigasi ke layar OTP
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ReedemInvitationPage(),
            ),
          );
        } else if (response['status'] == false) {
          // Jika status adalah false, periksa apakah ada error pada email
          if (response['data'] != null && response['data']['email'] != null) {
            // Jika email sudah digunakan
            if (response['data']['email'].contains('validation.unique')) {
              showErrorSnackBar('Email sudah digunakan');
            } else {
              // Menampilkan error message lain jika ada
              showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
            }
          } else {
            showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
          }
        } else {
          // Default error handling jika status tidak dikenali
          showErrorSnackBar(response['message'] ?? 'Terjadi kesalahan');
        }
      } catch (error) {
        // Tampilkan pesan error jika terjadi exception
        final errorMessage = error is String ? error : 'Terjadi kesalahan.';
        showErrorSnackBar(errorMessage);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Tampilkan validasi error jika ada
      if (usernameError != null) showErrorSnackBar(usernameError);
      if (schoolError != null) showErrorSnackBar(schoolError);
      if (professionError != null) showErrorSnackBar(professionError);
    }
  }


  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : handleLoginButtonPressed, // Tambahkan kondisi _isLoading
      child: _isLoading
          ? CircularProgressIndicator(
              strokeWidth: 2, // Ketebalan garis lingkaran
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.blue), // Warna indikator
              backgroundColor: Colors
                  .grey, // Warna latar belakang indikator// Ubah ukuran sesuai kebutuhan Anda
            ) // Tampilkan CircularProgressIndicator jika _isLoading true
          : const Text('Konfirmasi'), // Tampilkan teks Login jika _isLoading false
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF144cd3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        textStyle: const TextStyle(
          fontFamily: 'poppins',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTitle(),
                    const SizedBox(height: 30),
                    buildFullNameTextField(),
                    const SizedBox(height: 15),
                    buildSchoolTextField(),
                    const SizedBox(height: 15),
                    buildDropdownSelect(),
                    const SizedBox(height: 15),
                    buildProffesionTextField(),
                    const SizedBox(height: 15),
                    buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
