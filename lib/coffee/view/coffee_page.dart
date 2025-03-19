import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_event.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<CoffeeBloc>(
        create: (context) =>
            CoffeeBloc(context.read<CoffeeRepository>()),
        child: const CoffeeView(),
      ),
    );
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (_, state) {
        final url = state.imageUrl;
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx.abs() > 1000) {
                    downloadNewImage(context);
                  }
                },
                child: Center(
                  child: (url == null)
                      ? const CircularProgressIndicator.adaptive()
                      : SourceAwareImage(url: url),
                ),
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
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  tooltip: context.l10n.tapToDownload,
                  child: const Icon(Icons.refresh),
                  onPressed: () => downloadNewImage(context),
                ),
              ),
              if (state.favorites.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    tooltip: context.l10n.tapToViewFavorites,
                    child: const Icon(Icons.photo_library_outlined),
                    onPressed: () async {
                      context.read<CoffeeBloc>().add(const ToggleCarousel());
                    },
                  ),
                ),
            ],
          ),
          bottomSheet: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: state.showCarousel
                ? const _FavoritesCarouselWrapper()
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  void downloadNewImage(BuildContext context) {
    context.read<CoffeeBloc>().add(const RefreshImage());
  }
}

class _FavoritesCarouselWrapper extends StatelessWidget {
  const _FavoritesCarouselWrapper();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          const FavoritesCarousel(),
          Positioned(
            top: 10,
            right: 10,
            child: FilledButton(
              child: Text(context.l10n.close),
              onPressed: () =>
                  context.read<CoffeeBloc>().add(const ToggleCarousel()),
            ),
          ),
        ],
      ),
    );
  }
}
