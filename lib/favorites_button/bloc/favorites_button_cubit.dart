import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorites_button/bloc/favorites_button_state.dart';

class FavoritesButtonCubit extends Cubit<FavoritesButtonState> {
  FavoritesButtonCubit(this.coffeeRepository)
      : super(const FavoritesButtonState()) {
    coffeeRepository.favorites.listen((favorites) {
      emit(state.copyWith(favorites: favorites));
    });
    coffeeRepository.currentImage.listen((image) {
      emit(state.copyWith(currentImage: image));
    });
  }

  final CoffeeRepository coffeeRepository;

  Future<void> addFavorite(String url) async {
    await coffeeRepository.addFavorite(url);
    await coffeeRepository.loadFavorites();
  }

  Future<void> removeFavorite(String url) async {
    await coffeeRepository.removeFavorite(url);
    await coffeeRepository.loadFavorites();
  }

  bool isFavorite(String url) => coffeeRepository.isFavorite(url);
}
