import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/favorite_button/favorite_button.dart';
import 'package:very_good_coffee/favorites_carousel/favorites_carousel.dart';
import 'package:very_good_coffee/favorites_carousel_button/favorites_carousel_button.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({required this.coffeeRepository, super.key});

  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF472D05),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: RepositoryProvider<CoffeeRepository>.value(
        value: coffeeRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<CoffeeCubit>(
              create: (_) => CoffeeCubit(coffeeRepository),
            ),
            BlocProvider<FavoriteButtonCubit>(
              create: (_) => FavoriteButtonCubit(coffeeRepository),
            ),
            BlocProvider<FavoritesCarouselCubit>(
              create: (_) => FavoritesCarouselCubit(coffeeRepository),
            ),
            BlocProvider<FavoritesCarouselButtonCubit>(
              create: (_) => FavoritesCarouselButtonCubit(coffeeRepository),
            ),
          ],
          child: const Scaffold(body: CoffeePage()),
        ),
      ),
    );
  }
}
