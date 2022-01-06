import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:kenburns/kenburns.dart';

class StoryPage extends StatelessWidget {
  final Story story;

  const StoryPage({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
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
              KenBurns(
                maxScale: 1.3,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: MediaFormat.getAbsoluteUrl(story.largestImageUrl)!,
                ),
              )
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
                              ]),
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
