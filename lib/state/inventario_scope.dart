import 'package:flutter/widgets.dart';

import 'inventario.dart';

/// Pone un [InventarioState] a disposición del árbol de widgets.
///
/// - [InventarioScope.of] se suscribe a los cambios (usar dentro de `build`).
/// - [InventarioScope.read] no se suscribe (usar en callbacks como `onTap`).
class InventarioScope extends InheritedNotifier<InventarioState> {
  const InventarioScope({
    super.key,
    required InventarioState inventario,
    required super.child,
  }) : super(notifier: inventario);

  static InventarioState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<InventarioScope>();
    assert(scope != null, 'No hay un InventarioScope en el árbol de widgets.');
    return scope!.notifier!;
  }

  static InventarioState read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<InventarioScope>();
    assert(scope != null, 'No hay un InventarioScope en el árbol de widgets.');
    return scope!.notifier!;
  }
}
