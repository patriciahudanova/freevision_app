import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/pages/story_page.dart';
import 'package:flutter_challenge/providers/favourite_story.dart';
import 'package:flutter_challenge/widgets/story_tile.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FavouriteStoriesPage extends StatefulWidget {
  const FavouriteStoriesPage({Key? key}) : super(key: key);

  @override
  _FavouriteStoriesPageState createState() => _FavouriteStoriesPageState();
}

class _FavouriteStoriesPageState extends State<FavouriteStoriesPage> {
  @override
  Widget build(BuildContext context) {
    final _favouriteStories =
        Provider.of<FavouriteStory>(context, listen: true).favouriteStories;
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          snap: false,
          pinned: true,
          floating: false,
          backgroundColor: Colors.black,
          expandedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AutoSizeText(
                    ' favourite stories',
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 30,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverStaggeredGrid.countBuilder(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            itemCount: _favouriteStories.length,
            itemBuilder: (context, index) {
              final story = _favouriteStories[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: SlideAnimation(
                  // return AnimatedSwitcher(
                  //   duration: const Duration(milliseconds: 200),
                  //   transitionBuilder: (child, animation) => ScaleTransition(
                  //     scale: animation,
                  //     child: child,
                  //   ),
                  child: _Tile(
                    key: ValueKey(story.id),
                    story: story,
                  ),
                ),
              );
            },
            staggeredTileBuilder: (index) {
              final story = _favouriteStories[index];
              return StaggeredTile.count(
                  1, math.max(story.aspectRatio ?? 1.0, 1.0));
            },
          ),
        )
      ]),
    );
  }
}

class _Tile extends StatelessWidget {
  final Story story;
  const _Tile({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoryTile(
      story: story,
      isHero: false,
      isFavorited: Provider.of<FavouriteStory>(context, listen: true)
              .favouriteStories
              .contains(story)
          ? true
          : false,
      onFavoriteTap: () {
        Provider.of<FavouriteStory>(context, listen: false)
                .favouriteStories
                .contains(story)
            ? Provider.of<FavouriteStory>(context, listen: false)
                .removeFromFavourite(story)
            : Provider.of<FavouriteStory>(context, listen: false)
                .addToFavourite(story);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryPage(story: story),
          ),
        );
      },
    );
  }
}
