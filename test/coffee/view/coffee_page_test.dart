import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();
  final coffeeCubit = MockCoffeeCubit();

  setUp(() {
    reset(repository);
    reset(coffeeCubit);

    // Default values
    when(repository.refreshImage).thenAnswer((_) async {});
    when(repository.loadFavorites).thenAnswer((_) async {});

    when(() => repository.favorites)
        .thenAnswer((_) => Stream<List<String>>.value([]));
    when(() => repository.currentImage)
        .thenAnswer((_) => const Stream<String?>.empty());

    const state = CoffeeState(imageUrl: 'image-test');
    when(() => coffeeCubit.state).thenReturn(state);
    when(() => coffeeCubit.stream).thenAnswer((_) => Stream.value(state));
    when(coffeeCubit.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        const CoffeePage(),
        coffeeRepository: repository,
        coffeeCubit: coffeeCubit,
      );

  group('CoffeePage', () {
    testWidgets('should show busy indicator when no image', (tester) async {
      const state = CoffeeState();
      when(() => coffeeCubit.state).thenReturn(state);
      when(() => coffeeCubit.stream).thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(FavoriteButton), findsNothing);
    });

    testWidgets('should load image', (tester) async {
      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SourceAwareImage), findsOneWidget);
      expect(find.byType(FavoriteButton), findsOneWidget);
    });

    testWidgets('should refresh image on button press', (tester) async {
      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.tap(find.byTooltip('Download a different image'));
      await tester.pumpAndSettle();

      verify(coffeeCubit.refreshImage);
    });
  });
}
