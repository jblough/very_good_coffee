import 'dart:io';

import 'package:flutter/material.dart';

class SourceAwareImage extends StatelessWidget {
  const SourceAwareImage({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.toLowerCase().startsWith('http')) {
      return Image.network(
        url,
        gaplessPlayback: true,
        frameBuilder: (
          BuildContext context,
          Widget child,
          int? frame,
          bool? wasSynchronouslyLoaded,
        ) {
          if (frame == null) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0.7,
                  child: child,
                ),
                DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(width: 2),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          }
          return child;
        },
      );
    } else {
      return Image.file(
        File(url),
        gaplessPlayback: true,
      );
    }
  }
}
