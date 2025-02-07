import 'package:equatable/equatable.dart';

enum CoffeeApiResponseStatus { empty, error, success }

class CoffeeApiResponse extends Equatable {
  const CoffeeApiResponse({required this.status, this.url, this.error});

  factory CoffeeApiResponse.ok(String url) =>
      CoffeeApiResponse(status: CoffeeApiResponseStatus.success, url: url);

  factory CoffeeApiResponse.error(
    CoffeeApiResponseStatus status, {
    String? error,
  }) =>
      CoffeeApiResponse(status: status, error: error);

  factory CoffeeApiResponse.empty() =>
      const CoffeeApiResponse(status: CoffeeApiResponseStatus.empty);

  final CoffeeApiResponseStatus status;
  final String? url;
  final String? error;

  bool isOk() => status == CoffeeApiResponseStatus.success;

  @override
  List<Object?> get props => [status, url, error];
}
