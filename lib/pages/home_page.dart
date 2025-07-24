import 'package:flutter/material.dart';
import '../widgets/custom_navigation_rail.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Kirada Olan Araçlar',
                    filters: ['Müşteri', 'Plaka', 'Vites', 'Yakıt'],
                    columns: ['Tarih', 'Plaka', 'Marka/Model', 'Müşteri'],
                    actions: ['Kiralama Uzat', 'Teslim Al', 'Görüntüle'],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Rezervasyonlu Araçlar',
                    filters: ['Müşteri', 'Plaka', 'Vites', 'Yakıt', 'Tarih Aralığı', 'Tarih'],
                    columns: ['Tarih', 'Plaka', 'Marka/Model', 'Müşteri'],
                    actions: ['Kiralama Yap', 'İptal Et', 'Düzenle'],
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    title: 'Kiralanabilir Araçlar',
                    filters: ['Plaka', 'Yakıt', 'Vites', 'Marka', 'Model'],
                    columns: ['Plaka', 'Marka/Model', 'Vites'],
                    actions: ['Kirala', 'Rezervasyon Yap'],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> filters,
    required List<String> columns,
    required List<String> actions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final filter in filters) _buildDropdown(filter),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Filtrele'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          color: Colors.grey[300],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              for (final col in columns)
                Expanded(
                  child: Text(
                    col,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              const Expanded(
                child: Text('İşlem', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        ...List.generate(3, (index) => _buildAracRow(columns.length, actions)),
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: ['Seçenek 1', 'Seçenek 2']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildAracRow(int columnCount, List<String> actions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          for (int i = 0; i < columnCount; i++)
            const Expanded(
              child: Text('2024-07-30'),
            ),
          Expanded(
            child: PopupMenuButton<String>(
              onSelected: (value) {
                // İşlem seçildiğinde yapılacaklar
              },
              itemBuilder: (context) => actions
                  .map((action) => PopupMenuItem<String>(
                value: action,
                child: Text(action),
              ))
                  .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Seçiniz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
