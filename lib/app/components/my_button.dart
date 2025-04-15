import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });

  final String text;
  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF646464),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
