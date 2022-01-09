import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:kenburns/kenburns.dart';
import 'package:octo_image/octo_image.dart';

class StoryPage extends StatelessWidget {
  final Story story;

  const StoryPage({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rnd = Random();

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          if (story.largestImageUrl != null) ...[
            Hero(
              tag: '${story.id}',
              child: KenBurns(
                maxScale: 1.3,
                child: OctoImage(
                  image: CachedNetworkImageProvider(
                      MediaFormat.getAbsoluteUrl(story.largestImageUrl)!),
                  placeholderBuilder: OctoPlaceholder.blurHash(
                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                  ),
                  errorBuilder: OctoError.icon(color: Colors.red),
                  fit: BoxFit.cover,
                  fadeOutCurve: Curves.easeOut,
                  fadeInCurve: Curves.easeOut,
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 200),
                ),
              ),
            ),
          ],
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [
                            0.0,
                            1.0,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: AutoSizeText(
                            story.title,
                            minFontSize: 20,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return -(pow(e, -t / a) * cos(t * w)) + 1;
  }
}
