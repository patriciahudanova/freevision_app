import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge/data/api.dart';
import 'package:flutter_challenge/widgets/radial_gradient.dart';
import 'package:rive/rive.dart';

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
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMITrigger? _pressInput;

  Artboard? _riveArtboardUnlike;
  StateMachineController? _controllerUnlike;
  SMITrigger? _pressInputUnlike;

  bool _hasOverlay = false;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/hearth_icon.riv').then((data) async {
      // Load the RiveFile from the binary data.
      final file = RiveFile.import(data);

      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard;
      _controller = StateMachineController.fromArtboard(
        artboard,
        'sm',
        onStateChange: (_, stateName) {
          setState(() {
            _hasOverlay = stateName == 'Active';
          });
        },
      );

      if (_controller != null) {
        artboard.addController(_controller!);
        _pressInput = _controller!.findSMI('onPressed');
      }

      setState(() => _riveArtboard = artboard);
    });

    rootBundle.load('assets/hearth_icon_unlike.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboardUnlike = file.mainArtboard;
        _controllerUnlike = StateMachineController.fromArtboard(
          artboardUnlike,
          'sm',
          onStateChange: (_, stateName) {
            setState(() {
              _hasOverlay = stateName == 'Active';
            });
          },
        );

        if (_controllerUnlike != null) {
          artboardUnlike.addController(_controllerUnlike!);
          _pressInputUnlike = _controllerUnlike!.findSMI('onPressed');
        }
        setState(() => _riveArtboardUnlike = artboardUnlike);
      },
    );
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4.0, // soften the shadow
                  spreadRadius: 1.0, //extend the shadow
                  offset: Offset(
                    2.0, // Move to right 10  horizontally
                    2.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(child: _buildImageWidget()),
                  Positioned.fill(
                    child: AnimatedContainer(
                      color: _hasOverlay ? Colors.black87 : Colors.transparent,
                      duration: Duration(milliseconds: 200),
                    ),
                  ),
                  if (_riveArtboard != null)
                    Rive(
                      artboard: _riveArtboard!,
                    ),
                  if (_riveArtboardUnlike != null)
                    Rive(
                      artboard: _riveArtboardUnlike!,
                    ),
                  if (!_hasOverlay)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          widget.onFavoriteTap();
                          if (!widget.isFavorited) {
                            _pressInput!.fire();
                          } else if (_riveArtboardUnlike != null) {
                            _pressInputUnlike!.fire();
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
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0)),
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
          ),
        ),
      );

  Widget _buildImageWidget() {
    Widget child = CachedNetworkImage(
      imageUrl:
          MediaFormat.getAbsoluteUrl(widget.story.thumbnailImageUrl) ?? '',
      fit: BoxFit.cover,
    );

    if (widget.isHero) {
      child = Hero(
        tag: '${widget.story.id}',
        child: child,
      );
    }

    return widget.story.thumbnailImageUrl != null
        ? child
        : Container(color: Colors.grey);
  }
}
