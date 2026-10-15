/// Representa un producto individual dentro del inventario.
///
/// Es inmutable: para cambiar el stock se crea una copia con [copyWith].
class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.cantidad,
    this.stockMinimo = 5,
  });

  final String id;
  final String nombre;
  final String categoria;
  final double precio;
  final int cantidad;
  final int stockMinimo;

  /// `true` si la cantidad está en o por debajo del stock mínimo.
  bool get stockBajo => cantidad <= stockMinimo;

  Producto copyWith({
    String? nombre,
    String? categoria,
    double? precio,
    int? cantidad,
    int? stockMinimo,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
      stockMinimo: stockMinimo ?? this.stockMinimo,
    );
  }
}
