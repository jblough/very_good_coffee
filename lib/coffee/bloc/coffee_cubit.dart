import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit(this.coffeeRepository) : super(const CoffeeState()) {
    _subscription = coffeeRepository.currentImage.listen((image) {
      emit(CoffeeState(imageUrl: image));
    });
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<String?> _subscription;

  void refreshImage() {
    coffeeRepository.refreshImage();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
