import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  final String nama = "Faishal Khoiriansyah Wicaksono";
  final String npm = "2406436335";
  final String kelas = "D";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Football Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Informasi mahasiswa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: "Nama", content: nama),
                InfoCard(title: "NPM", content: npm),
                InfoCard(title: "Kelas", content: kelas),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Selamat datang di Football Shop!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Grid tombol utama
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              children: [
                // Tombol All Products
                ItemCard(
                  name: "All Products",
                  icon: Icons.list,
                  color: Colors.blue,
                  message: "Kamu telah menekan tombol All Products",
                ),

                // Tombol My Products
                ItemCard(
                  name: "My Products",
                  icon: Icons.shopping_bag,
                  color: Colors.green,
                  message: "Kamu telah menekan tombol My Products",
                ),

                // Tombol Create Product
                ItemCard(
                  name: "Create Product",
                  icon: Icons.add_box,
                  color: Colors.red,
                  message: "Kamu telah menekan tombol Create Product",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Kartu Info Mahasiswa
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.8,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}

// Widget Tombol (Card Item)
class ItemCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String message;

  const ItemCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
