import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_cubit.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorites_button/view/favorites_button.dart';
import 'package:very_good_coffee/favorites_carousel_button/view/favorites_carousel_button.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
  @override
  void initState() {
    super.initState();

    context.read<CoffeeRepository>()
      ..refreshImage()
      ..loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CoffeeCubit, String?>(
        builder: (_, url) {
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
                    onPressed: () => context.read<CoffeeCubit>().refreshImage(),
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  left: 16,
                  child: FavoritesCarouselButton(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
