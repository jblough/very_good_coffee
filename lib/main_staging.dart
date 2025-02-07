import 'package:coffee_repository/coffee_repository.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/bootstrap.dart';

void main() {
  bootstrap(() => App(coffeeRepository: CoffeeRepository()));
}
