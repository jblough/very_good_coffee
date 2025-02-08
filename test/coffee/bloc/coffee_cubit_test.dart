import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_cubit.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

import '../../app/view/app_test.dart';

void main() {
  final repository = MockCoffeeRepository();

  group('CoffeeCubit tests', () {
    blocTest<CoffeeCubit, CoffeeState>(
      'should refresh',
      build: () => CoffeeCubit(repository),
      act: (cubit) => cubit.refreshImage(),
      setUp: () {
        when(() => repository.currentImage)
            .thenAnswer((_) => Stream.value(null));
        when(repository.refreshImage).thenAnswer((_) async {});
      },
      expect: () => [const CoffeeState()],
      verify: (_) {
        verify(repository.refreshImage).called(1);
      },
    );
  });
}
