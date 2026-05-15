// lib/core/constants/app_constants.dart

class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // --- App Details ---
  static const String appName = 'OtaStream';
  static const String appVersion = '1.0.0';

  // --- Network Configuration ---
  // How long the app should wait before giving up on a network request (in milliseconds)
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;    // 30 seconds

  // --- UI Configuration ---
  // A standard border radius value to keep rounded corners consistent across the app
  static const double borderRadius = 16.0;
  static const double cardBorderRadius = 12.0;

  // Standard spacing padding (helps keep UI margins identical everywhere)
  static const double defaultPadding = 16.0;

  // --- Local Storage Keys ---
  // These keys are used if you save data to the device (like SharedPreferences or Hive)
  static const String themeKey = 'isDarkMode';
  static const String libraryKey = 'savedLibraryItems';
  static const String searchHistoryKey = 'searchHistory';

  // --- Default Messages ---
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String noResultsMessage = 'No results found for your search.';
}