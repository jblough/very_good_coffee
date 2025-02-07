import 'package:coffee_api/coffee_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final client = MockHttpClient();

  setUp(() {
    reset(client);
  });

  test('should return image url on successful response', () async {
    final response = http.Response(_successfulResponse, 200);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final url = await api.getRandomImageUrl();

    expect(url, 'https://coffee.alexflipnote.dev/kfPtX_HEchI_coffee.jpg');
  });

  test('should return null on no image in response', () async {
    final response = http.Response(_noImageResponse, 200);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final url = await api.getRandomImageUrl();

    expect(url, isNull);
  });

  test('should return null on error response', () async {
    final response = http.Response('', 500);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final url = await api.getRandomImageUrl();

    expect(url, isNull);
  });
}

const _successfulResponse = '''
{
  "file": "https://coffee.alexflipnote.dev/kfPtX_HEchI_coffee.jpg"
}
''';

const _noImageResponse = '''
{
}
''';
