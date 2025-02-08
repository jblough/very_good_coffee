import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_cubit.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
      builder: (context, state) {
        final cubit = context.read<FavoriteButtonCubit>();
        final isFavorite = cubit.isFavorite(url);
        return FloatingActionButton(
          shape: const CircleBorder(),
          tooltip:
              isFavorite ? l10n.tapToRemoveFavorite : l10n.tapToAddFavorite,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline,
          ),
          onPressed: () {
            if (isFavorite) {
              cubit.removeFavorite(url);
            } else {
              cubit.addFavorite(url);
            }
          },
        );
      },
    );
  }
}
