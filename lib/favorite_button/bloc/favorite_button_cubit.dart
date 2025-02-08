import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';

class FavoriteButtonCubit extends Cubit<FavoriteButtonState> {
  FavoriteButtonCubit(this.coffeeRepository)
      : super(const FavoriteButtonState()) {
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
