import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_event.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';

import '../../app/view/app_test.dart';

void main() {
  final repository = MockCoffeeRepository();

  group('CoffeeBloc tests', () {
    blocTest<CoffeeBloc, CoffeeState>(
      'should refresh',
      build: () => CoffeeBloc(repository),
      act: (bloc) => bloc.add(const RefreshImage()),
      setUp: () {
        when(() => repository.currentImage)
            .thenAnswer((_) => Stream.value(null));
        when(() => repository.favorites).thenAnswer((_) => Stream.value([]));
        when(repository.refreshImage).thenAnswer((_) async {});
        when(repository.initialize).thenAnswer((_) async {});
      },
      expect: () => [const CoffeeState()],
      verify: (_) {
        verify(repository.refreshImage).called(1);
      },
    );

    blocTest<CoffeeBloc, CoffeeState>(
      'should toggle',
      build: () => CoffeeBloc(repository),
      act: (bloc) => bloc.add(const ToggleCarousel()),
      seed: () => const CoffeeState(favorites: ['a.png']),
      setUp: () {
        when(() => repository.currentImage)
            .thenAnswer((_) => Stream.value(null));
        when(() => repository.favorites)
            .thenAnswer((_) => Stream.value(['a.png']));
        when(repository.initialize).thenAnswer((_) async {});
      },
      expect: () => [
        const CoffeeState(favorites: ['a.png'], showCarousel: true),
      ],
      verify: (_) {},
    );
  });
}
