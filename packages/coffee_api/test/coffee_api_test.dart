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
    final status = await api.getRandomImageUrl();

    expect(
      status,
      CoffeeApiResponse.ok(
        'https://coffee.alexflipnote.dev/kfPtX_HEchI_coffee.jpg',
      ),
    );
    expect(status.isOk(), isTrue);
  });

  test('should return empty on no image in response', () async {
    final response = http.Response(_noImageResponse, 200);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final status = await api.getRandomImageUrl();

    expect(status, CoffeeApiResponse.empty());
    expect(status.isOk(), isFalse);
  });

  test('should return null on error response', () async {
    final response = http.Response('', 500);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final status = await api.getRandomImageUrl();

    expect(status.url, isNull);
    expect(status.status, CoffeeApiResponseStatus.error);
    expect(status.isOk(), isFalse);
  });

  test('should return empty on json list response', () async {
    final response = http.Response('[]', 200);
    when(() => client.get(Uri.parse(coffeeApiUrl)))
        .thenAnswer((_) async => response);

    final api = CoffeeApiClient(client: client);
    final status = await api.getRandomImageUrl();

    expect(status, CoffeeApiResponse.empty());
    expect(status.isOk(), isFalse);
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
