import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  const MyAppBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      snap: false,
      pinned: true,
      floating: false,
      backgroundColor: Colors.black,
      expandedHeight: 80,
      flexibleSpace: FlexibleSpaceBar(
        title: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: AutoSizeText(
              title,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline1,
              maxFontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
