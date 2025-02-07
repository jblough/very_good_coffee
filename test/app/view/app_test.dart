import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  final repository = MockCoffeeRepository();

  setUp(() {
    reset(repository);
  });

  group('App', () {
    testWidgets('renders CoffeePage', (tester) async {
      when(repository.refreshImage).thenAnswer((_) async {});
      when(repository.loadFavorites).thenAnswer((_) async {});
      when(() => repository.coffeeImage)
          .thenAnswer((_) => const Stream<CoffeeApiResponse>.empty());

      await tester.pumpWidget(App(coffeeRepository: repository));
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
