import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label, 
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(icon, color: Color.fromRGBO(182, 243, 255, 1),),
        const SizedBox(height: 8,),
        Text(label),
        const SizedBox(height: 8,),
        Text(value, style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),)
      ],
    );
  }
}