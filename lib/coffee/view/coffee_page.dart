import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:very_good_coffee/coffee/view/favorites_footer.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

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
    return StreamBuilder<CoffeeApiResponse>(
      stream: widget.coffeeRepository.coffeeImage,
      builder: (_, snapshot) {
        // TODO(me): Handle response statuses better (show favorites when
        //  no network image available)
        final url = snapshot.data?.url;
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
                  tooltip: context.l10n.tapToDownload,
                  child: const Icon(Icons.refresh),
                  onPressed: () => widget.coffeeRepository.refreshImage(),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton.small(
                  shape: const CircleBorder(),
                  tooltip: context.l10n.tapToViewFavorites,
                  child: const Icon(Icons.photo_library_outlined),
                  onPressed: () {
                    Scaffold.of(context).showBottomSheet(
                      elevation: 0,
                      (BuildContext context) => FavoritesFooter(
                        coffeeRepository: widget.coffeeRepository,
                      ),
                    );
                  },
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
    final l10n = context.l10n;

    return StreamBuilder(
      stream: coffeeRepository.favorites,
      builder: (_, snapshot) {
        final isFavorite = coffeeRepository.isFavorite(url);
        return FloatingActionButton.small(
          shape: const CircleBorder(),
          tooltip:
              isFavorite ? l10n.tapToRemoveFavorite : l10n.tapToAddFavorite,
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
