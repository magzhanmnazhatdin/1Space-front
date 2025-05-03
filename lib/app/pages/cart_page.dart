import 'package:flutter/material.dart';
import '../components/item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Widget sectionTitle(String title) {
    return Row(
      children: [
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
    // TODO: Integrate with backend to fetch cart items
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 30),
          itemSection("Snacks", [
            {'name': 'Chips', 'desc': 'Crunchy potato chips with sea salt'},
            {'name': 'Hotdog', 'desc': 'Grilled hotdog in a soft bun'},
            {'name': 'Cookies', 'desc': 'Chocolate chip cookie pack'},
            {'name': 'Nuggets', 'desc': 'Chicken nuggets with BBQ sauce'},
            {'name': 'Nachos', 'desc': 'Cheesy nachos with salsa'},
            {'name': 'Crackers', 'desc': 'Savory cheese crackers'},
          ]),
          itemSection("Drinks", [
            {'name': 'Cola', 'desc': 'Chilled classic cola can'},
            {'name': 'Fanta', 'desc': 'Orange flavored soda'},
            {'name': 'Pepsi', 'desc': 'Bold and refreshing taste'},
            {'name': 'Water', 'desc': 'Natural spring water'},
            {'name': 'Juice', 'desc': 'Mixed fruit juice blend'},
            {'name': 'Iced Tea', 'desc': 'Lemon flavored iced tea'},
          ]),
          itemSection("Food", [
            {'name': 'Ramen', 'desc': 'Instant noodles with beef flavor'},
            {'name': 'Pizza', 'desc': 'Cheesy pepperoni slice'},
            {'name': 'Burger', 'desc': 'Beef burger with lettuce'},
            {'name': 'Pasta', 'desc': 'Creamy Alfredo pasta'},
            {'name': 'Rice Bowl', 'desc': 'Chicken and egg on rice'},
            {'name': 'Taco', 'desc': 'Spicy chicken taco'},
          ]),
        ],
      ),
    );
  }
}