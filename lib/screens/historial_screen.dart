import 'package:flutter/material.dart';

import '../models/movimiento.dart';
import '../state/inventario_scope.dart';
import '../theme/app_colors.dart';

const _secundario = TextStyle(color: AppColors.textoSecundario, fontSize: 12);

/// Pantalla de Historial: entradas y salidas de stock (solo consulta).
/// Los movimientos los crean los botones + y - de Productos.
class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    // `of` suscribe esta pantalla: cada movimiento nuevo la reconstruye.
    final todos = InventarioScope.of(context).movimientos;
    if (todos.isEmpty) return const _EstadoVacio();

    final consulta = _busqueda.trim().toLowerCase();
    final movimientos = todos
        .where((m) => m.productoNombre.toLowerCase().contains(consulta))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          // El estilo del campo sale del tema (AppTheme.inputDecorationTheme).
          child: TextField(
            onChanged: (valor) => setState(() => _busqueda = valor),
            decoration: const InputDecoration(
              hintText: 'Buscar en movimientos...',
              prefixIcon: Icon(Icons.search, color: AppColors.textoSecundario),
            ),
          ),
        ),
        Expanded(
          child: movimientos.isEmpty
              ? const Center(child: Text('Sin resultados', style: _secundario))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        // Pone una línea fina entre cada fila.
                        children: ListTile.divideTiles(
                          context: context,
                          color: AppColors.bordeTarjeta,
                          tiles: [
                            for (final m in movimientos) _FilaMovimiento(m),
                          ],
                        ).toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Mensaje que se muestra cuando todavía no hay movimientos.
class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Icon(Icons.access_time, size: 64, color: AppColors.textoTenue),
          Text(
            'Aún no hay movimientos',
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Aquí aparecerán las entradas y salidas de stock',
            style: TextStyle(color: AppColors.textoTenue, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Fila de un movimiento: ícono de entrada/salida, producto, fecha y cantidad.
class _FilaMovimiento extends StatelessWidget {
  const _FilaMovimiento(this.movimiento);

  final Movimiento movimiento;

  @override
  Widget build(BuildContext context) {
    final esEntrada = movimiento.tipo == TipoMovimiento.entrada;
    // Entrada en ámbar, salida en rojo (como en el mockup).
    final color = esEntrada ? AppColors.ambar : AppColors.error;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          esEntrada ? Icons.arrow_downward : Icons.arrow_upward,
          size: 18,
          color: color,
          // Texto que leen los lectores de pantalla (accesibilidad).
          semanticLabel: movimiento.tipo.etiqueta,
        ),
      ),
      title: Text(
        movimiento.productoNombre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_formatearFecha(movimiento.fecha), style: _secundario),
      trailing: Text(
        '${esEntrada ? '+' : '−'}${movimiento.cantidad}',
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun', //
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

/// Devuelve la fecha como `21 sep 2026, 10:30` (sin paquetes externos).
String _formatearFecha(DateTime f) {
  final hora = f.hour.toString().padLeft(2, '0');
  final minuto = f.minute.toString().padLeft(2, '0');
  return '${f.day} ${_meses[f.month - 1]} ${f.year}, $hora:$minuto';
}
