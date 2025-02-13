sealed class FavoritesCarouselButtonEvent {
  const FavoritesCarouselButtonEvent();
}

final class IncomingFavorites extends FavoritesCarouselButtonEvent {
  const IncomingFavorites(this.favorites);

  final List<String> favorites;
}
