import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerProvider with ChangeNotifier {
  late YoutubePlayerController _controller;
  bool _isControllerReady = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _loading = false;

  YoutubePlayerController get controller => _controller;
  bool get isControllerReady => _isControllerReady;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get loading => _loading;

  void initialize(String videoUrl) {
    _loading = true;
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(_controllerListener);
    Future.delayed(const Duration(seconds: 5), () {
      _isControllerReady = true;
      _loading = false;

      notifyListeners();
    });
  }

  void _controllerListener() {
    if (_controller.value.isReady) {
      _isPlaying = _controller.value.isPlaying;
      _position = _controller.value.position;
      _duration = _controller.metadata.duration;
      notifyListeners();
    }
  }

  void play() {
    if (_isControllerReady && !_isPlaying) {
      _controller.play();
      _isPlaying = true;
      notifyListeners();
    }
  }

  void pause() {
    if (_isControllerReady) {
      _controller.pause();
      _isPlaying = false;
      notifyListeners();
    }
  }

  void stop() {
    if (_isControllerReady) {
      _controller.pause();
      _isPlaying = false;
      _isControllerReady = false;
      _duration = Duration.zero;
      _position = Duration.zero;
      _controller.dispose();
      notifyListeners();
    }
  }

  void seekTo(Duration position) {
    if (_isControllerReady) {
      _controller.seekTo(position);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_controllerListener);
    _controller.dispose();
    super.dispose();
  }
}
