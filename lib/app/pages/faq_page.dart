// lib/pages/faq_page.dart
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleQuestion = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);
    final styleAnswer   = TextStyle(color: Colors.white70, fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: const [
          ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: Text('Как отменить бронь?', style: TextStyle(color: Colors.white)),
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              Text(
                'Чтобы отменить бронь, откройте список своих броней и нажмите кнопку «Отменить» напротив нужной записи. Услуга станет доступна другим пользователям сразу после подтверждения отмены.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Divider(color: Colors.white24),

          ExpansionTile(
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            title: Text('Как забронировать?', style: TextStyle(color: Colors.white)),
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              Text(
                'Чтобы забронировать компьютер, выберите клуб, нажмите кнопку "Забронировать", укажите дату и время, затем подтвердите заказ.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
          Divider(color: Colors.white24),
        ],
      ),
    );
  }
}
