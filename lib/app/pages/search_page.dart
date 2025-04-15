// search_page.dart

import 'package:flutter/material.dart';
import '../components/item_card.dart';
import '../components/my_button.dart';
import 'clubs_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void mapPageOpen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );
  }

  void favoritesPageOpen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClubsPage()),
    );
  }

  Widget sectionTitle(String title) {
    return Row(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.yellowAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: items.map((item) {
            return ItemCard(
              name: item['name']!,
              description: item['desc']!,
              onTap: () {
                print("Tapped on ${item['name']}");
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = [
      {"name": "VR Room", "desc": "Immersive VR experience"},
      {"name": "Cozy Booth", "desc": "Private and comfy"},
      {"name": "Streaming Setup", "desc": "Perfect for live content"},
    ];

    final pcSpecs = [
      {"name": "RTX 4080", "desc": "Top-tier GPU"},
      {"name": "144Hz Monitor", "desc": "Smooth visuals"},
      {"name": "Mechanical Keyboard", "desc": "Tactile & fast"},
    ];

    final perks = [
      {"name": "Free Snacks", "desc": "All you can eat"},
      {"name": "VIP Access", "desc": "Skip the line"},
      {"name": "Discounts", "desc": "Save on long sessions"},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'OneSpace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SearchBar(
            leading: Icon(Icons.search),
            hintText: 'Search',
            backgroundColor: WidgetStatePropertyAll(Color(0xFFE2F163)),
            textStyle: MaterialStatePropertyAll(
              TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MyButton(
            onTap: mapPageOpen,
            text: 'Map',
            icon: Icons.map,
          ),
          const SizedBox(height: 10),
          MyButton(
            onTap: favoritesPageOpen,
            text: 'Favorites',
            icon: Icons.star,
          ),
          const SizedBox(height: 30),
          itemSection("Rooms", rooms),
          itemSection("PC Characteristics", pcSpecs),
          itemSection("Additional Perks", perks),
        ],
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Map Page')),
    );
  }
}