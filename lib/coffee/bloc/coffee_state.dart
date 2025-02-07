import 'package:equatable/equatable.dart';

class CoffeeState extends Equatable {
  const CoffeeState({this.imageUrl});

  final String? imageUrl;

  @override
  List<Object?> get props => [imageUrl];
}
