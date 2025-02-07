import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_cubit.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_state.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoritesCarousel extends StatelessWidget {
  const FavoritesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Center(
            child: BlocBuilder<FavoritesCarouselCubit, FavoritesCarouselState>(
              builder: (context, state) {
                final files = state.favorites;
                return CarouselView(
                  itemExtent: 200,
                  itemSnapping: true,
                  onTap: (index) => context
                      .read<FavoritesCarouselCubit>()
                      .setCurrentImage(files[index]),
                  children: <Widget>[
                    for (final file in files) Image.file(File(file)),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: ElevatedButton(
              child: Text(context.l10n.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
