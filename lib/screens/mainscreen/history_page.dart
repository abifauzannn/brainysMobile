import 'package:flutter/material.dart';
import 'package:brainys/widgets/subscriptionPage/history_list.dart';

class HistoryPage extends StatelessWidget {
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
                  'History',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 10),
              // Expanded pert

             
              // Expanded kedua (bisa di-scroll horizontal)
             HistoryList(),
            ],
          ),
        ),
      ),
    );
  }
}
