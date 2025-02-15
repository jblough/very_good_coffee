import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();

  setUp(() {
    reset(repository);

    // Default values
    when(repository.initialize).thenAnswer((_) async {});
    when(() => repository.favorites)
        .thenAnswer((_) => Stream<List<String>>.value([]));
    when(() => repository.currentImage)
        .thenAnswer((_) => Stream<String?>.value('image-test'));
    when(repository.loadFavorites).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        const FavoritesCarousel(),
        coffeeRepository: repository,
      );

  group('FavoritesCarousel tests', () {
    testWidgets('should load', (tester) async {
      final images = ['a.png', 'b.png'];
      when(() => repository.favorites)
          .thenAnswer((_) => Stream<List<String>>.value(images));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();
      expect(find.byType(CarouselView), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('should set current image on tap', (tester) async {
      final images = ['a.png', 'b.png'];
      when(() => repository.favorites)
          .thenAnswer((_) => Stream<List<String>>.value(images));

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Image).last, warnIfMissed: false);
      await tester.pumpAndSettle();
      verify(() => repository.setCurrentImage(images.last));
    });

    testWidgets('should load new favorites', (tester) async {
      final stream = StreamController<List<String>>();
      when(() => repository.favorites).thenAnswer((_) => stream.stream);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();
      stream.add(['a.png', 'b.png']);
      await tester.pumpAndSettle();
      expect(find.byType(CarouselView), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      stream.add(['a.png', 'b.png', 'c.png']);
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsNWidgets(3));
    });
  });
}
