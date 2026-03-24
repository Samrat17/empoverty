
import 'package:flutter/material.dart';
import 'customer_map_screen.dart';
import 'register_provider_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 96),
                const SizedBox(height: 24),
                const Text('Empoverty', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 48),
                FilledButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const RegisterProviderScreen())),
                  child: const Text('Join as Service Provider'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const CustomerMapScreen())),
                  child: const Text('Join as Customer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
