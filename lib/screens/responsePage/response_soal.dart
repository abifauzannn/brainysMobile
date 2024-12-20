import 'package:flutter/material.dart';

class ResponseSoal extends StatelessWidget {
  final Map<String, dynamic> responseData;

  ResponseSoal({required this.responseData});

  @override
  Widget build(BuildContext context) {
    final informasiUmum = responseData['data']['informasi_umum'];
    final soalEssay = responseData['data']['soal_essay'] ?? [];
    final soalPilihanGanda = responseData['data']['soal_pilihan_ganda'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.all(12),
                    splashRadius: 24,
                  ),
                ),
                SizedBox(height: 16),

                // Informasi Umum Section
                _buildCardSection(
                  'Informasi Umum',
                  [
                    _buildInfoRow('Nama Latihan', informasiUmum['nama_latihan']),
                    _buildInfoRow('Topik', informasiUmum['topik']),
                    _buildInfoRow('Penyusun', informasiUmum['penyusun']),
                    _buildInfoRow('Instansi', informasiUmum['instansi']),
                    _buildInfoRow('Tahun Penyusunan', informasiUmum['tahun_penyusunan']),
                    _buildInfoRow('Jenjang Sekolah', informasiUmum['jenjang_sekolah']),
                    _buildInfoRow('Fase Kelas', informasiUmum['fase_kelas']),
                    _buildInfoRow('Mata Pelajaran', informasiUmum['mata_pelajaran']),
                    _buildInfoRow('Alokasi Waktu', informasiUmum['alokasi_waktu']),
                    _buildInfoRow('Kompetensi Awal', informasiUmum['kompetensi_awal']),
                  ],
                ),

                SizedBox(height: 20),

                // Soal Essay Section
                if (soalEssay.isNotEmpty)
                  _buildCardSection(
                    'Soal Essay',
                    soalEssay.asMap().entries.map<Widget>((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> soal = entry.value;
                      return _buildSoalEssayCard(index, soal);
                    }).toList(),
                  ),

                // Soal Pilihan Ganda Section
                if (soalPilihanGanda.isNotEmpty)
                  _buildCardSection(
                    'Soal Pilihan Ganda',
                    soalPilihanGanda.asMap().entries.map<Widget>((entry) {
                      int index = entry.key + 1;
                      Map<String, dynamic> soal = entry.value;
                      return _buildSoalPilihanGandaCard(index, soal);
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to create a section wrapped in a Card
  Widget _buildCardSection(String title, List<Widget> content) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return SizedBox.shrink(); // Skip displaying if value is null or empty
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF144cd3),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Method to display a single soal essay
  Widget _buildSoalEssayCard(int index, Map<String, dynamic> soal) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan $index:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 5),
            _buildInfoRow('Pertanyaan', soal['question']),
            _buildInfoRow('Instruksi', soal['instructions']),
            SizedBox(height: 10),
            Text(
              'Kriteria Penilaian:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            ...soal['kriteria_penilaian'].map<Widget>((kriteria) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('- $kriteria'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Method to display a single soal pilihan ganda
  Widget _buildSoalPilihanGandaCard(int index, Map<String, dynamic> soal) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan $index',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 5),
            _buildInfoRow('Pertanyaan', soal['question']),
            SizedBox(height: 10),
            Text(
              'Pilihan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            ...soal['options'].entries.map<Widget>((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${entry.key}. ${entry.value}'),
              );
            }).toList(),
            // SizedBox(height: 10),
            // _buildInfoRow('Jawaban Benar', soal['correct_option']),
          ],
        ),
      ),
    );
  }
}
