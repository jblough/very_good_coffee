import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_event.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this.coffeeRepository) : super(const CoffeeState()) {
    on<IncomingImage>(_onImage);
    on<IncomingFavorites>(_onFavorites);
    on<RefreshImage>(_onRefreshImage);
    on<ToggleCarousel>(_onToggleCarousel);

    _favoritesSubscription = coffeeRepository.favorites.listen((favorites) {
      add(IncomingFavorites(favorites));
    });
    _imageSubscription = coffeeRepository.currentImage.listen((image) {
      add(IncomingImage(image));
    });

    coffeeRepository.initialize();
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<List<String>> _favoritesSubscription;
  late final StreamSubscription<String?> _imageSubscription;

  void _onImage(IncomingImage event, Emitter<CoffeeState> emit) {
    emit(state.copyWith(imageUrl: event.image));
  }

  void _onFavorites(IncomingFavorites event, Emitter<CoffeeState> emit) {
    emit(state.copyWith(favorites: event.favorites));
  }

  void _onRefreshImage(RefreshImage event, Emitter<CoffeeState> emit) {
    coffeeRepository.refreshImage();
  }

  void _onToggleCarousel(ToggleCarousel event, Emitter<CoffeeState> emit) {
    emit(state.copyWith(showCarousel: !state.showCarousel));
  }

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    _imageSubscription.cancel();
    return super.close();
  }
}
