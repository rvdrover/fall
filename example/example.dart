import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutterfall/flutterfall.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FallController controller = FallController();

  // A list of emojis to use as falling particles
  final List<String> emojiList = ['❄️', '🍂', '🌸', '⭐', '🍁'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Falling particles (emoji-based)
            FlutterFall(
              particleImages: [], // Not needed for emoji usage
              emojiList: emojiList, // Passing emoji list
              totalParticles: 50,
              particleSize: 35,
              particleWindSpeed: 0.2,
              particleSpeed: 0.2,
              fallController: controller,
              isRunning: true,
              useEmojis: true, // Enable emoji particles
            ),
            // Sliders and Controls wrapped in a ListView for smooth scrolling
            Positioned(
              bottom: 20,
              left: 20,
              child: SizedBox(
                height: 400,
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView(
                  children: [
                    // Speed Slider
                    Row(
                      children: [
                        Text(
                          'Speed: ${controller.particleFallSpeed.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.particleFallSpeed,
                            min: 0.01,
                            max: 1.0,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                controller.updateParticleFallSpeed(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Particle Size Slider
                    Row(
                      children: [
                        Text(
                          'Particle Size: ${controller.particleSize.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.particleSize,
                            min: 10.0,
                            max: 100.0,
                            divisions: 90,
                            onChanged: (value) {
                              log(value.toString());
                              setState(() {
                                controller.updateParticleSize(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Total Objects Slider
                    Row(
                      children: [
                        Text(
                          'Total Particles: ${controller.totalParticles.toInt()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.totalParticles.toDouble(),
                            min: 10.0,
                            max: 500,
                            onChanged: (value) {
                              setState(() {
                                controller.updateTotalParticles(value.toInt());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Wind Speed Slider
                    Row(
                      children: [
                        Text(
                          'Wind Speed: ${controller.particleWindSpeed.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.particleWindSpeed,
                            min: 0.0,
                            max: 15.0,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                controller.updateParticleWindSpeed(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Rotation Speed Slider
                    Row(
                      children: [
                        Text(
                          'Rotation Speed: ${controller.particleRotationSpeed.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.particleRotationSpeed,
                            min: 0.0,
                            max: 10.0,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                controller.updateParticleRotationSpeed(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Toggle Emoji/Images
                    Row(
                      children: [
                        const Text(
                          'Use Emojis:',
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          value: true, // Always using emojis here
                          onChanged: (value) {
                            setState(() {
                              // You can toggle between emojis and images by updating `useEmojis` state.
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
