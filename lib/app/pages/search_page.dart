import 'package:flutter/material.dart';
import '../components/item_card.dart';
import '../components/my_button.dart';
import 'club_detail_page.dart';
import 'clubs_page.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<ComputerClub>> _clubsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _clubsFuture = ApiService.getClubs();
  }

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

  Widget itemSection(String title, List<ComputerClub> clubs) {
    final filteredClubs = clubs
        .where((club) =>
    club.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        club.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: filteredClubs.map((club) {
            return ItemCard(
              name: club.name,
              description: club.address,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubDetailPage(clubId: club.id),
                  ),
                );
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
          SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search',
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFE2F163)),
            textStyle: const MaterialStatePropertyAll(
              TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
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
          FutureBuilder<List<ComputerClub>>(
            future: _clubsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              }
              final clubs = snapshot.data ?? [];
              return itemSection("Clubs", clubs);
            },
          ),
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