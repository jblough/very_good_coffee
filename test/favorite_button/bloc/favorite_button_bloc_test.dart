import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_bloc.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_event.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';

import '../../app/view/app_test.dart';

void main() {
  final repository = MockCoffeeRepository();

  group('FavoriteButtonBloc tests', () {
    blocTest<FavoriteButtonBloc, FavoriteButtonState>(
      'should add favorite',
      build: () => FavoriteButtonBloc(repository),
      act: (bloc) => bloc.add(const AddFavorite('a.png')),
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
        verify(repository.loadFavorites).called(1);
      },
    );

    blocTest<FavoriteButtonBloc, FavoriteButtonState>(
      'should remove favorite',
      build: () => FavoriteButtonBloc(repository),
      act: (bloc) => bloc.add(const RemoveFavorite('a.png')),
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
        verify(repository.loadFavorites).called(1);
      },
    );
  });
}
