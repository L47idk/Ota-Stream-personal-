import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class ScraperService {
  final List<String> _userAgents = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1'
  ];

  String get _randomUserAgent => _userAgents[DateTime.now().millisecond % _userAgents.length];

  Future<http.Response> fetch(String url, {Map<String, String>? headers}) async {
    final finalHeaders = {
      'User-Agent': _randomUserAgent,
      if (headers != null) ...headers,
    };

    return await http.get(Uri.parse(url), headers: finalHeaders);
  }

  Future<Map<String, dynamic>> fetchJson(String url, {Map<String, String>? headers}) async {
    final response = await fetch(url, headers: {
      'Accept': 'application/json',
      ...?headers,
    });
    
    if (response.statusCode != 200) {
      throw Exception('Target failed. Status: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  Future<Document> fetchHtml(String url, {Map<String, String>? headers}) async {
    final response = await fetch(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Target failed. Status: ${response.statusCode}');
    }

    return html_parser.parse(response.body);
  }
}

final scraperService = ScraperService();