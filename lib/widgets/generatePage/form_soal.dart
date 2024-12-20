import 'package:brainys/screens/responsePage/response_modulAjar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/api.dart';
import '../../screens/responsePage/response_soal.dart';

class FormSection extends StatefulWidget {
  const FormSection({Key? key}) : super(key: key);

  @override
  _FormSectionState createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final String apiUrl = 'https://testing.brainys.oasys.id/api';

  final _nameController = TextEditingController();
  final _jumlahController = TextEditingController();

  bool _isLoading = false;

  List<String> fases = [];
  String? selectedFase;

  List<String> mataPelajaran = [];
  String? selectedMataPelajaran;

  List<String> elements = [];
  String? selectedElement;

  String? _selectedType;
  final List<Map<String, String>> _types = [
    {'label': 'Essay', 'value': 'essay'},
    {'label': 'Pilihan Ganda', 'value': 'multiple_choice'},
  ];

  String capaianPembelajaran = '';
  String capaianPembelajaranRedaksi = '';

  final _formKey = GlobalKey<FormState>();
  final _moduleNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFase();
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

  Future<void> fetchFase() async {
    try {
      final response =
          await http.post(Uri.parse('$apiUrl/capaian-pembelajaran/fase'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            fases = List<String>.from(data['data'].map((item) => item['fase']));
          });
        }
      } else {
        // Handle API errors
        print('Error fetching fases: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching fases: $e');
    }
  }

  Future<void> fetchMataPelajaran(String fase) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/capaian-pembelajaran/mata-pelajaran'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fase': fase}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            mataPelajaran = List<String>.from(
                data['data'].map((item) => item['mata_pelajaran']));
          });
        }
      } else {
        // Handle API errors
        print('Error fetching mataPelajaran: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching mataPelajaran: $e');
    }
  }

  Future<void> fetchElements(String fase, String mataPelajaran) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/capaian-pembelajaran/element'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fase': fase, 'mata_pelajaran': mataPelajaran}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            elements =
                List<String>.from(data['data'].map((item) => item['element']));
          });
        }
      } else {
        // Handle API errors
        print('Error fetching elements: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching elements: $e');
    }
  }

  Future<void> fetchCapaian(
      String fase, String mataPelajaran, String element) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/capaian-pembelajaran/final'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fase': fase,
          'mata_pelajaran': mataPelajaran,
          'element': element
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              capaianPembelajaran =
                  data['data']?['capaian_pembelajaran'] ?? 'No data available';
              capaianPembelajaranRedaksi = data['data']
                      ?['capaian_pembelajaran_redaksi'] ??
                  'No data available';
            });
          }
        }
      } else {
        // Handle API errors
        print('Error fetching capaian: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error fetching capaian: $e');
    }
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
            'Templat Latihan Soal',
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
            'Gunakan Template Soal Kurikulum Merdeka',
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
          'Nama Latihan Soal',
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
            labelText: 'Masukan Nama Latihan Soal',
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
          value: _selectedType,
          decoration: InputDecoration(
            labelText: 'Pilih Jenis Soal',
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
          items: _types.map((level) {
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
              _selectedType = newValue;
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

  Widget buildJumlahSoal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jumlah Soal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _jumlahController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Masukkan Nama Latihan Soal',
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Jumlah soal tidak boleh kosong';
            }
            final jumlah = int.tryParse(value);
            if (jumlah == null || jumlah > 15) {
              return 'Jumlah soal harus kurang dari atau sama dengan 15';
            }
            return null;
          },
          onChanged: (value) {
            final jumlah = int.tryParse(value);
            if (jumlah != null && jumlah > 15) {
              // Reset to max value and show error message if needed
              _jumlahController.text = '15';
              _jumlahController.selection = TextSelection.fromPosition(
                TextPosition(offset: _jumlahController.text.length),
              );
            }
          },
        ),
        Text(
          'Maksimal 15 Soal',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget buildDropdownFase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fase Kelas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Pilih Fase Kelas'),
          value: selectedFase,
          items: fases
              .map((fase) => DropdownMenuItem(value: fase, child: Text(fase)))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedFase = value;
              selectedMataPelajaran = null;
              selectedElement = null;
              mataPelajaran = [];
              elements = [];
            });
            fetchMataPelajaran(value!);
          },
        ),
      ],
    );
  }

  Widget buildDropdownMataPelajaran() {
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
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Pilih Mata Pelajaran'),
          value: selectedMataPelajaran,
          isExpanded: true, // Memastikan teks dropdown tidak overflow
          items: mataPelajaran.map((mataPelajaran) {
            return DropdownMenuItem(
              value: mataPelajaran,
              child: Text(
                mataPelajaran,
                overflow: TextOverflow
                    .ellipsis, // Menambahkan elipsis jika teks terlalu panjang
                maxLines: 1, // Batas maksimal baris teks
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedMataPelajaran = value;
              selectedElement = null;
              elements = [];
            });
            fetchElements(selectedFase!, value!);
          },
        ),
      ],
    );
  }

  Widget buildDropdownElement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Elemen Capaian',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Pilih Elemen Capaian'),
          value: selectedElement,
          isExpanded: true,
          items: elements.map((element) {
            return DropdownMenuItem(
              value: element,
              child: Text(
                element,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
          onChanged: selectedFase != null && selectedMataPelajaran != null
              ? (value) {
                  setState(() {
                    selectedElement = value;
                  });
                }
              : null, // Disable if fase or mataPelajaran is null
        ),
      ],
    );
  }

  Widget buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kisi-kisi/Deksripsi',
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
          decoration: _inputDecoration('Masukan kisi-kisi atau deskripsi soal'),
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
      if (selectedFase == null ||
          selectedMataPelajaran == null ||
          selectedElement == null ||
          _descriptionController.text.isEmpty ||
          _selectedType == null ||
          _jumlahController.text.isEmpty) {
        showErrorSnackBar('Semua kolom harus diisi.');
        return;
      }

      setState(() {
        _isLoading =
            true; // Show loading indicator while the API request is being processed
      });

      try {
        final response = await AuthService().generateSoal(
          _nameController.text,
          selectedFase!,
          selectedMataPelajaran!,
          selectedElement!,
          _jumlahController.text,
          _descriptionController.text,
          _selectedType!,
        );

        if (response['status'] == true) {
          print('$response');
          showSuccessSnackBar(response['message']);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResponseSoal(responseData: response),
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
                  buildDropdownFase(),
                  const SizedBox(height: 16),
                  buildDropdownMataPelajaran(),
                  const SizedBox(height: 16),
                  buildDropdownElement(),
                  const SizedBox(height: 16),
                  buildJumlahSoal(),
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
