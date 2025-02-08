import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';

class FavoritesCarouselButtonCubit extends Cubit<FavoritesCarouselButtonState> {
  FavoritesCarouselButtonCubit(this.coffeeRepository)
      : super(const FavoritesCarouselButtonState()) {
    _favoritesSubscription = coffeeRepository.favorites.listen((favorites) {
      emit(FavoritesCarouselButtonState(favorites: favorites));
    });
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
