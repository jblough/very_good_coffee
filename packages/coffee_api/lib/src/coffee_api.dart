import 'dart:convert';

import 'package:http/http.dart' as http;

const coffeeApiUrl = 'https://coffee.alexflipnote.dev/random.json';

class CoffeeApiClient {
  CoffeeApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String?> getRandomImageUrl() async {
    // TODO(me): Look at using exceptions for better error handling
    try {
      final url = Uri.parse(coffeeApiUrl);
      final response = await _client.get(url);
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return switch (body['file']) {
          final String file => file,
          _ => null,
        };
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
