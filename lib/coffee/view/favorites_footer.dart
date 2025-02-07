import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoritesFooter extends StatelessWidget {
  const FavoritesFooter({required this.coffeeRepository, super.key});

  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
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
