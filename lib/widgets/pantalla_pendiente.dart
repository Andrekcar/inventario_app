import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Contenido provisional para secciones que aún no están implementadas.
class PantallaPendiente extends StatelessWidget {
  const PantallaPendiente({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Próximamente',
            style: TextStyle(color: AppColors.textoSecundario),
          ),
        ],
      ),
    );
  }
}
