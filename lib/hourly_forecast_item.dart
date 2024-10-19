import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;
  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temp,
    });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 6,
      child:  Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child:  Column(
          children: [
            Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
              color: const  Color.fromRGBO(182, 243, 255, 1),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temp,
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
