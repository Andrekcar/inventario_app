import 'package:flutter/material.dart';

// Importamos la pantalla de navegación principal
import 'screens/navegacion.dart';

// Punto de entrada de la aplicación Flutter
void main() => runApp(const MyApp());

// Widget raíz de la aplicación (StatelessWidget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura el tema y la ruta inicial de la app
    return const MaterialApp(home: Navegacion());
  }
}
