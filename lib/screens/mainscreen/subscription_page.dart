import 'package:flutter/material.dart';
import 'package:brainys/widgets/subscriptionPage/package_list.dart';
import 'package:brainys/widgets/subscriptionPage/subscription_list.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 15.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft, // Penempatan teks ke kiri
                child: Text(
                  'Paket Aktif',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 5),
              // Expanded pertama
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF0C3B98),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
                                Text('Paket Free',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Mendapatkan 5 Credit setiap bulannya',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            // Container untuk ikon profil
                            Text('Rp. 100',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft, // Penempatan teks ke kiri
                child: Text(
                  'Pilihan Paket',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 5),

              // Expanded kedua (bisa di-scroll horizontal)
             PackageList(),

              SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft, // Penempatan teks ke kiri
                child: Text(
                  'Pilihan Extra Credit',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 5),

              // Expanded ketiga (bisa di-scroll horizontal)
              CreditList(),
            ],
          ),
        ),
      ),
    );
  }
}
