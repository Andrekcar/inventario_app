import 'package:flutter/material.dart';

import '../state/inventario_scope.dart';
import '../theme/app_colors.dart';
import 'historial_screen.dart';
import 'nuevo_screen.dart';
import 'producto_screen.dart';
import 'reporte_screen.dart';

/// Pantalla de Inicio: totales del inventario y accesos a las demás pantallas.
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  /// Abre [pantalla] en una ruta nueva (con su AppBar y flecha de regreso).
  void _abrir(BuildContext context, String titulo, Widget pantalla) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(titulo)),
          body: SafeArea(child: pantalla),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // `of` suscribe esta pantalla: los totales se actualizan solos.
    final inventario = InventarioScope.of(context);
    final stockBajo = inventario.productos.where((p) => p.stockBajo).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(child: _Dato('${inventario.totalProductos}', 'Productos')),
            Expanded(child: _Dato('${inventario.totalUnidades}', 'Unidades')),
            Expanded(
              child: _Dato('$stockBajo', 'Stock bajo', alerta: stockBajo > 0),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          // Dentro de un scroll: ocupa solo su alto y no hace scroll propio.
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _Acceso(
              Icons.add_circle_outline,
              'Nuevo producto',
              () => _abrir(context, 'Nuevo producto', const NuevoScreen()),
            ),
            _Acceso(
              Icons.inventory_2_outlined,
              'Productos',
              () => _abrir(context, 'Productos', const ProductoScreen()),
            ),
            _Acceso(
              Icons.access_time,
              'Movimientos',
              () => _abrir(context, 'Historial', const HistorialScreen()),
            ),
            _Acceso(
              Icons.description_outlined,
              'Reportes',
              () => _abrir(context, 'Reportes', const ReporteScreen()),
            ),
          ],
        ),
      ],
    );
  }
}

/// Tarjeta con un número grande y su etiqueta (ej. 24 / Productos).
/// `Card` ya toma color, borde y esquinas del tema (AppTheme.cardTheme).
class _Dato extends StatelessWidget {
  const _Dato(this.valor, this.etiqueta, {this.alerta = false});

  final String valor;
  final String etiqueta;
  final bool alerta;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$etiqueta: $valor',
      excludeSemantics: true,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                valor,
                style: TextStyle(
                  color: alerta ? AppColors.error : AppColors.ambar,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                etiqueta,
                style: const TextStyle(
                  color: AppColors.textoSecundario,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón grande con ícono y texto para ir a otra pantalla.
class _Acceso extends StatelessWidget {
  const _Acceso(this.icono, this.texto, this.onTap);

  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      // Recorta el efecto de toque a las esquinas redondeadas de la tarjeta.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Icon(icono, size: 30, color: AppColors.ambar),
            Text(
              texto,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
