import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditList extends StatefulWidget {
  @override
  _CreditListState createState() => _CreditListState();
}

class _CreditListState extends State<CreditList> {
  List<dynamic> credits = [];

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    // Membaca file JSON dari assets
    String data = await rootBundle.loadString('assets/json/credits.json');
    setState(() {
      credits = jsonDecode(data);
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
          child: Center(  // Membungkus Column dengan Center
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // Memusatkan konten secara vertikal
              crossAxisAlignment: CrossAxisAlignment.center,  // Memusatkan konten secara horizontal
              children: credits.map((credit) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,  // 90% dari lebar layar
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70.0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Baris pertama (Hello text dan Icon)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Kolom untuk teks
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(credit['name'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Mendapatkan credit ${credit['credit_amount']} setiap bulannya',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            // Container untuk ikon profil
                            Text('Rp. ${credit['price']}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
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
