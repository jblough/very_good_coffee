import 'package:equatable/equatable.dart';

class FavoriteButtonState extends Equatable {
  const FavoriteButtonState({
    this.currentImage,
    this.favorites = const [],
  });

  final String? currentImage;
  final List<String> favorites;

  FavoriteButtonState copyWith({
    String? currentImage,
    List<String>? favorites,
  }) {
    return FavoriteButtonState(
      currentImage: currentImage ?? this.currentImage,
      favorites: favorites ?? this.favorites,
    );
  }

  bool isFavorite() {
    final filename = currentImage?.split('/').last.toLowerCase();
    return filename != null &&
        favorites.any((e) => e.toLowerCase().endsWith(filename));
  }

  @override
  List<Object?> get props => [currentImage, favorites];
}
