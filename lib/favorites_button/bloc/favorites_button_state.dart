import 'package:equatable/equatable.dart';

class FavoritesButtonState extends Equatable {
  const FavoritesButtonState({
    this.currentImage,
    this.favorites = const [],
  });

  final String? currentImage;
  final List<String> favorites;

  FavoritesButtonState copyWith({
    String? currentImage,
    List<String>? favorites,
  }) {
    return FavoritesButtonState(
      currentImage: currentImage ?? this.currentImage,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [currentImage, favorites];
}
