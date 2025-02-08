import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorites_button/bloc/favorites_button_state.dart';
import 'package:very_good_coffee/favorites_button/favorites_button.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';

import '../../helpers/helpers.dart';

void main() {
  final repository = MockCoffeeRepository();
  final coffeeCubit = MockCoffeeCubit();
  final favoritesButtonCubit = MockFavoritesButtonCubit();
  final favoritesCarouselButtonCubit = MockFavoritesCarouselButtonCubit();
  final favoritesCarouselCubit = MockFavoritesCarouselCubit();

  setUp(() {
    reset(repository);
    reset(coffeeCubit);
    reset(favoritesButtonCubit);
    reset(favoritesCarouselButtonCubit);
    reset(favoritesCarouselCubit);

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

    when(() => favoritesButtonCubit.state)
        .thenReturn(const FavoritesButtonState());
    when(() => favoritesButtonCubit.stream)
        .thenAnswer((_) => Stream.value(const FavoritesButtonState()));
    when(() => favoritesButtonCubit.isFavorite(any())).thenReturn(false);
    when(favoritesButtonCubit.close).thenAnswer((_) async {});

    when(() => favoritesCarouselCubit.state)
        .thenReturn(const FavoritesCarouselState());
    when(() => favoritesCarouselCubit.stream)
        .thenAnswer((_) => Stream.value(const FavoritesCarouselState()));
    when(favoritesCarouselCubit.close).thenAnswer((_) async {});

    when(() => favoritesCarouselButtonCubit.state)
        .thenReturn(const FavoritesCarouselButtonState());
    when(() => favoritesCarouselButtonCubit.stream).thenAnswer(
      (_) => Stream.value(const FavoritesCarouselButtonState()),
    );
    when(favoritesCarouselButtonCubit.close).thenAnswer((_) async {});
  });

  group('CoffeePage', () {
    testWidgets('should show busy indicator when no image', (tester) async {
      const state = CoffeeState();
      when(() => coffeeCubit.state).thenReturn(state);
      when(() => coffeeCubit.stream).thenAnswer((_) => Stream.value(state));

      final widget = addProviders(
        const CoffeePage(),
        coffeeRepository: repository,
        coffeeCubit: coffeeCubit,
        favoritesButtonCubit: favoritesButtonCubit,
        favoritesCarouselButtonCubit: favoritesCarouselButtonCubit,
        favoritesCarouselCubit: favoritesCarouselCubit,
      );
      await tester.pumpApp(widget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(FavoriteButton), findsNothing);
    });

    testWidgets('should load image', (tester) async {
      final widget = addProviders(
        const CoffeePage(),
        coffeeRepository: repository,
        coffeeCubit: coffeeCubit,
        favoritesButtonCubit: favoritesButtonCubit,
        favoritesCarouselButtonCubit: favoritesCarouselButtonCubit,
        favoritesCarouselCubit: favoritesCarouselCubit,
      );
      await tester.pumpApp(widget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(SourceAwareImage), findsOneWidget);
      expect(find.byType(FavoriteButton), findsOneWidget);
    });
  });
}
