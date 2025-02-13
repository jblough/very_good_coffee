import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_event.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';

class FavoritesCarouselButtonBloc
    extends Bloc<FavoritesCarouselButtonEvent, FavoritesCarouselButtonState> {
  FavoritesCarouselButtonBloc(this.coffeeRepository)
      : super(const FavoritesCarouselButtonState()) {
    on<IncomingFavorites>(_onFavorites);

    _favoritesSubscription = coffeeRepository.favorites
        .listen((favorites) => add(IncomingFavorites(favorites)));
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;

  void _onFavorites(
    IncomingFavorites event,
    Emitter<FavoritesCarouselButtonState> emit,
  ) {
    emit(FavoritesCarouselButtonState(favorites: event.favorites));
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
