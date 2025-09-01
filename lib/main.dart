import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

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

  Future<void> _toggleTorch() async {
    try {
      if (isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
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
                height: isOn ? 220 : 180,
                width: isOn ? 220 : 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn ? Colors.yellowAccent.withOpacity(0.4) : Colors.grey.shade800,
                  boxShadow: isOn
                      ? [
                    BoxShadow(
                      color: Colors.yellowAccent.withOpacity(0.8),
                      blurRadius: 40,
                      spreadRadius: 20,
                    ),
                  ]
                      : [],
                ),
                child: IconButton(
                  iconSize: 100,
                  icon: Icon(
                    isOn ? Icons.flashlight_on : Icons.flashlight_off,
                    color: isOn ? Colors.yellow : Colors.white,
                  ),
                  onPressed: _toggleTorch,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                isOn ? "Flashlight ON" : "Flashlight OFF",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
