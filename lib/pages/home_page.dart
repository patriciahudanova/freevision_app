import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/pages/stories_page.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Image.asset(
                  'assets/freevision-logo.png',
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: RiveAnimation.asset('assets/dog_phone.riv')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StoriesPage(),
                  ),
                ),
                child: const Text(
                  "Let's start",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
