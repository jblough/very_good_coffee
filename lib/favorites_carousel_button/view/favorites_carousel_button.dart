import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorites_carousel/view/favorites_carousel.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_bloc.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_state.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoritesCarouselButton extends StatelessWidget {
  const FavoritesCarouselButton({super.key, this.bloc});

  final FavoritesCarouselButtonBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCarouselButtonBloc>(
      create: (context) =>
          bloc ?? FavoritesCarouselButtonBloc(context.read<CoffeeRepository>()),
      child: const FavoritesCarouselButtonView(),
    );
  }
}

class FavoritesCarouselButtonView extends StatefulWidget {
  const FavoritesCarouselButtonView({super.key});

  @override
  State<FavoritesCarouselButtonView> createState() =>
      _FavoritesCarouselButtonViewState();
}

class _FavoritesCarouselButtonViewState
    extends State<FavoritesCarouselButtonView> {
  PersistentBottomSheetController? _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCarouselButtonBloc,
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
              return;
            }

            _controller = Scaffold.of(context).showBottomSheet(
              (BuildContext context) => const FavoritesCarousel(),
              elevation: 0,
            );
            await _controller?.closed;
            _controller = null;
          },
        );
      },
    );
  }
}
