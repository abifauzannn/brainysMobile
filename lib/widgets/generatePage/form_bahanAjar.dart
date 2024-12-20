import 'package:brainys/screens/responsePage/response_bahanAjar.dart';
import 'package:flutter/material.dart';
import '../../services/api.dart';

class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final String apiUrl = 'https://testing.brainys.oasys.id/api';

  final _nameController = TextEditingController();
  final _mapelController = TextEditingController();

  bool _isLoading = false;

  String? _selectedJenjang;
  final List<Map<String, String>> _jenjangList = [
    {'label': '1 SD', 'value': '1_sd'},
    {'label': '2 SD', 'value': '2_sd'},
    {'label': '3 SD', 'value': '3_sd'},
    {'label': '4 SD', 'value': '4_sd'},
    {'label': '5 SD', 'value': '5_sd'},
    {'label': '6 SD', 'value': '6_sd'},
    {'label': '7 SMP', 'value': '7_smp'},
    {'label': '8 SMP', 'value': '8_smp'},
    {'label': '9 SMP', 'value': '9_smp'},
    {'label': '10 SMA/SMK', 'value': '10_sma'},
    {'label': '11 SMA/SMK', 'value': '11_sma'},
    {'label': '12 SMA/SMK', 'value': '12_sma'},
  ];

  String capaianPembelajaran = '';
  String capaianPembelajaranRedaksi = '';

  final _formKey = GlobalKey<FormState>();
  final _moduleNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _moduleNameController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Nama Modul Ajar tidak boleh kosong';
    }
    return null;
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
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
    );
  }

  Widget buildTitle() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Templat Bahan Ajar',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Gunakan Template Bahan Materi Pembelajaran',
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUsernameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Bahan Ajar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          // controller: _usernameController,
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Masukan Nama Bahan Ajar',
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
        ),
      ],
    );
  }

  Widget buildUMataPelajaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mata Pelajaran',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          // controller: _usernameController,
          controller: _mapelController,
          decoration: InputDecoration(
            labelText: 'Masukan Nama Mata Pelajaran',
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
        ),
      ],
    );
  }

  Widget buildSelectType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis Soal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedJenjang,
          decoration: InputDecoration(
            labelText: 'Pilih Kelas',
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
          items: _jenjangList.map((level) {
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
              _selectedJenjang = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Type Soal tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  

  Widget buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi Bahan Ajar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLength: 250,
          maxLines: 3,
          decoration: _inputDecoration('Masukan deskripsi bahan ajar'),
          onChanged: (value) {
            setState(() {}); // Trigger UI update for character count
          },
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Logika untuk membatalkan
              // Navigator.pop(context); // Contoh aksi untuk tombol "Batalkan"
            },
            icon: const Icon(Icons.cancel, size: 20, color: Colors.white),
            label: const Text('Batalkan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF092C73), // Warna gelap
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10), // Spasi antara dua tombol
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : generateSoal,
            icon: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, // Ketebalan garis lingkaran
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white), // Warna indikator
                      backgroundColor:
                          Colors.grey, // Warna latar belakang indikator
                    ),
                  )
                : const Icon(Icons.save, size: 20, color: Colors.white),
            label: const Text('Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C3B98), // Warna utama
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        )
      ],
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

  void generateSoal() async {
    // Validate name field
    if (_formKey.currentState?.validate() ?? false) {
      // Check if all required fields are selected
      if (_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _selectedJenjang == null ||
          _mapelController.text.isEmpty) {
        showErrorSnackBar('Semua kolom harus diisi.');
        return;
      }

      setState(() {
        _isLoading =
            true; // Show loading indicator while the API request is being processed
      });

      try {
        final response = await AuthService().GenerateBahanAjar(
          _nameController.text,
          _selectedJenjang!,
          _mapelController.text,
          _descriptionController.text,
        );

        if (response['status'] == true) {
          print('$response');
          showSuccessSnackBar(response['message']);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponseBahanajar(responseData: response),
            ),
          );
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(),
                  const SizedBox(height: 30),
                  buildUsernameTextField(),
                  const SizedBox(height: 16),
                  buildSelectType(),
                  const SizedBox(height: 16),
                  buildUMataPelajaran(),
                  const SizedBox(height: 16),
                  buildDescriptionField(),
                  const SizedBox(height: 16),
                  buildActionButtons(),
                ],
              ),
            ),
          ),
        ));
  }
}
