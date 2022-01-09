import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/pages/story_page.dart';
import 'package:flutter_challenge/providers/favourite_story.dart';
import 'package:flutter_challenge/widgets/my_app_bar.dart';
import 'package:flutter_challenge/widgets/stories_grid.dart';
import 'package:flutter_challenge/widgets/story_tile.dart';
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
      body: CustomScrollView(
        slivers: [
          const MyAppBar('favourite stories'),
          StoriesGrid(
            stories: _favouriteStories,
            storyTileBuilder: (story) => _Tile(
              story: story,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final Story story;
  const _Tile({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoryTile(
      key: ValueKey(story.id),
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
