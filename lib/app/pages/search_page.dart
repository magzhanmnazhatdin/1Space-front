import 'package:flutter/material.dart';
import 'package:onespace/app/components/item_card.dart'; // Assuming ItemCard is extracted here
import 'package:onespace/app/components/my_button.dart';
import 'package:onespace/app/pages/clubs_page.dart';
import 'package:onespace/app/pages/map_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void MapPageOpen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    );
  }

  void FavoritesPageOpen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClubsPage()),
    );
  }

  Widget sectionTitle(String title) {
    return Row(
      children: [
        const SizedBox(height: 12),
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.yellowAccent,
                shape: BoxShape.circle,
              ),
            ),
          ],
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

          // Title
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

          // Search Bar
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search',
            backgroundColor: WidgetStateProperty.all(Color(0xFFE2F163)),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Map & Favorites Buttons
          MyButton(
            onTap: MapPageOpen,
            text: 'Map',
            icon: Icons.map,
          ),
          const SizedBox(height: 10),
          MyButton(
            onTap: FavoritesPageOpen,
            text: 'Favorites',
            icon: Icons.star,
          ),

          const SizedBox(height: 30),

          // Favorites Sections
          itemSection("Rooms", rooms),
          itemSection("PC Characteristics", pcSpecs),
          itemSection("Additional Perks", perks),
        ],
      ),
    );
  }
}
