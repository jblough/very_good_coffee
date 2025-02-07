import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';

class CoffeeCubit extends Cubit<String?> {
  CoffeeCubit(this.coffeeRepository) : super(null) {
    coffeeRepository.currentImage.listen(emit);
  }

  final CoffeeRepository coffeeRepository;

  void refreshImage() {
    coffeeRepository.refreshImage();
  }
}
