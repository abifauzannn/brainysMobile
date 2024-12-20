import 'package:flutter/material.dart';

class ResponseBahanajar extends StatelessWidget {
  final Map<String, dynamic> responseData;

  ResponseBahanajar({required this.responseData});

  @override
  Widget build(BuildContext context) {
    final informasiUmum = responseData['data']['informasi_umum'];
    final pendahuluan = responseData['data']['pendahuluan'];
    final konten = responseData['data']['konten'];
    final studiKasus = responseData['data']['studi_kasus'];
    final quiz = responseData['data']['quiz'];
    final evaluasi = responseData['data']['evaluasi'];
    final sumberReferensi = responseData['data']['lampiran']['sumber_referensi'];

    // Concatenate references into a numbered list
    String referensiConcatenated = '';
    if (sumberReferensi != null && sumberReferensi.isNotEmpty) {
      referensiConcatenated = sumberReferensi.asMap().entries.map((entry) {
        return '${entry.key + 1}. ${entry.value}';  // Add numbering starting from 1
      }).join('\n');
    }

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

                // Informasi Umum Section
                _buildCardSection(
                  'Informasi Umum',
                  [
                    ...informasiUmum.entries.map<Widget>((entry) {
                      return _buildInfoRow(entry.key, entry.value);
                    }).toList(),
                  ],
                ),

                // Pendahuluan Section
                if (pendahuluan != null)
                  _buildCardSection(
                    'Pendahuluan',
                    [
                      ...pendahuluan.entries.map<Widget>((entry) {
                        return _buildInfoRow(entry.key, entry.value);
                      }).toList(),
                    ],
                  ),

                // Materi Section
                if (konten != null)
                  _buildCardSection(
                    'Materi',
                    [
                      ...konten.map<Widget>((content) {
                        return _buildInfoRow(content['nama_konten'], content['isi_konten']);
                      }).toList(),
                    ],
                  ),

                // Studi Kasus Section
                if (studiKasus != null)
                  _buildCardSection(
                    'Studi Kasus',
                    [
                      ...studiKasus.map<Widget>((caseItem) {
                        return _buildInfoRow(caseItem['nama_studi_kasus'], caseItem['isi_studi_kasus']);
                      }).toList(),
                    ],
                  ),

                // Quiz & Evaluasi Section
                if (quiz != null || evaluasi != null)
                  _buildCardSection(
                    'Quiz & Evaluasi',
                    [
                      if (quiz != null) _buildInfoRow('Soal Quiz', quiz['soal_quiz']),
                      if (evaluasi != null) _buildInfoRow('Evaluasi', evaluasi['isi_evaluasi']),
                    ],
                  ),

                // Referensi Section (Concatenated into a numbered list)
                if (referensiConcatenated.isNotEmpty)
                  _buildCardSection(
                    'Referensi',
                    [
                      _buildInfoRow('Referensi', referensiConcatenated),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to format title like 'tingkat_kelas' to 'Tingkat Kelas'
  String formatTitle(String title) {
    if (title.isEmpty) return title;
    return title.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Method to create a section wrapped in a Card with full width
  Widget _buildCardSection(String title, List<Widget> content) {
  return Container(
    width: double.infinity,  // Set lebar Container agar memenuhi layar
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Card(
      color: Colors.white,
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
              formatTitle(title), // Gunakan helper function untuk format judul
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            // Menggunakan Expanded jika konten lebih panjang, jika tidak cukup cukup menggunakan List<Widget>
            ...content,
          ],
        ),
      ),
    ),
  );
}


  // Method to display each Info Row
  Widget _buildInfoRow(String title, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return SizedBox.shrink();  // Skip displaying if value is null or empty
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatTitle(title), // Use the helper function here to format the title
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF144cd3),
            ),
          ),
          Text(
            value.toString(),
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
