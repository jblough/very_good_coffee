import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorites_carousel/view/favorites_carousel.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_cubit.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoritesCarouselButton extends StatefulWidget {
  const FavoritesCarouselButton({super.key});

  @override
  State<FavoritesCarouselButton> createState() =>
      _FavoritesCarouselButtonState();
}

class _FavoritesCarouselButtonState extends State<FavoritesCarouselButton> {
  PersistentBottomSheetController? _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCarouselButtonCubit,
        FavoritesCarouselButtonState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton(
          shape: const CircleBorder(),
          tooltip: context.l10n.tapToViewFavorites,
          child: const Icon(Icons.photo_library_outlined),
          onPressed: () async {
            if (_controller != null) {
              _controller?.close();
              _controller = null;
              return;
            }

            _controller = Scaffold.of(context).showBottomSheet(
              elevation: 0,
              (BuildContext context) => const FavoritesCarousel(),
            );
            await _controller?.closed;
            _controller = null;
          },
        );
      },
    );
  }
}
