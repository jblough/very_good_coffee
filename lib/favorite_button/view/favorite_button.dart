import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_bloc.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_event.dart';
import 'package:very_good_coffee/favorite_button/bloc/favorite_button_state.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.url, super.key, this.bloc});

  final String url;
  final FavoriteButtonBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteButtonBloc>(
      create: (context) =>
          bloc ?? FavoriteButtonBloc(context.read<CoffeeRepository>()),
      child: FavoriteButtonView(url: url),
    );
  }
}

class FavoriteButtonView extends StatelessWidget {
  const FavoriteButtonView({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite();
        return FloatingActionButton(
          shape: const CircleBorder(),
          tooltip:
              isFavorite ? l10n.tapToRemoveFavorite : l10n.tapToAddFavorite,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline,
          ),
          onPressed: () {
            final bloc = context.read<FavoriteButtonBloc>();
            if (isFavorite) {
              bloc.add(RemoveFavorite(url));
            } else {
              bloc.add(AddFavorite(url));
            }
          },
        );
      },
    );
  }
}
