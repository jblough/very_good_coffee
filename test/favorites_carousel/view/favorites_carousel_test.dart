import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesCarouselCubit = MockFavoritesCarouselCubit();

  setUp(() {
    reset(favoritesCarouselCubit);

    // Default values
    when(() => favoritesCarouselCubit.state)
        .thenReturn(const FavoritesCarouselState());
    when(() => favoritesCarouselCubit.stream)
        .thenAnswer((_) => Stream.value(const FavoritesCarouselState()));
    when(favoritesCarouselCubit.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        const FavoritesCarousel(),
        favoritesCarouselCubit: favoritesCarouselCubit,
      );

  group('FavoritesCarousel tests', () {
    testWidgets('should load', (tester) async {
      final images = ['a.png', 'b.png'];
      final state = FavoritesCarouselState(favorites: images);
      when(() => favoritesCarouselCubit.state).thenReturn(state);
      when(() => favoritesCarouselCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(CarouselView), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('should load image on tap', (tester) async {
      final images = ['a.png', 'b.png'];
      final state = FavoritesCarouselState(favorites: images);
      when(() => favoritesCarouselCubit.state).thenReturn(state);
      when(() => favoritesCarouselCubit.stream)
          .thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.tap(find.byType(Image).last, warnIfMissed: false);
      await tester.pumpAndSettle();
      verify(() => favoritesCarouselCubit.setCurrentImage(images.last));
    });
  });
}
