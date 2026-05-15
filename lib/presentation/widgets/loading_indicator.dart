// lib/presentation/widgets/loading_indicator.dart

import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Adjust import based on where you put app_colors.dart

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        // Use your app's primary color
        valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent), // Or AppColors.primary
      ),
    );
  }
}