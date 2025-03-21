import 'dart:convert';

import 'package:coffee_api/src/coffee_api_response.dart';
import 'package:http/http.dart' as http;

/// Root domain of the Coffee API
const coffeeApiRoot = 'https://coffee.alexflipnote.dev';

/// Url of the Coffee API endpoint that returns the image url
const coffeeApiUrl = '$coffeeApiRoot/random.json';

class CoffeeApiClient {
  CoffeeApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Download a random image URL from the API
  Future<CoffeeApiResponse> getRandomImageUrl() async {
    try {
      final url = Uri.parse(coffeeApiUrl);
      final response = await _client.get(url);
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return switch (body['file']) {
          final String file => CoffeeApiResponse.ok(file),
          _ => CoffeeApiResponse.empty(),
        };
      }
    } catch (e) {
      return CoffeeApiResponse.error(
        CoffeeApiResponseStatus.error,
        error: e.toString(),
      );
    }
    return CoffeeApiResponse.empty();
  }
}
