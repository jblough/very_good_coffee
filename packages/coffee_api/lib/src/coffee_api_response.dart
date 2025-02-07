enum CoffeeApiResponseStatus { empty, error, success }

class CoffeeApiResponse {
  CoffeeApiResponse({required this.status, this.url, this.error});

  factory CoffeeApiResponse.ok(String url) =>
      CoffeeApiResponse(status: CoffeeApiResponseStatus.success, url: url);

  factory CoffeeApiResponse.error(
    CoffeeApiResponseStatus status, {
    String? error,
  }) =>
      CoffeeApiResponse(status: status, error: error);

  final CoffeeApiResponseStatus status;
  final String? url;
  final String? error;

  bool isOk() => status == CoffeeApiResponseStatus.success;
}
