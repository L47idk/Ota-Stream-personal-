// lib/presentation/widgets/custom_search_bar.dart

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  const CustomSearchBar({
    Key? key,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // A dark grey/surface color
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Search for anime or manga...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none, // Removes the default underline
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted, // Triggers when the user presses Enter/Search on keyboard
      ),
    );
  }
}