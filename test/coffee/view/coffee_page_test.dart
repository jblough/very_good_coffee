import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();
  final coffeeBloc = MockCoffeeBloc();

  setUp(() {
    reset(repository);
    reset(coffeeBloc);

    // Default values
    when(repository.initialize).thenAnswer((_) async {});

    when(() => repository.favorites)
        .thenAnswer((_) => Stream<List<String>>.value([]));
    when(() => repository.currentImage)
        .thenAnswer((_) => const Stream<String?>.empty());

    const state = CoffeeState(imageUrl: 'image-test');
    when(() => coffeeBloc.state).thenReturn(state);
    when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
    when(coffeeBloc.close).thenAnswer((_) async {});
  });

  Widget generateWidget() => addProviders(
        CoffeePage(bloc: coffeeBloc),
      );

  group('CoffeePage', () {
    testWidgets('should show busy indicator when no image', (tester) async {
      const state = CoffeeState();
      when(() => coffeeBloc.state).thenReturn(state);
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));

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
      when(repository.refreshImage).thenAnswer((_) async {});

      final widget = generateWidget();
      await tester.pumpApp(widget);
      await tester.tap(find.byTooltip('Download a different image'));
      await tester.pumpAndSettle();

      verify(() => coffeeBloc.add(const RefreshImage()));
    });

    testWidgets('should refresh image on swipe', (tester) async {
      when(repository.refreshImage).thenAnswer((_) async {});
      when(() => repository.currentImage)
          .thenAnswer((_) => Stream<String?>.value('http://test.com/a.png'));

      await mockNetworkImages(() async {
        await tester.pumpWidget(App(coffeeRepository: repository));
        await tester.pump();

        await tester.fling(
          find.byType(SourceAwareImage),
          const Offset(500, 0),
          2000,
        );
        await tester.pump();

        verify(repository.refreshImage);
      });
    });
  });

  group('show Favorites Carousel Button tests', () {
    testWidgets('should see favorites carousel button when there are favorite',
        (tester) async {
      const state = CoffeeState(favorites: ['a.png']);
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
      when(() => coffeeBloc.state).thenAnswer((_) => state);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byTooltip('View your favorite images'), findsOneWidget);
    });

    testWidgets(
        'should not see favorites carousel button when there are no favorites',
        (tester) async {
      const state = CoffeeState();
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
      when(() => coffeeBloc.state).thenAnswer((_) => state);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byTooltip('View your favorite images'), findsNothing);
    });

    testWidgets('should open favorites carousel when button tapped',
        (tester) async {
      const state = CoffeeState(favorites: ['a.png']);
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
      when(() => coffeeBloc.state).thenAnswer((_) => state);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FavoritesCarousel), findsNothing);

      // Tap on the button to open the carousel
      await tester.tap(find.byTooltip('View your favorite images'));
      await tester.pump();
      verify(() => coffeeBloc.add(const ToggleCarousel()));
    });

    testWidgets('should close favorites carousel when button tapped',
        (tester) async {
      const state = CoffeeState(favorites: ['a.png'], showCarousel: true);
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
      when(() => coffeeBloc.state).thenAnswer((_) => state);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FavoritesCarousel), findsOneWidget);

      // Tap on the button to open the carousel
      await tester.tap(find.byTooltip('View your favorite images'));
      await tester.pump();
      verify(() => coffeeBloc.add(const ToggleCarousel()));
    });

    testWidgets('should close favorites carousel when close tapped',
        (tester) async {
      const state = CoffeeState(favorites: ['a.png'], showCarousel: true);
      when(() => coffeeBloc.stream).thenAnswer((_) => Stream.value(state));
      when(() => coffeeBloc.state).thenAnswer((_) => state);

      final widget = generateWidget();
      await tester.pumpApp(widget);
      expect(find.byType(FavoritesCarousel), findsOneWidget);

      // Tap on the button to open the carousel
      await tester.tap(find.text('Close'));
      await tester.pump();
      expect(find.byType(FavoritesCarousel), findsOneWidget);
    });
  });
}
