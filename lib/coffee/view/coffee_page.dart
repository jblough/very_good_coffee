import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_cubit.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorite_button/view/favorite_button.dart';
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
      ..loadFavorites()
      ..refreshImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CoffeeCubit, CoffeeState>(
        builder: (_, state) {
          final url = state.imageUrl;
          return Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx.abs() > 1000) {
                      pullDownNewImage(context);
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
                    onPressed: () => pullDownNewImage(context),
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

  void pullDownNewImage(BuildContext context) {
    context.read<CoffeeCubit>().refreshImage();
  }
}
