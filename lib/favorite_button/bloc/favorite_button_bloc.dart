import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_event.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';

class FavoriteButtonBloc
    extends Bloc<FavoriteButtonEvent, FavoriteButtonState> {
  FavoriteButtonBloc(CoffeeRepository coffeeRepository)
      : _coffeeRepository = coffeeRepository,
        super(const FavoriteButtonState()) {
    on<IncomingImage>(_onImage);
    on<IncomingFavorites>(_onFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);

    _favoritesSubscription = coffeeRepository.favorites.listen((favorites) {
      add(IncomingFavorites(favorites));
    });
    _imageSubscription = coffeeRepository.currentImage.listen((image) {
      add(IncomingImage(image));
    });
  }

  final CoffeeRepository _coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;
  late final StreamSubscription<String?> _imageSubscription;

  void _onImage(IncomingImage event, Emitter<FavoriteButtonState> emit) {
    emit(state.copyWith(currentImage: event.image));
  }

  void _onFavorites(
    IncomingFavorites event,
    Emitter<FavoriteButtonState> emit,
  ) {
    emit(state.copyWith(favorites: event.favorites));
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<FavoriteButtonState> emit,
  ) async {
    await _coffeeRepository.addFavorite(event.url);
    await _coffeeRepository.loadFavorites();
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoriteButtonState> emit,
  ) async {
    await _coffeeRepository.removeFavorite(event.url);
    await _coffeeRepository.loadFavorites();
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    _imageSubscription.cancel();
    return super.close();
  }
}
