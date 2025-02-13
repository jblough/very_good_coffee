import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_event.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_state.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key, this.bloc});

  final CoffeeBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<CoffeeBloc>(
        create: (context) =>
            bloc ?? CoffeeBloc(context.read<CoffeeRepository>()),
        child: const CoffeeView(),
      ),
    );
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CoffeeBloc, CoffeeState>(
        builder: (_, state) {
          final url = state.imageUrl;
          return Stack(
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
              const Positioned(
                bottom: 16,
                left: 16,
                child: FavoritesCarouselButton(),
              ),
            ],
          );
        },
      ),
    );
  }

  void downloadNewImage(BuildContext context) {
    context.read<CoffeeBloc>().add(const RefreshImage());
  }
}
