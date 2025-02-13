import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_event.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';

class FavoritesCarouselBloc
    extends Bloc<FavoritesCarouselEvent, FavoritesCarouselState> {
  FavoritesCarouselBloc(this.coffeeRepository)
      : super(const FavoritesCarouselState()) {
    on<IncomingFavorites>(_onFavorites);
    on<SetCurrentImage>(_onSetCurrentImage);

    _favoritesSubscription = coffeeRepository.favorites.listen((favorites) {
      add(IncomingFavorites(favorites));
    });
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;

  void _onFavorites(
    IncomingFavorites event,
    Emitter<FavoritesCarouselState> emit,
  ) {
    emit(FavoritesCarouselState(favorites: event.favorites));
  }

  void _onSetCurrentImage(
    SetCurrentImage event,
    Emitter<FavoritesCarouselState> emit,
  ) {
    coffeeRepository.setCurrentImage(event.url);
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    return super.close();
  }
}
