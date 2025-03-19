import 'package:equatable/equatable.dart';

class CoffeeState extends Equatable {
  const CoffeeState({
    this.imageUrl,
    this.favorites = const [],
    this.showCarousel = false,
  });

  final String? imageUrl;
  final List<String> favorites;
  final bool showCarousel;

  CoffeeState copyWith({
    String? imageUrl,
    List<String>? favorites,
    bool? showCarousel,
  }) {
    return CoffeeState(
      imageUrl: imageUrl ?? this.imageUrl,
      favorites: favorites ?? this.favorites,
      showCarousel: showCarousel ?? this.showCarousel,
    );
  }

  @override
  List<Object?> get props => [imageUrl, favorites, showCarousel];
}
