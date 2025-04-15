import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Text(
              'OneSpace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

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
          ],
        ),
      ),
    );
  }
}
