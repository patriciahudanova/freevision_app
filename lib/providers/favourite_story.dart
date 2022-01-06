import 'package:flutter/cupertino.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/services/local_storage_service.dart';

class FavouriteStory with ChangeNotifier {
  FavouriteStory() {
    setup();
  }

  final List<Story> _favouriteStories = [];

  void setup() async {
    List<Story> savedFavouriteStories =
        await LocalStorageService().getFavouriteStories();
    setFavouriteStories(savedFavouriteStories);
  }

  List<Story> get favouriteStories {
    return _favouriteStories;
  }

  void setFavouriteStories(List<Story> likedStories) {
    _favouriteStories.addAll(likedStories);
    notifyListeners();
  }

  int get favouriteStoryCount {
    return _favouriteStories.length;
  }

  void addToFavourite(Story story) {
    if (favouriteStories
        .where((favouriteStory) => favouriteStory.id == story.id)
        .isEmpty) {
      _favouriteStories.add(story);
      LocalStorageService().setFavouriteStories(_favouriteStories);
      notifyListeners();
    }
  }

  void removeFromFavourite(Story story) {
    _favouriteStories
        .removeWhere((favouriteStory) => favouriteStory.id == story.id);
    LocalStorageService().setFavouriteStories(_favouriteStories);
    notifyListeners();
  }
}
