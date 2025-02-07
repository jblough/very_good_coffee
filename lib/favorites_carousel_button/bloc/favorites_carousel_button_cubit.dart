import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';

class FavoritesCarouselButtonCubit extends Cubit<FavoritesCarouselButtonState> {
  FavoritesCarouselButtonCubit(this.coffeeRepository)
      : super(const FavoritesCarouselButtonState()) {
    coffeeRepository.favorites.listen((favorites) {
      emit(FavoritesCarouselButtonState(favorites: favorites));
    });
  }

  final CoffeeRepository coffeeRepository;
}
