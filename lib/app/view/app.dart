import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_cubit.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';
import 'package:very_good_coffee/favorites_button/bloc/favorites_button_cubit.dart';
import 'package:very_good_coffee/favorites_carousel/bloc/favorites_carousel_cubit.dart';
import 'package:very_good_coffee/favorites_carousel_button/bloc/favorites_carousel_button_cubit.dart';
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
            BlocProvider<FavoritesButtonCubit>(
              create: (_) => FavoritesButtonCubit(coffeeRepository),
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
