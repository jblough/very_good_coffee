import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:very_good_coffee/coffee/widgets/source_aware_image.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('test network image', (tester) async {
    await mockNetworkImages(() async {
      const url = 'https://test.com/a.png';
      const widget = SourceAwareImage(url: url);
      await tester.pumpApp(widget);
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget(find.byType(Image)) as Image;
      final networkImage = image.image as NetworkImage;
      expect(networkImage.url, url);
    });
  });

  testWidgets('test file image', (tester) async {
    await mockNetworkImages(() async {
      const url = 'test.com/a.png';
      const widget = SourceAwareImage(url: url);
      await tester.pumpApp(widget);
      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget(find.byType(Image)) as Image;
      final fileImage = image.image as FileImage;
      expect(fileImage.file.path, url);
    });
  });
}
