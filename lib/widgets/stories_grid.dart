import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StoriesGrid extends StatelessWidget {
  final List<Story> stories;
  final Widget Function(Story story) storyTileBuilder;

  const StoriesGrid({
    Key? key,
    required this.stories,
    required this.storyTileBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: AnimationLimiter(
        child: SliverStaggeredGrid.countBuilder(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: SlideAnimation(child: storyTileBuilder(story)),
            );
          },
          staggeredTileBuilder: (index) {
            final story = stories[index];

            return StaggeredTile.count(
                1, math.max(story.aspectRatio ?? 1.0, 1.0));
          },
        ),
      ),
    );
  }
}
