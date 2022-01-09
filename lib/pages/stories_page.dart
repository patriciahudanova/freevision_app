import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/config.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/pages/story_page.dart';
import 'package:flutter_challenge/providers/favourite_story.dart';
import 'package:flutter_challenge/widgets/likes_fab.dart';
import 'package:flutter_challenge/widgets/my_app_bar.dart';
import 'package:flutter_challenge/widgets/stories_grid.dart';
import 'package:flutter_challenge/widgets/story_tile.dart';
import 'package:provider/provider.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  List<Story> _allStories = [];

  @override
  void initState() {
    super.initState();

    _loadStories();
  }

  Future _loadStories() async {
    final dio = Dio();
    final api = Api(dio, baseUrl: kBaseUrl);
    final stories = await api.getStories(sort: 'position:ASC');

    setState(() {
      _allStories = stories;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[900],
        body: CustomScrollView(
          slivers: [
            const MyAppBar('freevision stories'),
            _allStories.isEmpty
                ? const SliverFillRemaining()
                : StoriesGrid(
                    stories: _allStories,
                    storyTileBuilder: (story) => _Tile(story: story),
                  ),
          ],
        ),
        floatingActionButton: const LikesFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
}

class _Tile extends StatelessWidget {
  final Story story;

  const _Tile({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoryTile(
      key: ValueKey(story.id),
      story: story,
      isFavorited: (Provider.of<FavouriteStory>(context, listen: true)
              .favouriteStories
              .where((favouriteStory) => favouriteStory.id == story.id)
              .isEmpty)
          ? false
          : true,
      onFavoriteTap: () {
        (Provider.of<FavouriteStory>(context, listen: false)
                .favouriteStories
                .where((favouriteStory) => favouriteStory.id == story.id)
                .isEmpty)
            ? Provider.of<FavouriteStory>(context, listen: false)
                .addToFavourite(story)
            : Provider.of<FavouriteStory>(context, listen: false)
                .removeFromFavourite(story);
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
