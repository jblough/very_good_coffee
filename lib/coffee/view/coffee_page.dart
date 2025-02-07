import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorites_button/view/favorites_button.dart';
import 'package:very_good_coffee/favorites_carousel/view/favorites_carousel.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  late final coffeeRepository = context.read<CoffeeRepository>();
  @override
  void initState() {
    super.initState();

    coffeeRepository
      ..refreshImage()
      ..loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<String?>(
        stream: coffeeRepository.currentImage,
        builder: (_, snapshot) {
          final url = snapshot.data;
          return Scaffold(
            body: Stack(
              children: [
                Center(
                  child: (url == null)
                      ? const CircularProgressIndicator.adaptive()
                      : SourceAwareImage(url: url),
                ),
                if (url != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: FavoriteButton(url: url),
                  ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    shape: const CircleBorder(),
                    tooltip: context.l10n.tapToDownload,
                    child: const Icon(Icons.refresh),
                    onPressed: () => coffeeRepository.refreshImage(),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: StreamBuilder<List<String>>(
                    stream: coffeeRepository.favorites,
                    builder: (context, snapshot) {
                      final hasFavorites = snapshot.data?.isNotEmpty ?? false;
                      if (!hasFavorites) {
                        return const SizedBox.shrink();
                      }
                      return FloatingActionButton.small(
                        shape: const CircleBorder(),
                        tooltip: context.l10n.tapToViewFavorites,
                        child: const Icon(Icons.photo_library_outlined),
                        onPressed: () {
                          Scaffold.of(context).showBottomSheet(
                            elevation: 0,
                            (BuildContext context) => const FavoritesCarousel(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
