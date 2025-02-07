import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({required this.coffeeRepository, super.key});

  final CoffeeRepository coffeeRepository;

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  @override
  void initState() {
    super.initState();

    widget.coffeeRepository.refreshImage();
    widget.coffeeRepository.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.coffeeRepository.coffeeImage,
      builder: (_, snapshot) {
        final url = snapshot.data;
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: (url == null)
                    ? const CircularProgressIndicator.adaptive()
                    : Image.network(url),
              ),
              if (url != null)
                Positioned(
                  top: 16,
                  left: 16,
                  child: _FavoriteButton(
                    url: url,
                    coffeeRepository: widget.coffeeRepository,
                  ),
                ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  shape: const CircleBorder(),
                  child: const Icon(Icons.refresh),
                  onPressed: () => widget.coffeeRepository.refreshImage(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.url, required this.coffeeRepository});

  final String url;
  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
    // TODO(me): Update the favorite button when the user refreshes
    //  the coffee image
    return StreamBuilder(
      stream: coffeeRepository.favorites(),
      builder: (_, snapshot) {
        final isFavorite = coffeeRepository.isFavorite(url);
        return FloatingActionButton.small(
          shape: const CircleBorder(),
          child: Icon(
            isFavorite ? Icons.favorite_outline : Icons.favorite,
          ),
          onPressed: () {
            if (isFavorite) {
              coffeeRepository.removeFavorite(url);
            } else {
              coffeeRepository.addFavorite(url);
            }
          },
        );
      },
    );
  }
}
