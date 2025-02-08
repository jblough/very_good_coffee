import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_cubit.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';

import '../../app/view/app_test.dart';

void main() {
  final repository = MockCoffeeRepository();

  group('FavoriteButtonCubit tests', () {
    blocTest<FavoriteButtonCubit, FavoriteButtonState>(
      'should add favorite',
      build: () => FavoriteButtonCubit(repository),
      act: (cubit) => cubit.addFavorite('a.png'),
      setUp: () {
        when(() => repository.currentImage)
            .thenAnswer((_) => Stream.value(null));
        when(() => repository.favorites).thenAnswer((_) => Stream.value([]));
        when(() => repository.addFavorite(any())).thenAnswer((_) async {});
        when(repository.loadFavorites).thenAnswer((_) async {});
      },
      expect: () => [const FavoriteButtonState()],
      verify: (_) {
        verify(() => repository.addFavorite('a.png')).called(1);
      },
    );

    blocTest<FavoriteButtonCubit, FavoriteButtonState>(
      'should remove favorite',
      build: () => FavoriteButtonCubit(repository),
      act: (cubit) => cubit.removeFavorite('a.png'),
      setUp: () {
        when(() => repository.currentImage)
            .thenAnswer((_) => Stream.value(null));
        when(() => repository.favorites).thenAnswer((_) => Stream.value([]));
        when(() => repository.removeFavorite(any())).thenAnswer((_) async {});
        when(repository.loadFavorites).thenAnswer((_) async {});
      },
      expect: () => [const FavoriteButtonState()],
      verify: (_) {
        verify(() => repository.removeFavorite('a.png')).called(1);
      },
    );
  });
}
