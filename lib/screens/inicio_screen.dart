import 'package:flutter/material.dart';

// Pantalla de Inicio - muestra contenido placeholder
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Inicio',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
