import 'package:flutter/material.dart';
import 'package:football_shop_mobile/menu.dart';
import 'package:football_shop_mobile/screens/productentry_form.dart';
import 'package:football_shop_mobile/screens/my_products.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_soccer,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'Football Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your Ultimate Football Store',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Menu Halaman Utama
          ListTile(
            leading: const Icon(Icons.home, color: Colors.green),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            },
          ),

          // Menu My Products
          ListTile(
            leading: const Icon(Icons.inventory, color: Colors.green),
            title: const Text('My Products'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyProductsPage(),
                ),
              );
            },
          ),

          // Menu Tambah Produk
          ListTile(
            leading: const Icon(Icons.add_box, color: Colors.green),
            title: const Text('Tambah Produk'),
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
    );
  }
}