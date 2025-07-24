import 'package:flutter/material.dart';

class DonecekAraclarWidget extends StatefulWidget {
  const DonecekAraclarWidget({super.key});

  @override
  State<DonecekAraclarWidget> createState() => _DonecekAraclarWidgetState();
}

class _DonecekAraclarWidgetState extends State<DonecekAraclarWidget> {
  final List<Map<String, String>> araclar = [
    {
      'tarih': '2024-07-30',
      'plaka': '35 SER 35',
      'markaModel': 'Tofaş/Kartal',
      'musteri': 'Sercan Güldüren',
    },
    {
      'tarih': '2024-07-31',
      'plaka': '06 ANK 06',
      'markaModel': 'Renault/Megane',
      'musteri': 'Ali Veli',
    },
    {
      'tarih': '2024-08-01',
      'plaka': '34 IST 34',
      'markaModel': 'Ford/Focus',
      'musteri': 'Ayşe Yılmaz',
    },
  ];

  String arama = '';

  void _filtreAc() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text("Bugün dönecek olanlar"),
                onTap: () {
                  // filtre işlemi
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Tarih aralığında dönecekler"),
                onTap: () {
                  // filtre işlemi
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Belirli bir tarihte dönecek olanlar"),
                onTap: () {
                  // filtre işlemi
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Filtreyi Temizle"),
                onTap: () {
                  // filtre temizleme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _secenekleriGoster(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 160,
          padding: const EdgeInsets.all(12),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text("Teslim Al"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Kiralama Uzat"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Detayları Görüntüle"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAraclar = araclar.where((arac) {
      final search = arama.toLowerCase();
      return arac['plaka']!.toLowerCase().contains(search) ||
          arac['markaModel']!.toLowerCase().contains(search) ||
          arac['musteri']!.toLowerCase().contains(search);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kirada Olan Araçlar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: _filtreAc,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                ),
                child: const Text("Filtrele"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      arama = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Ara (plaka, müşteri, marka/model)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DataTable(
            columnSpacing: 24,
            headingRowColor:
            MaterialStateProperty.all(Colors.grey.shade300),
            columns: const [
              DataColumn(label: Text('Tarih')),
              DataColumn(label: Text('Plaka')),
              DataColumn(label: Text('Marka/Model')),
              DataColumn(label: Text('Müşteri')),
              DataColumn(label: Text('İşlem')),
            ],
            rows: filteredAraclar.map((arac) {
              return DataRow(cells: [
                DataCell(Text(arac['tarih']!)),
                DataCell(Text(arac['plaka']!)),
                DataCell(Text(arac['markaModel']!)),
                DataCell(Text(arac['musteri']!)),
                DataCell(
                  ElevatedButton(
                    onPressed: () => _secenekleriGoster(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Seçiniz"),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
