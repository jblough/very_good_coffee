import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_bloc.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_event.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';

class FavoritesCarousel extends StatelessWidget {
  const FavoritesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCarouselBloc>(
      create: (context) =>
          FavoritesCarouselBloc(context.read<CoffeeRepository>()),
      child: const FavoritesCarouselView(),
    );
  }
}

class FavoritesCarouselView extends StatelessWidget {
  const FavoritesCarouselView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<FavoritesCarouselBloc, FavoritesCarouselState>(
        builder: (context, state) {
          final files = state.favorites;
          return CarouselView(
            elevation: 0,
            itemExtent: 200,
            itemSnapping: true,
            onTap: (index) => context
                .read<FavoritesCarouselBloc>()
                .add(SetCurrentImage(files[index])),
            children: <Widget>[
              for (final file in files) Image.file(File(file)),
            ],
          );
        },
      ),
    );
  }
}
