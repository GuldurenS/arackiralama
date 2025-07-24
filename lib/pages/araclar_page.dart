// BU BÖLÜMÜ DOSYAYA YAPIŞTIR

import 'package:flutter/material.dart';
import '../widgets/custom_navigation_rail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AraclarPage extends StatefulWidget {
  const AraclarPage({Key? key}) : super(key: key);

  @override
  State<AraclarPage> createState() => _AraclarPageState();
}

class _AraclarPageState extends State<AraclarPage> {

  int selectedIndex = 1;

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
  final TextEditingController _filtrePlakaController = TextEditingController();
  final TextEditingController _filtreMarkaController = TextEditingController();
  final TextEditingController _filtreModelController = TextEditingController();

  String? filtreVites;
  String? filtreYakit;

  List<Map<String, dynamic>> araclar = [
    {"plaka": "35 SER 35", "markaModel": "Tofaş/Kartal", "vites": "Otomatik", "yakit": "Benzin"},
    {"plaka": "06 ANK 06", "markaModel": "Renault/Megane", "vites": "Düz", "yakit": "Dizel"},
    {"plaka": "34 IST 34", "markaModel": "Ford/Focus", "vites": "Otomatik", "yakit": "Benzin/LPG"},
  ];

  List<Map<String, dynamic>> filteredAraclar = [];

  int? expandedIndex;
  String? activeForm;

  @override
  void initState() {
    super.initState();
    filteredAraclar = List.from(araclar);
  }

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAraclar = List.from(araclar);
      } else {
        filteredAraclar = araclar.where((arac) =>
        arac["plaka"].toLowerCase().contains(query.toLowerCase()) ||
            arac["markaModel"].toLowerCase().contains(query.toLowerCase()) ||
            arac["vites"].toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void _applyFilters() {
    setState(() {
      filteredAraclar = araclar.where((arac) {
        final plaka = _filtrePlakaController.text.toLowerCase();
        final marka = _filtreMarkaController.text.toLowerCase();
        final model = _filtreModelController.text.toLowerCase();
        return (plaka.isEmpty || arac["plaka"].toLowerCase().contains(plaka)) &&
            (marka.isEmpty || arac["markaModel"].toLowerCase().contains(marka)) &&
            (model.isEmpty || arac["markaModel"].toLowerCase().contains(model)) &&
            (filtreVites == null || arac["vites"] == filtreVites) &&
            (filtreYakit == null || arac["yakit"] == filtreYakit);
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _filtrePlakaController.clear();
      _filtreMarkaController.clear();
      _filtreModelController.clear();
      filtreVites = null;
      filtreYakit = null;
      filteredAraclar = List.from(araclar);
    });
  }

  void _showFormDialog(String formType) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$formType Formu", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (formType == 'kirala') ...[
                  _buildTextField("Müşteri Adı"),
                  _buildTextField("Tarih (Başlangıç - Bitiş)"),
                  _buildTextField("Aracın KM'si"),
                  _buildTextField("Günlük KM Sınırı"),
                  _buildTextField("Günlük Tutar"),
                  _buildTextField("Yakıt Durumu"),
                  for (int i = 1; i <= 7; i++) _buildTextField("Fotoğraf $i (link veya açıklama)"),
                  _buildTextField("Not"),
                ] else if (formType == 'rezervasyon') ...[
                  _buildTextField("Müşteri Adı"),
                  _buildTextField("Tarih (Başlangıç - Bitiş)"),
                  _buildTextField("Günlük Fiyat"),
                  _buildTextField("Not"),
                ] else if (formType == 'duzenle') ...[
                  _buildTextField("Plaka"),
                  _buildTextField("Marka"),
                  _buildTextField("Model"),
                  _buildTextField("Model Yılı"),
                  _buildTextField("Şase No"),
                  _buildTextField("Motor No"),
                  _buildTextField("Yakıt Türü"),
                  _buildTextField("Vites Türü"),
                  _buildTextField("KM"),
                ] else if (formType == 'yeniArac') ...[
                  _buildTextField("Fotoğraf (1 adet link)"),
                  _buildTextField("Plaka"),
                  _buildTextField("Marka"),
                  _buildTextField("Model"),
                  _buildTextField("Model Yılı"),
                  _buildTextField("Şase No"),
                  _buildTextField("Motor No"),
                  _buildDropdown("Yakıt", ["Dizel", "Benzin", "LPG"]),
                  _buildDropdown("Vites", ["Manuel", "Otomatik"]),
                  _buildTextField("Mevcut KM"),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
                    const SizedBox(width: 10),
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Kaydet")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildAracRow(Map<String, dynamic> arac, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(child: Text(arac["plaka"])),
              Expanded(child: Text(arac["markaModel"])),
              Expanded(child: Text(arac["vites"])),
              Expanded(
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'kaldir') {
                      setState(() {
                        araclar.remove(arac);
                        filteredAraclar = List.from(araclar);
                      });
                    } else {
                      _showFormDialog(value);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'kirala', child: Text('Kirala')),
                    const PopupMenuItem(value: 'rezervasyon', child: Text('Rezervasyon')),
                    const PopupMenuItem(value: 'duzenle', child: Text('Düzenle')),
                    const PopupMenuItem(value: 'kaldir', child: Text('Kaldır')),
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

  void _showFiltrePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filtrele"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _filtrePlakaController, decoration: const InputDecoration(labelText: 'Plaka')),
                const SizedBox(height: 8),
                TextField(controller: _filtreMarkaController, decoration: const InputDecoration(labelText: 'Marka')),
                const SizedBox(height: 8),
                TextField(controller: _filtreModelController, decoration: const InputDecoration(labelText: 'Model')),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: filtreVites,
                  onChanged: (value) => setState(() => filtreVites = value),
                  items: ['Otomatik', 'Düz'].map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  decoration: const InputDecoration(labelText: 'Vites'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: filtreYakit,
                  onChanged: (value) => setState(() => filtreYakit = value),
                  items: ['Dizel', 'Benzin', 'Benzin/LPG'].map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                  decoration: const InputDecoration(labelText: 'Yakıt'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              _clearFilters();
              Navigator.pop(context);
            }, child: const Text("Temizle")),
            ElevatedButton(onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            }, child: const Text("Filtrele")),
          ],
        );
      },
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
                  const Text("ARAÇLAR", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _showFormDialog('yeniArac'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("+ Yeni Araç Ekle"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterSearchResults,
                          decoration: const InputDecoration(
                            hintText: "Ara (plaka, müşteri, marka/model)",
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _showFiltrePopup,
                        child: const Text("Filtre"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Text("Plaka", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Marka/Model", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Vites", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("İşlem", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const Divider(thickness: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredAraclar.length,
                      itemBuilder: (context, index) {
                        return _buildAracRow(filteredAraclar[index], index);
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
