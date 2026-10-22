import 'package:flutter/material.dart';

import '../state/inventario_scope.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';

const _secundario = TextStyle(color: AppColors.textoSecundario, fontSize: 13);

/// Pantalla de Reportes: resumen del inventario actual y productos con
/// stock bajo. La exportación a PDF queda para una fase posterior.
class ReporteScreen extends StatelessWidget {
  const ReporteScreen({super.key});

  void _avisarPdfPendiente(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('La exportación a PDF llegará en una próxima fase'),
          backgroundColor: AppColors.bordeTarjeta,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // `of` suscribe esta pantalla: el resumen se recalcula con cada cambio.
    final inventario = InventarioScope.of(context);
    final stockBajo = inventario.productos.where((p) => p.stockBajo).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _TarjetaReporte(onGenerarPdf: () => _avisarPdfPendiente(context)),
        const _Titulo('Resumen del inventario'),
        _TarjetaLista([
          _Fila('Productos registrados', '${inventario.totalProductos}'),
          _Fila('Unidades en stock', '${inventario.totalUnidades}'),
          _Fila('Valor total', formatearPrecio(inventario.valorTotal)),
          _Fila(
            'Productos con stock bajo',
            '${stockBajo.length}',
            color: stockBajo.isEmpty ? null : AppColors.error,
          ),
        ]),
        const _Titulo('Alerta de stock bajo'),
        if (stockBajo.isEmpty)
          const Text(
            'Ningún producto está en su stock mínimo',
            style: TextStyle(color: AppColors.textoTenue, fontSize: 13),
          )
        else
          _TarjetaLista([
            for (final p in stockBajo)
              ListTile(
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.ambar,
                  semanticLabel: 'Stock bajo',
                ),
                title: Text(
                  p.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${p.cantidad} uds (mín. ${p.stockMinimo})',
                  style: _secundario,
                ),
              ),
          ]),
      ],
    );
  }
}

/// Tarjeta superior del mockup: ícono, título, descripción y botón.
/// El botón toma su estilo del tema (AppTheme.elevatedButtonTheme).
class _TarjetaReporte extends StatelessWidget {
  const _TarjetaReporte({required this.onGenerarPdf});

  final VoidCallback onGenerarPdf;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 40,
              color: AppColors.ambar,
            ),
            const Text(
              'Reporte de inventario actual',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Genera un reporte del inventario actual y expórtalo o '
              'compártelo en formato PDF.',
              textAlign: TextAlign.center,
              style: _secundario,
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGenerarPdf,
                child: const Text('Generar PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Título pequeño que encabeza cada bloque de la pantalla.
class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: AppColors.textoEtiqueta,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Tarjeta que agrupa filas separadas por una línea fina.
class _TarjetaLista extends StatelessWidget {
  const _TarjetaLista(this.filas);

  final List<Widget> filas;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          color: AppColors.bordeTarjeta,
          tiles: filas,
        ).toList(),
      ),
    );
  }
}

/// Fila "etiqueta ........ valor" del resumen.
class _Fila extends StatelessWidget {
  const _Fila(this.etiqueta, this.valor, {this.color});

  final String etiqueta;
  final String valor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(etiqueta, style: _secundario),
      trailing: Text(
        valor,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
