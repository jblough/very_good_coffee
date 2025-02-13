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
