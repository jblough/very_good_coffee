import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoritesCarousel extends StatelessWidget {
  const FavoritesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeRepository = context.read<CoffeeRepository>();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Center(
            child: StreamBuilder<List<String>>(
              stream: coffeeRepository.favorites,
              builder: (context, snapshot) {
                final files = snapshot.data ?? [];
                return CarouselView(
                  itemExtent: 200,
                  onTap: (index) =>
                      coffeeRepository.setCurrentImage(files[index]),
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
