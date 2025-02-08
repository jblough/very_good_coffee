import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit(this.coffeeRepository) : super(const CoffeeState()) {
    coffeeRepository.currentImage.listen((image) {
      emit(CoffeeState(imageUrl: image));
    });
  }

  final CoffeeRepository coffeeRepository;

  void refreshImage() {
    coffeeRepository.refreshImage();
  }
}
