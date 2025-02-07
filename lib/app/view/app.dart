import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:very_good_coffee/coffee/view/coffee_page.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({required this.coffeeRepository, super.key});

  final CoffeeRepository coffeeRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: CoffeePage(coffeeRepository: coffeeRepository)),
    );
  }
}
