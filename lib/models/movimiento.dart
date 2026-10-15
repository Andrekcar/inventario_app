/// Tipo de movimiento de inventario.
enum TipoMovimiento {
  entrada('Entrada'),
  salida('Salida');

  const TipoMovimiento(this.etiqueta);

  /// Texto a mostrar en la interfaz.
  final String etiqueta;
}

/// Representa una entrada o salida de inventario registrada en el sistema.
class Movimiento {
  const Movimiento({
    required this.id,
    required this.productoId,
    required this.productoNombre,
    required this.tipo,
    required this.cantidad,
    required this.fecha,
  });

  final String id;
  final String productoId;

  /// Nombre al momento del movimiento (se conserva aunque el producto se elimine).
  final String productoNombre;
  final TipoMovimiento tipo;
  final int cantidad;
  final DateTime fecha;
}
