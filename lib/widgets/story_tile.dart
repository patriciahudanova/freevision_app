import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/widgets/radial_gradient.dart';
import 'package:rive/rive.dart';
import 'package:tuple/tuple.dart';

class StoryTile extends StatefulWidget {
  final Story story;
  final Function()? onTap;
  final Function() onFavoriteTap;
  final bool isFavorited;
  final bool isHero;

  const StoryTile({
    Key? key,
    required this.story,
    this.onTap,
    required this.onFavoriteTap,
    this.isHero = true,
    this.isFavorited = false,
  }) : super(key: key);

  @override
  _StoryTileState createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  Artboard? _likeArtboard;
  SMITrigger? _likeTrigger;

  Artboard? _unlikeArtboard;
  SMITrigger? _unlikeTrigger;

  bool _hasOverlay = false;

  @override
  void initState() {
    super.initState();

    Future.wait([
      loadAnim(
          riveFile: 'assets/hearth_icon.riv',
          statemachineName: 'sm',
          triggerName: 'onPressed',
          onStateChange: (_, stateName) {
            setState(() {
              _hasOverlay = stateName == 'Active';
            });
          }),
      loadAnim(
          riveFile: 'assets/hearth_icon_unlike.riv',
          statemachineName: 'sm',
          triggerName: 'onPressed',
          onStateChange: (_, stateName) {
            setState(() {
              _hasOverlay = stateName == 'Active';
            });
          }),
    ]).then((value) {
      setState(() {
        _likeArtboard = value[0]?.item2;
        _likeTrigger = value[0]?.item1;

        _unlikeArtboard = value[1]?.item2;
        _unlikeTrigger = value[1]?.item1;
      });
    });
  }

  Future<Tuple2<SMITrigger, Artboard>?> loadAnim({
    required String riveFile,
    required String statemachineName,
    required String triggerName,
    required void Function(String statemachineName, String stateName)
        onStateChange,
  }) {
    final completer = Completer<Tuple2<SMITrigger, Artboard>?>();

    rootBundle.load(riveFile).then(
      (data) async {
        try {
          final file = RiveFile.import(data);

          SMITrigger trigger;

          final artboard = file.mainArtboard;
          final stateMachineController = StateMachineController.fromArtboard(
            artboard,
            statemachineName,
            onStateChange: onStateChange,
          );

          if (stateMachineController != null) {
            artboard.addController(stateMachineController);
            trigger = stateMachineController.findSMI(triggerName);

            completer.complete(Tuple2(trigger, artboard));
          } else {
            completer.complete(null);
          }
        } catch (err, stack) {
          completer.completeError(err, stack);
        }
      },
    ).catchError((err, stack) {
      completer.completeError(err, stack);
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        child: InkWell(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: _Img(
                  story: widget.story,
                  isHero: widget.isHero,
                ),
              ),
              Positioned.fill(
                child: AnimatedContainer(
                  color: _hasOverlay ? Colors.black87 : Colors.transparent,
                  duration: const Duration(milliseconds: 200),
                ),
              ),
              if (_likeArtboard != null)
                Rive(
                  artboard: _likeArtboard!,
                ),
              if (_unlikeArtboard != null)
                Rive(
                  artboard: _unlikeArtboard!,
                ),
              if (!_hasOverlay)
                Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      widget.onFavoriteTap();

                      if (_likeTrigger == null || _unlikeTrigger == null) {
                        return;
                      }

                      if (!widget.isFavorited) {
                        _likeTrigger!.fire();
                      } else {
                        _unlikeTrigger!.fire();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: widget.isFavorited
                          ? RadiantGradientMask(
                              child: Icon(
                                Icons.favorite,
                                key: ValueKey(widget.isFavorited),
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.favorite_border,
                              key: ValueKey(widget.isFavorited),
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              if (!_hasOverlay)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 150),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10.0)),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AutoSizeText(
                        widget.story.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        minFontSize: 14,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

class _Img extends StatelessWidget {
  final bool isHero;
  final Story story;

  const _Img({
    Key? key,
    required this.story,
    this.isHero = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      imageUrl: MediaFormat.getAbsoluteUrl(story.thumbnailImageUrl) ?? '',
      fit: BoxFit.cover,
    );

    if (isHero) {
      child = Hero(
        tag: '${story.id}',
        child: child,
      );
    }

    return story.thumbnailImageUrl != null
        ? child
        : Container(color: Colors.grey);
  }
}
