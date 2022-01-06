import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challenge/pages/home_page.dart';
import 'package:flutter_challenge/providers/favourite_story.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
      .copyWith(statusBarIconBrightness: Brightness.light));

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => FavouriteStory(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'freevision stories',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
          ),
          home: const HomePage(),
        ),
      );
}
