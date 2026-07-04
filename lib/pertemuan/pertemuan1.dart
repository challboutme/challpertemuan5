import 'package:flutter/material.dart';

class HelloWorldPage extends StatelessWidget {
  const HelloWorldPage({super.key});

  static const Color maroon = Color(0xFF800020);
  static const Color maroonLight = Color(0xFFA0324A);
  static const Color maroonBg = Color(0xFFFBEFF1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroonBg,
      appBar: AppBar(
        title: const Text(
          "Hello World App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: maroon,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [maroonLight, maroon],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: maroon.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.waving_hand_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              Card(
                elevation: 6,
                shadowColor: maroon.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Hello World!",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: maroon,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Selamat datang di aplikasi Flutter Fikri Haichal Hidayat",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
