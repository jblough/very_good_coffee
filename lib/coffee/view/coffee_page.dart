import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:very_good_coffee/coffee/widgets/favorites_button.dart';
import 'package:very_good_coffee/coffee/widgets/favorites_footer.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
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
    return StreamBuilder<String?>(
      stream: widget.coffeeRepository.currentImage,
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
                  child: FavoriteButton(
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
                child: StreamBuilder<List<String>>(
                  stream: widget.coffeeRepository.favorites,
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
                          (BuildContext context) => FavoritesFooter(
                            coffeeRepository: widget.coffeeRepository,
                          ),
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
    );
  }
}
