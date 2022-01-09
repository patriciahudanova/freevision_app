import 'package:flutter/material.dart';
import 'package:flutter_challenge/pages/favourite_stories_page.dart';
import 'package:flutter_challenge/providers/favourite_story.dart';
import 'package:provider/provider.dart';

import 'badge.dart';

class LikesFab extends StatelessWidget {
  const LikesFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      value: Provider.of<FavouriteStory>(context, listen: true)
          .favouriteStoryCount
          .toString(),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const FavouriteStoriesPage(),
          ));
        },
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        child: Ink(
          width: 58,
          height: 58,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                RadialGradient(center: Alignment.topRight, radius: 1, colors: [
              Color(0xfffffa8e),
              Color(0xffff8f8e),
              Color(0xffff738e),
            ], stops: [
              0.2,
              0.6,
              1
            ]),
          ),
          child: const Icon(
            Icons.favorite,
          ),
        ),
      ),
    );
  }
}
