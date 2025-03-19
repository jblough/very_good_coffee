sealed class CoffeeEvent {
  const CoffeeEvent();
}

final class IncomingImage extends CoffeeEvent {
  const IncomingImage(this.image);

  final String? image;
}

final class RefreshImage extends CoffeeEvent {
  const RefreshImage();
}

final class IncomingFavorites extends CoffeeEvent {
  const IncomingFavorites(this.favorites);

  final List<String> favorites;
}

final class ToggleCarousel extends CoffeeEvent {
  const ToggleCarousel();
}
