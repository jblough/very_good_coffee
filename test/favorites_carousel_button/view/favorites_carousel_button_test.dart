import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesCarouselButtonCubit = MockFavoritesCarouselButtonCubit();

  setUp(() {
    reset(favoritesCarouselButtonCubit);

    // Default values
    when(() => favoritesCarouselButtonCubit.state)
        .thenReturn(const FavoritesCarouselButtonState());
    when(() => favoritesCarouselButtonCubit.stream).thenAnswer(
      (_) => Stream.value(const FavoritesCarouselButtonState()),
    );
    when(favoritesCarouselButtonCubit.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        const FavoritesCarouselButton(),
        favoritesCarouselButtonCubit: favoritesCarouselButtonCubit,
      );

  group('FavoritesCarouselButton tests', () {
    testWidgets('should see favorites carousel button when there are favorite',
        (tester) async {
      const state = FavoritesCarouselButtonState(favorites: ['a.png']);
      when(() => favoritesCarouselButtonCubit.state).thenReturn(state);
      when(() => favoritesCarouselButtonCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
        'should not see favorites carousel button when there are no favorites',
        (tester) async {
      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
