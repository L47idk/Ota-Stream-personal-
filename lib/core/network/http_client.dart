import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  // A standard User-Agent is very important when scraping websites like MangaFire,
  // otherwise they might block requests coming from "Dart/X.Y"
  static const String _defaultUserAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  // We reuse the same client across requests for better performance
  final http.Client _client = http.Client();

  /// Performs a GET request
  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final requestHeaders = {
      'User-Agent': _defaultUserAgent,
      'Accept': 'text/html,application/xhtml+xml,application/json,text/plain,*/*',
      'Accept-Language': 'en-US,en;q=0.9',
    };

    // If custom headers are provided, add them (and overwrite defaults if keys match)
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: requestHeaders,
      );

      // We return the raw response so the sources/scrapers can check status codes
      // and read the HTML/JSON body
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request to $url: $e');
    }
  }

  /// Performs a POST request
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final requestHeaders = {
      'User-Agent': _defaultUserAgent,
      'Accept': 'text/html,application/xhtml+xml,application/json,text/plain,*/*',
      'Content-Type': 'application/json',
    };

    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: requestHeaders,
        // We assume JSON bodies for POST requests in this client
        body: body != null ? jsonEncode(body) : null,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to perform POST request to $url: $e');
    }
  }

  /// Clean up the client if we ever need to destroy this instance
  void dispose() {
    _client.close();
  }
}