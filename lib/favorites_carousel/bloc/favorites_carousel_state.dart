import 'package:equatable/equatable.dart';

class FavoritesCarouselState extends Equatable {
  const FavoritesCarouselState({this.favorites = const []});

  final List<String> favorites;

  @override
  List<Object?> get props => [favorites];
}
