import 'package:flutter/material.dart';
import '../widgets/custom_navigation_rail.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RaporlarPage extends StatefulWidget {
  const RaporlarPage({Key? key}) : super(key: key);

  @override
  State<RaporlarPage> createState() => _RaporlarPageState();
}

class _RaporlarPageState extends State<RaporlarPage> {
  int selectedIndex = 4; // Raporlar sekmesi

  void handleNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/araclar');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/musteriler');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/sozlesmeler');
    } else if (index == 4) {
      // Zaten raporlar sayfasındayız, hiçbir şey yapma
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("RAPORLAR", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),

                    // Özet Kutuları
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildSummaryBox("Bugüne Kadar Ciro", "₺245.000", Icons.attach_money, Colors.blue),
                        _buildSummaryBox("Bu Ayın Cirosu", "₺38.700", Icons.bar_chart, Colors.green),
                        _buildSummaryBox("Aktif Araç", "15", Icons.directions_car, Colors.orange),
                        _buildSummaryBox("Ortalama Günlük Kazanç", "₺2.580", Icons.timeline, Colors.purple),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Grafik Alanı
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(child: Text("🟦 Grafik Gösterimi (örn. Ciro Analizi)", style: TextStyle(fontSize: 16))),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(child: Text("🟩 Araç Başına Ortalama Çalışma Günü (Çubuk Grafik)", style: TextStyle(fontSize: 16))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value, IconData icon, Color color) {
    return Container(
      width: 240,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
