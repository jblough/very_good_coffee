import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';

class FavoritesCarouselCubit extends Cubit<FavoritesCarouselState> {
  FavoritesCarouselCubit(this.coffeeRepository)
      : super(const FavoritesCarouselState()) {
    _favoritesSubscription = coffeeRepository.favorites.listen((favorites) {
      emit(FavoritesCarouselState(favorites: favorites));
    });
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;

  void setCurrentImage(String url) {
    coffeeRepository.setCurrentImage(url);
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
