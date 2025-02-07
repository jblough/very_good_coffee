import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';

class FavoritesCarouselCubit extends Cubit<FavoritesCarouselState> {
  FavoritesCarouselCubit(this.coffeeRepository)
      : super(const FavoritesCarouselState()) {
    coffeeRepository.favorites.listen((favorites) {
      emit(FavoritesCarouselState(favorites: favorites));
    });
  }

  final CoffeeRepository coffeeRepository;

  void setCurrentImage(String url) {
    coffeeRepository.setCurrentImage(url);
  }
}
