import 'package:flutter/material.dart';
import '../widgets/custom_navigation_rail.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SozlesmelerPage extends StatefulWidget {
  const SozlesmelerPage({Key? key}) : super(key: key);

  @override
  State<SozlesmelerPage> createState() => _SozlesmelerPageState();
}

class _SozlesmelerPageState extends State<SozlesmelerPage> {
  int selectedIndex = 3;

  void handleNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/araclar');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/musteriler');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/sozlesmeler');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/raporlar');
    }
  }
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filtreAdController = TextEditingController();
  final TextEditingController _filtreSoyadController = TextEditingController();
  final TextEditingController _filtreTcController = TextEditingController();
  final TextEditingController _filtreTelefonController = TextEditingController();

  List<Map<String, String>> Sozlesmeler = [
    {"ad": "Ahmet", "soyad": "Yılmaz", "telefon": "05551234567"},
    {"ad": "Mehmet", "soyad": "Demir", "telefon": "05559876543"},
    {"ad": "Ayşe", "soyad": "Kara", "telefon": "05441112233"},
  ];

  List<Map<String, String>> filteredSozlesmeler = [];

  @override
  void initState() {
    super.initState();
    filteredSozlesmeler = List.from(Sozlesmeler);
  }

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSozlesmeler = List.from(Sozlesmeler);
      } else {
        filteredSozlesmeler = Sozlesmeler.where((musteri) =>
        musteri["ad"]!.toLowerCase().contains(query.toLowerCase()) ||
            musteri["soyad"]!.toLowerCase().contains(query.toLowerCase()) ||
            musteri["telefon"]!.contains(query)).toList();
      }
    });
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildMusteriRow(Map<String, String> musteri) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(child: Text("${musteri["ad"]} ${musteri["soyad"]}")),
              Expanded(child: Text(musteri["telefon"]!)),
              Expanded(
                child: PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'duzenle', child: Text('Düzenle')),
                    const PopupMenuItem(value: 'detay', child: Text('Detay Görüntüle')),
                  ],
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade100,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Seçiniz"),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔐 Kullanıcı oturum kontrolü
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox(); // Ekran boş dönsün (gerekiyorsa başka Widget da olabilir)
    }
    return Scaffold(
      body: Row(
        children: [
          CustomNavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: handleNavigation,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SÖZLEŞMELER", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterSearchResults,
                          decoration: const InputDecoration(
                            hintText: "Ara (ad, soyad, telefon)",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Text("Plaka", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Ad Soyad", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Telefon", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("İşlem", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSozlesmeler.length,
                      itemBuilder: (context, index) {
                        return _buildMusteriRow(filteredSozlesmeler[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}