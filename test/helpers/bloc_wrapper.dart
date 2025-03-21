import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

class MockFavoriteButtonBloc
    extends MockBloc<FavoriteButtonEvent, FavoriteButtonState>
    implements FavoriteButtonBloc {}

class MockFavoritesCarouselBloc
    extends MockBloc<FavoritesCarouselEvent, FavoritesCarouselState>
    implements FavoritesCarouselBloc {}

Widget addProviders(
  Widget child, {
  CoffeeRepository? coffeeRepository,
}) {
  final repository = coffeeRepository ?? CoffeeRepository();
  return RepositoryProvider<CoffeeRepository>.value(
    value: repository,
    child: Scaffold(body: child),
  );
}
