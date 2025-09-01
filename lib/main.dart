import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashlight App',
      theme: ThemeData.dark(),
      home: const FlashLightScreen(),
    );
  }
}

class FlashLightScreen extends StatefulWidget {
  const FlashLightScreen({super.key});

  @override
  State<FlashLightScreen> createState() => _FlashLightScreenState();
}

class _FlashLightScreenState extends State<FlashLightScreen>
    with SingleTickerProviderStateMixin {
  bool isOn = false;
  double shakeThreshold = 15.0;
  DateTime lastShake = DateTime.now();

  @override
  void initState() {
    super.initState();

    // Shake detection
    accelerometerEvents.listen((event) {
      double totalAcceleration =
      sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      final now = DateTime.now();
      if (totalAcceleration > shakeThreshold &&
          now.difference(lastShake).inMilliseconds > 1000) {
        lastShake = now;
        _toggleTorch();
      }
    });
  }

  Future<void> _toggleTorch() async {
    try {
      if (isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 200);
        }
      }
      setState(() {
        isOn = !isOn;
      });
    } on Exception catch (e) {
      debugPrint("Torch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                height: isOn ? 240 : 180,
                width: isOn ? 240 : 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  isOn ? Colors.yellowAccent.withOpacity(0.3) : Colors.grey.shade800,
                  boxShadow: isOn
                      ? [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.8),
                      blurRadius: 50,
                      spreadRadius: 25,
                    ),
                  ]
                      : [],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(120),
                  onTap: _toggleTorch,
                  child: Center(
                    child: Icon(
                      isOn ? Icons.flashlight_on : Icons.flashlight_off,
                      size: 100,
                      color: isOn ? Colors.yellow : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Text(
                isOn ? "Flashlight ON" : "Flashlight OFF",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Shake your phone to toggle",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
