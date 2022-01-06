import 'dart:convert';

import 'package:flutter_challenge/data/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> setFavouriteStories(List<Story> favouriteStories) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> favouriteStoriesEncoded = favouriteStories
        .map((favouriteStory) => jsonEncode(favouriteStory.toJson()))
        .toList();

    prefs.setStringList('favouriteStories', favouriteStoriesEncoded);
  }

  Future<List<Story>> getFavouriteStories() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey('favouriteStories')) {
      List<String> favouriteStories = pref.getStringList('favouriteStories')!;
      return favouriteStories
          .map((favouriteStory) => Story.fromJson(json.decode(favouriteStory)))
          .toList();
    }
    return [];
  }
}
