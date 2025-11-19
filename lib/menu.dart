import 'package:flutter/material.dart';
import 'package:football_shop_mobile/widgets/left_drawer.dart';
import 'package:football_shop_mobile/screens/productentry_form.dart';
import 'package:football_shop_mobile/screens/my_products.dart';
import 'package:football_shop_mobile/screens/list_productentry.dart';

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductEntryPage(),
                      ),
                    );
                  },
                ),

                // Tombol My Products
                ItemCard(
                  name: "My Products",
                  icon: Icons.shopping_bag,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyProductsPage(),
                      ),
                    );
                  },
                ),

                // Tombol Create Product
                ItemCard(
                  name: "Create Product",
                  icon: Icons.add_box,
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductEntryFormPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}