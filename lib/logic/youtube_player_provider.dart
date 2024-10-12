import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerProvider with ChangeNotifier {
  late YoutubePlayerController _controller;
  bool _isControllerReady = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _loading = false;
  bool _ended = false;

  YoutubePlayerController get controller => _controller;
  bool get isControllerReady => _isControllerReady;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get loading => _loading;
  bool get ended => _ended;

  void initialize(String videoUrl) {
    setLoading(true);
    _isControllerReady = true;

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(_controllerListener);
    play();
    Future.delayed(const Duration(seconds: 1), pause);

    notifyListeners();
  }

  void setEndedFalse() {
    if (_isControllerReady) {
      if (isPlaying) {
        _ended = false;
      }
    }
  }

  void _controllerListener() {
    if (_controller.value.isReady) {
      _isPlaying = _controller.value.isPlaying;
      _position = _controller.value.position;
      _duration = _controller.metadata.duration;
      if ((_position.inSeconds >= _duration.inSeconds - 1) &&
          _duration != Duration.zero) {
        pause();
        _ended = true;
      }
      if (!_controller.value.isPlaying && isPlaying) {
        pause();
        _controller.pause();
      }
      notifyListeners();
    }
  }

  void setLoading(bool mybool) {
    _loading = mybool;
    notifyListeners();
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

  void setPosition(Duration myDuration) {
    int mypos = _position.inSeconds;
    int reqpos = myDuration.inSeconds;

    bool isForward = reqpos > mypos;
    if (isForward && (reqpos <= _duration.inSeconds)) {
      _controller.seekTo(myDuration);
    }
    if (!isForward && (reqpos >= 0)) {
      _controller.seekTo(myDuration);
    }

    notifyListeners();
  }

  void stop(bool fromwidget) {
    if (_isControllerReady) {
      if (fromwidget) {
        _controller.pause();
        _isPlaying = false;
        _isControllerReady = false;
        _duration = Duration.zero;
        _position = Duration.zero;
        notifyListeners();
      } else {
        _isPlaying = false;
        _isControllerReady = false;
        _duration = Duration.zero;
        _position = Duration.zero;
        _controller.dispose();
      }
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
