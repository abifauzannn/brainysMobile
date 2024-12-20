import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List<dynamic> histories = [];

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    // Membaca file JSON dari assets
    String data = await rootBundle.loadString('assets/json/history.json');
    setState(() {
      histories = jsonDecode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(scrollbars: false),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: histories.map((history) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85, // 85% dari lebar layar
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history['created_at_format'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start, // Menjaga gambar di kiri
                        children: [
                          // Menampilkan gambar terlebih dahulu
                          Container(
                            width: 60,
                            height: 60,
                            child: history['type'] == 'exercise'
                                ? Image.asset(
                                    'assets/images/soal.png',
                                    fit: BoxFit.contain, // Menjaga proporsi gambar
                                  )
                                : Image.asset(
                                    'assets/images/bahanajar.png',
                                    fit: BoxFit.contain, // Menjaga proporsi gambar
                                  ),
                          ),
                          SizedBox(width: 30), // Space between image and text
                          // Kolom untuk teks
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  history['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  history['type'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${history['description']}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30), // Menambahkan jarak sebelum tombol
                      Align(
                        alignment: Alignment.bottomRight, // Posisi tombol di kanan bawah
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0C3B98), // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Border radius
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          ),
                          onPressed: () {
                            // Tambahkan aksi ketika tombol ditekan
                            print('Lihat Detail: ${history['name']}');
                            // Misalnya, bisa navigasi ke halaman detail
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage()));
                          },
                          child: Text(
                            'Lihat Detail',
                            style: TextStyle(
                              color: Colors.white, // Warna teks tombol
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
