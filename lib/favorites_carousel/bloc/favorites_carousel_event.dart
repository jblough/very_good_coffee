import 'package:equatable/equatable.dart';

sealed class FavoritesCarouselEvent extends Equatable {
  const FavoritesCarouselEvent();

  @override
  List<Object?> get props => [];
}

final class IncomingFavorites extends FavoritesCarouselEvent {
  const IncomingFavorites(this.favorites);

  final List<String> favorites;
}

final class SetCurrentImage extends FavoritesCarouselEvent {
  const SetCurrentImage(this.url);

  final String url;
}
