import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PackageList extends StatefulWidget {
  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  List<dynamic> monthlyCredits = [];
  List<dynamic> annuallyCredits = [];

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    // Membaca file JSON dari assets
    String data = await rootBundle.loadString('assets/json/pakets.json');
    var jsonData = jsonDecode(data);

    setState(() {
      monthlyCredits = jsonData['data']['monthly']; // Data bulanan
      annuallyCredits = jsonData['data']['annually']; // Data tahunan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: DefaultTabController(
        length: 2, // Jumlah tab
        child: Column(
          children: [
            // TabBar
            TabBar(
              indicatorColor: Colors.blue, // Warna indikator tab
              labelColor: Colors.blue, // Warna teks aktif
              unselectedLabelColor: Colors.grey, // Warna teks tidak aktif
              tabs: [
                Tab(text: 'Tahunan'), // Tab untuk tahunan
                Tab(text: 'Bulanan'), // Tab untuk bulanan
              ],
            ),
            SizedBox(height: 5),
            // TabBarView
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Konten untuk tab Tahunan
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: annuallyCredits.map((credit) {
                        return Container(
                          width: 250,
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color:
                                Color(0xFF0C3B98), // Warna untuk paket tahunan
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  credit['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  credit['description'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(), // Spacer ini akan mendorong harga ke bawah
                                Text(
                                  'Rp ${credit['price']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Konten untuk tab Bulanan
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: monthlyCredits.map((credit) {
                        return Container(
                          width: 250,
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: credit['name'] == 'Paket Free'
                                ? Colors.red // Warna merah untuk 'Paket Free'
                                : Colors.amber, // Warna untuk paket bulanan
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  credit['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  credit['description'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                Spacer(), // Spacer ini akan mendorong harga ke bawah
                                Text(
                                  'Rp ${credit['price']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
