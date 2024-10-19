import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  final String selectedCity;
  final List<String> cityList;
  final ValueChanged<String?> onCityChanged;

  const CityDropdown({
    Key? key,
    required this.selectedCity,
    required this.cityList,
    required this.onCityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: selectedCity,
        icon: const Icon(Icons.location_city_rounded, color: Color.fromRGBO(182, 243, 255, 1),),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.blueAccent),
        underline: Container(
          height: 2,
          color: Color.fromRGBO(182, 243, 255, 1),
        ),
        onChanged: onCityChanged,
        items: cityList.map<DropdownMenuItem<String>>((String city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(
              city,
              style: const TextStyle(
                color: Color.fromRGBO(182, 243, 255, 1),
                fontSize: 18,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
