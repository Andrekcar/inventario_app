import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/movimiento.dart';
import '../models/producto.dart';

/// Gestión centralizada del estado del inventario.
///
/// Hereda de [ChangeNotifier] para notificar a los widgets que escuchan
/// cada vez que se agrega o modifica un producto o movimiento.
/// Se expone a la app mediante `InventarioScope`.
class InventarioState extends ChangeNotifier {
  final List<Producto> _productos = [];
  final List<Movimiento> _movimientos = [];
  int _contadorId = 0;

  /// ID único: marca de tiempo + contador (dos altas en el mismo milisegundo no chocan).
  String _nuevoId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${_contadorId++}';

  /// Productos registrados (vista de solo lectura).
  UnmodifiableListView<Producto> get productos =>
      UnmodifiableListView(_productos);

  /// Movimientos históricos, el más reciente primero (vista de solo lectura).
  UnmodifiableListView<Movimiento> get movimientos =>
      UnmodifiableListView(_movimientos);

  /// Número de productos distintos.
  int get totalProductos => _productos.length;

  /// Suma de unidades de todos los productos.
  int get totalUnidades => _productos.fold(0, (total, p) => total + p.cantidad);

  /// Valor monetario total del inventario (precio × cantidad de cada producto).
  double get valorTotal =>
      _productos.fold(0, (total, p) => total + p.precio * p.cantidad);

  /// Registra un nuevo producto y, si tiene stock inicial, su movimiento de entrada.
  void agregarProducto({
    required String nombre,
    required String categoria,
    required double precio,
    required int cantidad,
    int stockMinimo = 5,
  }) {
    assert(precio >= 0 && cantidad >= 0 && stockMinimo >= 0);

    final producto = Producto(
      id: _nuevoId(),
      nombre: nombre.trim(),
      categoria: categoria.trim(),
      precio: precio,
      cantidad: cantidad,
      stockMinimo: stockMinimo,
    );
    _productos.add(producto);

    if (cantidad > 0) {
      _registrarMovimiento(producto, TipoMovimiento.entrada, cantidad);
    }

    notifyListeners();
  }

  /// Elimina un producto del inventario por su ID.
  void eliminarProducto(String id) {
    _productos.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Limpia todos los productos y movimientos del inventario.
  void vaciarInventario() {
    _productos.clear();
    _movimientos.clear();
    notifyListeners();
  }

  /// Suma o resta [delta] unidades al producto con [productoId] y registra el movimiento.
  ///
  /// Devuelve `false` si el producto no existe o si el stock quedaría negativo.
  bool ajustarStock(String productoId, int delta) {
    if (delta == 0) return false;

    final index = _productos.indexWhere((p) => p.id == productoId);
    if (index == -1) return false;

    final actual = _productos[index];
    final nuevoStock = actual.cantidad + delta;
    if (nuevoStock < 0) return false;

    _productos[index] = actual.copyWith(cantidad: nuevoStock);
    _registrarMovimiento(
      actual,
      delta > 0 ? TipoMovimiento.entrada : TipoMovimiento.salida,
      delta.abs(),
    );

    notifyListeners();
    return true;
  }

  void _registrarMovimiento(
    Producto producto,
    TipoMovimiento tipo,
    int cantidad,
  ) {
    _movimientos.insert(
      0,
      Movimiento(
        id: 'mov_${_nuevoId()}',
        productoId: producto.id,
        productoNombre: producto.nombre,
        tipo: tipo,
        cantidad: cantidad,
        fecha: DateTime.now(),
      ),
    );
  }
}
