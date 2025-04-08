import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fall_controller.dart';
import 'fall_object.dart';
import 'fall_painter.dart';

/// FlutterFall is a widget that simulates falling particles (either images or emojis) on the screen.
///
/// The particles can be customized in terms of size, speed, rotation speed, wind speed,
/// and the number of particles. It also supports both image and emoji particles.
class FlutterFall extends StatefulWidget {
  /// The total number of falling particles.
  final int totalParticles;

  /// The speed at which the particles fall.
  final double particleSpeed;

  /// Flag to determine whether the fall animation is running.
  final bool isRunning;

  /// Flag to determine whether particles should start from the top.
  final bool startFromTop;

  /// A list of particle image paths used when `useEmojis` is false.
  final List<String> particleImages;

  /// A list of emojis used when `useEmojis` is true.
  final List<String>? emojiList;

  /// The size of the particles.
  final double? particleSize;

  /// The speed at which the particles rotate.
  final double particleRotationSpeed;

  /// The speed at which the particles are affected by wind.
  final double particleWindSpeed;

  /// A controller to update the properties of the falling particles dynamically.
  final FallController? fallController;

  /// Flag to switch between emoji and image particles. Defaults to false (images).
  final bool? useEmojis;

  const FlutterFall({
    super.key,
    this.totalParticles = 40,
    this.particleSpeed = 0.05,
    this.isRunning = true,
    required this.particleImages,
    this.emojiList,
    this.startFromTop = false,
    this.particleSize = 30,
    this.particleRotationSpeed = 0.02,
    this.particleWindSpeed = 1.0,
    this.fallController,
    this.useEmojis = false, // Default is false, meaning images are used
  });

  @override
  FallWidgetState createState() => FallWidgetState();
}

class FallWidgetState extends State<FlutterFall> with TickerProviderStateMixin {
  late final AnimationController controller;
  late int _totalObjects;
  late double _speed;
  late double _particleSize;
  late double _rotationSpeed;
  late double _windSpeed;
  final List<FallObject> _fallingObjects = [];

  @override
  void initState() {
    super.initState();

    _totalObjects = widget.fallController?.totalParticles ?? widget.totalParticles;
    _speed = widget.fallController?.particleFallSpeed ?? widget.particleSpeed;
    _particleSize = widget.fallController?.particleSize ?? widget.particleSize!;
    _rotationSpeed = widget.fallController?.particleRotationSpeed ?? widget.particleRotationSpeed;
    _windSpeed = widget.fallController?.particleWindSpeed ?? widget.particleWindSpeed;

    widget.fallController?.onUpdate = ({
      int? totalObjects,
      double? speed,
      double? particleSize,
      double? windSpeed,
      double? rotationSpeed,
    }) {
      setState(() {
        if (totalObjects != null) _updateTotalObjects(totalObjects);
        if (speed != null) _speed = speed;
        if (particleSize != null) _updateParticleSize(particleSize);
        if (windSpeed != null) _updateWindSpeed(windSpeed);
        if (rotationSpeed != null) _rotationSpeed = rotationSpeed;
      });
    };

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30),
    )
      ..addListener(() {
        if (mounted) {
          setState(() {
            _updateObjects();
          });
        }
      })
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFallObjects();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Loads an image from the asset bundle.
  Future<ui.Image> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = Uint8List.view(data.buffer);
    return await decodeImageFromList(bytes);
  }

  /// Initializes the falling objects (particles).
  Future<void> _initFallObjects() async {
    for (int i = 0; i < _totalObjects; i++) {
      _fallingObjects.add(await _createFallObject());
    }
  }

  /// Creates a new falling object with random properties.
  Future<FallObject> _createFallObject() async {
    final double density = Random().nextDouble() * _speed;
    final double x = Random().nextDouble() * MediaQuery.of(context).size.width;
    final double y =
        widget.startFromTop ? -Random().nextDouble() * MediaQuery.of(context).size.height : Random().nextDouble() * MediaQuery.of(context).size.height;

    // Check if using emojis or images
    String imageUrl;
    ui.Image image;
    if (widget.useEmojis == true) {
      // Use random emoji
      imageUrl = widget.emojiList![Random().nextInt(widget.emojiList!.length)];
      image = await _loadEmoji(imageUrl); // Custom method to load emoji
    } else {
      // Use random image
      imageUrl = widget.particleImages[Random().nextInt(widget.particleImages.length)];
      image = await _loadImage(imageUrl);
    }

    final double size = _particleSize * (0.1 + Random().nextDouble() * 0.4);
    final double rotation = Random().nextDouble() * 2 * pi;
    final double wind = (Random().nextDouble() * 2 - 1) * _windSpeed;

    return FallObject(
      x: x,
      y: y,
      size: size,
      density: density,
      image: image,
      rotation: rotation,
      wind: wind,
    );
  }

  /// Loads an emoji as an image.
  Future<ui.Image> _loadEmoji(String emoji) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder, Rect.fromPoints(Offset(0, 0), Offset(100, 100)));
    final textStyle = TextStyle(fontSize: 40, color: Colors.black);
    final textSpan = TextSpan(text: emoji, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, Offset(0, 0));
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(100, 100);
    return img;
  }

  /// Updates the total number of falling objects.
  void _updateTotalObjects(int newTotal) async {
    if (newTotal > _fallingObjects.length) {
      for (int i = 0; i < newTotal - _fallingObjects.length; i++) {
        _fallingObjects.add(await _createFallObject());
      }
    } else if (newTotal < _fallingObjects.length) {
      _fallingObjects.removeRange(newTotal, _fallingObjects.length);
    }
    _totalObjects = newTotal;
  }

  /// Updates the size of the particles.
  void _updateParticleSize(double newSize) {
    setState(() {
      _particleSize = newSize;
      for (var obj in _fallingObjects) {
        obj.size = newSize * (0.1 + Random().nextDouble() * 0.4);
      }
    });
  }

  /// Updates the wind speed of the particles.
  void _updateWindSpeed(double newWindSpeed) {
    setState(() {
      _windSpeed = newWindSpeed;
      for (var obj in _fallingObjects) {
        obj.wind = (Random().nextDouble() * 2 - 1) * _windSpeed;
      }
    });
  }

  /// Updates the position and properties of the falling particles.
  void _updateObjects() {
    for (FallObject obj in _fallingObjects) {
      obj.y += (cos(obj.density) + obj.size).abs() * _speed;
      obj.x += sin(obj.density + obj.wind) * _speed;

      obj.rotation += _rotationSpeed * 0.05;
      obj.x += sin(obj.wind) * 0.5;

      if (obj.x > MediaQuery.of(context).size.width + obj.size || obj.x < -obj.size || obj.y > MediaQuery.of(context).size.height + obj.size) {
        obj.x = Random().nextDouble() * MediaQuery.of(context).size.width;
        obj.y = -obj.size;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: widget.isRunning,
      isComplex: true,
      size: Size.infinite,
      painter: FallPainter(
        isRunning: widget.isRunning,
        particles: _fallingObjects,
      ),
    );
  }
}
