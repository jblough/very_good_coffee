import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeCubit extends MockCubit<CoffeeState> implements CoffeeCubit {}

class MockFavoriteButtonCubit extends MockCubit<FavoriteButtonState>
    implements FavoriteButtonCubit {}

class MockFavoritesCarouselButtonCubit
    extends MockCubit<FavoritesCarouselButtonState>
    implements FavoritesCarouselButtonCubit {}

class MockFavoritesCarouselCubit extends MockCubit<FavoritesCarouselState>
    implements FavoritesCarouselCubit {}

Widget addProviders(
  Widget child, {
  CoffeeRepository? coffeeRepository,
  CoffeeCubit? coffeeCubit,
  FavoriteButtonCubit? favoriteButtonCubit,
  FavoritesCarouselCubit? favoritesCarouselCubit,
  FavoritesCarouselButtonCubit? favoritesCarouselButtonCubit,
}) {
  final repository = coffeeRepository ?? CoffeeRepository();
  return RepositoryProvider<CoffeeRepository>.value(
    value: repository,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CoffeeCubit>(
          create: (_) => coffeeCubit ?? CoffeeCubit(repository),
          lazy: false,
        ),
        BlocProvider<FavoriteButtonCubit>(
          create: (_) => favoriteButtonCubit ?? FavoriteButtonCubit(repository),
          lazy: false,
        ),
        BlocProvider<FavoritesCarouselCubit>(
          create: (_) =>
              favoritesCarouselCubit ?? FavoritesCarouselCubit(repository),
          lazy: false,
        ),
        BlocProvider<FavoritesCarouselButtonCubit>(
          create: (_) =>
              favoritesCarouselButtonCubit ??
              FavoritesCarouselButtonCubit(repository),
          lazy: false,
        ),
      ],
      child: Scaffold(body: child),
    ),
  );
}
