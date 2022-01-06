import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/data/api.dart';

class StoryTile extends StatelessWidget {
  final Story story;
  final Function()? onTap;
  final Function()? onFavoriteTap;
  final bool isFavorited;

  const StoryTile({
    Key? key,
    required this.story,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorited = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(child: _buildImageWidget()),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: onFavoriteTap,
                            child: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(isFavorited),
                              color: isFavorited ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxWidth: 150),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.0)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: AutoSizeText(
                                story.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                minFontSize: 14,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildImageWidget() => story.thumbnailImageUrl != null
      ? Hero(
          tag: '${story.id}',
          child: CachedNetworkImage(
            imageUrl: MediaFormat.getAbsoluteUrl(story.thumbnailImageUrl) ?? '',
            fit: BoxFit.cover,
          ),
        )
      : Container(color: Colors.grey);
}
