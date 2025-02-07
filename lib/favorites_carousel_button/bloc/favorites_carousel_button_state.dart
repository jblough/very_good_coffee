import 'package:equatable/equatable.dart';

class FavoritesCarouselButtonState extends Equatable {
  const FavoritesCarouselButtonState({this.favorites = const []});

  final List<String> favorites;

  @override
  List<Object?> get props => [favorites];
}
