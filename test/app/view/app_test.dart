import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  final repository = MockCoffeeRepository();

  setUp(() {
    reset(repository);

    // Defaults
    when(repository.initialize).thenAnswer((_) async {});
    when(() => repository.favorites)
        .thenAnswer((_) => Stream<List<String>>.value(['a.png']));
    when(() => repository.currentImage)
        .thenAnswer((_) => Stream<String?>.value('http://test.com/a.png'));
  });

  group('App', () {
    testWidgets('renders CoffeePage', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(App(coffeeRepository: repository));
        await tester.pump();
        expect(find.byType(CoffeePage), findsOneWidget);
        expect(find.byType(FavoriteButton), findsOneWidget);
        expect(find.byType(FavoritesCarouselButton), findsOneWidget);
      });
    });
  });
}
