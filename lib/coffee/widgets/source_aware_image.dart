import 'dart:io';

import 'package:flutter/material.dart';

class SourceAwareImage extends StatelessWidget {
  const SourceAwareImage({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.toLowerCase().startsWith('http')) {
      return Image.network(url);
    } else {
      return Image.file(File(url));
    }
  }
}
