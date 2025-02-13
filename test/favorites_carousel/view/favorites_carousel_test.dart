import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

import '../../helpers/helpers.dart';

void main() {
  final favoritesCarouselBloc = MockFavoritesCarouselBloc();

  setUp(() {
    reset(favoritesCarouselBloc);

    // Default values
    when(() => favoritesCarouselBloc.state)
        .thenReturn(const FavoritesCarouselState());
    when(() => favoritesCarouselBloc.stream)
        .thenAnswer((_) => Stream.value(const FavoritesCarouselState()));
    when(favoritesCarouselBloc.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        FavoritesCarousel(bloc: favoritesCarouselBloc),
      );

  group('FavoritesCarousel tests', () {
    testWidgets('should load', (tester) async {
      final images = ['a.png', 'b.png'];
      final state = FavoritesCarouselState(favorites: images);
      when(() => favoritesCarouselBloc.state).thenReturn(state);
      when(() => favoritesCarouselBloc.stream)
          .thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(CarouselView), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('should load image on tap', (tester) async {
      final images = ['a.png', 'b.png'];
      final state = FavoritesCarouselState(favorites: images);
      when(() => favoritesCarouselBloc.state).thenReturn(state);
      when(() => favoritesCarouselBloc.stream)
          .thenAnswer((_) => Stream.value(state));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.tap(find.byType(Image).last, warnIfMissed: false);
      await tester.pumpAndSettle();
      verify(() => favoritesCarouselBloc.add(SetCurrentImage(images.last)));
    });
  });
}
