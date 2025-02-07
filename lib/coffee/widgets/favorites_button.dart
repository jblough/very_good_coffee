import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.url,
    required this.coffeeRepository,
    super.key,
  });

  final String url;
  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
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
            isFavorite ? Icons.favorite : Icons.favorite_outline,
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
