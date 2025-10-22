import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormationsPage extends ConsumerWidget {
  const FormationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formations')),
      body: const Center(child: Text('Formations Page - Coming Soon')),
    );
  }
}
