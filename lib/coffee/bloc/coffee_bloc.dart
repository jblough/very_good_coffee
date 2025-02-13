import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_event.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this.coffeeRepository) : super(const CoffeeState()) {
    on<IncomingImage>(_onImage);
    on<RefreshImage>(_onRefreshImage);

    _subscription = coffeeRepository.currentImage.listen((image) {
      // emit(CoffeeState(imageUrl: image));
      add(IncomingImage(image));
    });

    coffeeRepository.initialize();
  }

  final CoffeeRepository coffeeRepository;
  late final StreamSubscription<String?> _subscription;

  void _onImage(IncomingImage event, Emitter<CoffeeState> emit) {
    // emit(state.copyWith(currentImage: event.image));
    emit(CoffeeState(imageUrl: event.image));
  }

  void _onRefreshImage(RefreshImage event, Emitter<CoffeeState> emit) {
    coffeeRepository.refreshImage();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
