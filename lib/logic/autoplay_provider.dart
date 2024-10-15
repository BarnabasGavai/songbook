import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AutoplayProvider with ChangeNotifier {
  late YoutubePlayerController _controller;
  bool _isControllerReady = false;

  YoutubePlayerController get controller => _controller;
  bool get isControllerReady => _isControllerReady;

  void initialize(String videoUrl) {
    _controller = YoutubePlayerController(
      initialVideoId: videoUrl,
      flags: const YoutubePlayerFlags(
        showLiveFullscreenButton: false,
        autoPlay: true,
        mute: false,
        hideThumbnail: true,
        forceHD: false,
        enableCaption: false,
      ),
    );
    _isControllerReady = true;

    notifyListeners();
  }

  void disposeController() {
    _isControllerReady = false;
    _controller.reset();
    _controller.reload();

    _controller.dispose();
  }

  @override
  void dispose() {
    _isControllerReady = false;
    _controller.dispose();

    super.dispose();
  }
}
