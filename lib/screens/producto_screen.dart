import 'package:flutter/material.dart';

// Pantalla de Productos - muestra contenido placeholder
class ProductoScreen extends StatelessWidget {
  const ProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Productos',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
