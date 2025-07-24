// lib/widgets/custom_navigation_rail.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationRail({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Anasayfa'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.directions_car),
          label: Text('Araçlar'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text('Müşteriler'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.description),
          label: Text('Sözleşmeler'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          label: Text('Raporlar'),
        ),
      ],
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Divider(),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Column(
                children: const [
                  Icon(Icons.logout),
                  SizedBox(height: 4),
                  Text('Çıkış', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
