sealed class FavoritesCarouselEvent {
  const FavoritesCarouselEvent();
}

final class IncomingFavorites extends FavoritesCarouselEvent {
  const IncomingFavorites(this.favorites);

  final List<String> favorites;
}

final class SetCurrentImage extends FavoritesCarouselEvent {
  const SetCurrentImage(this.url);

  final String url;
}
