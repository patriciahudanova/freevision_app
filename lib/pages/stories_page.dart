import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/config.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/widgets/story_tile.dart';
import 'package:flutter_challenge/widgets/badge.dart';
import 'package:flutter_challenge/pages/story_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math' as math;

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
                      'freevision stories',
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
              itemCount: _allStories.length,
              itemBuilder: (context, index) {
                var story = _allStories[index];

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: StoryTile(
                    key: ValueKey(story.id),
                    story: story,
                    isFavorited: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryPage(story: story),
                        ),
                      );
                    },
                  ),
                );
              },
              staggeredTileBuilder: (index) {
                final story = _allStories[index];
                return StaggeredTile.count(
                    1, math.max(story.aspectRatio ?? 1.0, 1.0));
              },
            ),
          )
        ]),
        floatingActionButton: Badge(
          value: '0',
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: const Icon(
              Icons.favorite,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
}
