sealed class FavoriteButtonEvent {
  const FavoriteButtonEvent();
}

final class IncomingFavorites extends FavoriteButtonEvent {
  const IncomingFavorites(this.favorites);

  final List<String> favorites;
}

final class IncomingImage extends FavoriteButtonEvent {
  const IncomingImage(this.image);

  final String? image;
}

final class AddFavorite extends FavoriteButtonEvent {
  const AddFavorite(this.url);

  final String url;
}

final class RemoveFavorite extends FavoriteButtonEvent {
  const RemoveFavorite(this.url);

  final String url;
}
