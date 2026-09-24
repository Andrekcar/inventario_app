import 'package:flutter/material.dart';

// Pantalla de Nuevo Producto - muestra contenido placeholder
class NuevoScreen extends StatelessWidget {
  const NuevoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nuevo producto',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
