import 'package:flutter/material.dart';

class ResponsePage extends StatelessWidget {
  final Map<String, dynamic> responseData;

  ResponsePage({required this.responseData});

  @override
  Widget build(BuildContext context) {
    final informasiUmum = responseData['data']['informasi_umum'];
    final saranaDanPrasarana = responseData['data']['sarana_dan_prasarana'];
    final tujuanKegiatanPembelajaran = responseData['data']['tujuan_kegiatan_pembelajaran'];
    final pemahamanBermakna = responseData['data']['pemahaman_bermakna'];
    final kompetensiDasar = responseData['data']['kompetensi_dasar'];

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
                    _buildInfoRow('Nama Modul Ajar', informasiUmum['topik']),
                    _buildInfoRow('Penyusun', informasiUmum['penyusun']),
                    _buildInfoRow('Instansi', informasiUmum['instansi']),
                    _buildInfoRow('Tahun Penyusunan', informasiUmum['tahun_penyusunan']),
                    _buildInfoRow('Jenjang Sekolah', informasiUmum['jenjang_sekolah']),
                    _buildInfoRow('Fase Kelas', informasiUmum['fase_kelas']),
                    _buildInfoRow('Mata Pelajaran', informasiUmum['mata_pelajaran']),
                    _buildInfoRow('Alokasi Waktu', informasiUmum['alokasi_waktu']),
                    _buildInfoRow('Kompetensi Awal', informasiUmum['kompetensi_awal']),
                    _buildInfoRow('Target Peserta Didik', informasiUmum['target_peserta_didik']),
                    _buildInfoRow('Model Pembelajaran', informasiUmum['model_pembelajaran']),
                  ],
                ),

                SizedBox(height: 20),

                // Sarana dan Prasarana Section
                _buildCardSection(
                  'Sarana dan Prasarana',
                  [
                    _buildInfoRow('Sumber Belajar', saranaDanPrasarana['sumber_belajar']),
                    _buildInfoRow('Lembar Kerja Peserta Didik', saranaDanPrasarana['lembar_kerja_peserta_didik']),
                  ],
                ),

                SizedBox(height: 20),

                // Tujuan Kegiatan Pembelajaran Section
                _buildCardSection(
                  'Tujuan Kegiatan Pembelajaran',
                  [
                    _buildInfoRow('Tujuan Pembelajaran Bab', tujuanKegiatanPembelajaran['tujuan_pembelajaran_bab']),
                    ...tujuanKegiatanPembelajaran['tujuan_pembelajaran_topik'].map<Widget>((e) {
                      return _buildInfoRow('Tujuan Pembelajaran Topik', e);
                    }).toList(),
                  ],
                ),

                SizedBox(height: 20),

                // Pemahaman Bermakna Section
                _buildCardSection(
                  'Pemahaman Bermakna',
                  [
                    _buildInfoRow('Topik', pemahamanBermakna['topik']),
                  ],
                ),

                SizedBox(height: 20),

                // Pertanyaan Pemantik Section
                _buildCardSection(
                  'Pertanyaan Pemantik',
                  [
                    ...responseData['data']['pertanyaan_pemantik'].map<Widget>((e) {
                      return _buildInfoRow('Pertanyaan', e);
                    }).toList(),
                  ],
                ),

                SizedBox(height: 20),

                // Kompetensi Dasar Section with Dividers between Materi
                ...kompetensiDasar.map<Widget>((kompetensi) {
                  return _buildKompetensiCard(kompetensi);
                }).toList(),
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
              '$title',
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
      return SizedBox.shrink();  // Skip displaying if value is null or empty
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
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

  // Method to display each Kompetensi Dasar in a separate Card
  Widget _buildKompetensiCard(Map<String, dynamic> kompetensi) {
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
            // Kompetensi Dasar Title
            Text(
              kompetensi['nama_kompetensi_dasar'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),

            // Displaying Materi Pembelajaran with Dividers in between
            ...kompetensi['materi_pembelajaran'].map<Widget>((materi) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Materi', materi['materi']),
                  _buildInfoRow('Indikator', materi['indikator']),
                  _buildInfoRow('Nilai Karakter', materi['nilai_karakter']),
                  _buildInfoRow('Kegiatan Pembelajaran', materi['kegiatan_pembelajaran']),
                  _buildInfoRow('Alokasi Waktu', materi['alokasi_waktu']),
                  // Display Penilaian if available
                  if (materi['penilaian'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Penilaian:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...materi['penilaian'].map<Widget>((penilaian) {
                          return _buildInfoRow('Jenis: ${penilaian['jenis']}', 'Bobot: ${penilaian['bobot']}');
                        }).toList(),
                      ],
                    ),
                  Divider(),  // Add Divider between each Materi Pembelajaran
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
