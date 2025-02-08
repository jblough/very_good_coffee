import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';

import '../../app/view/app_test.dart';

void main() {
  final repository = MockCoffeeRepository();

  group('FavoritesCarouselCubit tests', () {
    blocTest<FavoritesCarouselCubit, FavoritesCarouselState>(
      'should set current image',
      build: () => FavoritesCarouselCubit(repository),
      act: (cubit) => cubit.setCurrentImage('a.png'),
      setUp: () {
        when(() => repository.favorites).thenAnswer((_) => Stream.value([]));
      },
      expect: () => [const FavoritesCarouselState()],
      verify: (_) {
        verify(() => repository.setCurrentImage('a.png')).called(1);
      },
    );
  });
}
