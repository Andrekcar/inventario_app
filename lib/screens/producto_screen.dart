import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../state/inventario_scope.dart';
import '../theme/app_colors.dart';
import '../utils/formato.dart';

/// Pantalla de Productos.
/// Muestra las tarjetas de productos con botones + y - para ajustar stock.
class ProductoScreen extends StatelessWidget {
  const ProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `of` suscribe esta pantalla a los cambios del inventario.
    final productos = InventarioScope.of(context).productos;

    if (productos.isEmpty) return const _EstadoVacio();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: productos.length,
      itemBuilder: (_, i) {
        final producto = productos[i];
        return _TarjetaProducto(key: ValueKey(producto.id), producto: producto);
      },
    );
  }
}

/// Mensaje que se muestra cuando el inventario no tiene productos.
class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.textoTenue,
          ),
          SizedBox(height: 12),
          Text(
            'No hay productos en el inventario',
            style: TextStyle(
              color: AppColors.textoSecundario,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Agrega tu primer producto desde la pestaña "Nuevo"',
            style: TextStyle(color: AppColors.textoTenue, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de un producto ícono, datos y botones de acción.
class _TarjetaProducto extends StatelessWidget {
  const _TarjetaProducto({super.key, required this.producto});

  final Producto producto;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.tarjeta,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bordeTarjeta),
      ),
      child: Row(
        children: [
          // Espacio reservado para la imagen del producto (vacío por ahora).
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.avatar,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${producto.categoria} · ${producto.cantidad} uds',
                  style: const TextStyle(
                    color: AppColors.textoSecundario,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatearPrecio(producto.precio),
                  style: const TextStyle(
                    color: AppColors.ambar,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _AccionesProducto(producto: producto),
        ],
      ),
    );
  }
}

/// Botones + / - para el stock, y editar / borrar.
class _AccionesProducto extends StatelessWidget {
  const _AccionesProducto({required this.producto});

  final Producto producto;

  void _eliminar(BuildContext context) {
    InventarioScope.read(context).eliminarProducto(producto.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${producto.nombre} eliminado'),
          backgroundColor: AppColors.bordeTarjeta,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final inventario = InventarioScope.read(context);
    final puedeRestar = producto.cantidad > 0;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BotonStock(
              icono: Icons.remove,
              tooltip: 'Restar una unidad',
              fondo: AppColors.bordeTarjeta,
              colorIcono: puedeRestar ? Colors.white : AppColors.textoTenue,
              onTap: puedeRestar
                  ? () => inventario.ajustarStock(producto.id, -1)
                  : null,
            ),
            const SizedBox(width: 6),
            _BotonStock(
              icono: Icons.add,
              tooltip: 'Sumar una unidad',
              fondo: AppColors.ambar,
              colorIcono: Colors.black,
              onTap: () => inventario.ajustarStock(producto.id, 1),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BotonCircular(
              icono: Icons.delete_outline,
              tooltip: 'Eliminar',
              onTap: () => _eliminar(context),
            ),
          ],
        ),
      ],
    );
  }
}

/// Botón cuadrado pequeño para sumar o restar stock.
class _BotonStock extends StatelessWidget {
  const _BotonStock({
    required this.icono,
    required this.tooltip,
    required this.fondo,
    required this.colorIcono,
    this.onTap,
  });

  final IconData icono;
  final String tooltip;
  final Color fondo;
  final Color colorIcono;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Material + InkWell para que el efecto de toque se vea sobre el fondo.
    return Tooltip(
      message: tooltip,
      child: Material(
        color: fondo,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icono, size: 16, color: colorIcono),
          ),
        ),
      ),
    );
  }
}

/// Botón circular con borde (editar / borrar).
class _BotonCircular extends StatelessWidget {
  const _BotonCircular({
    required this.icono,
    required this.tooltip,
    this.onTap,
  });

  final IconData icono;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bordeBoton),
          ),
          child: Icon(icono, size: 16, color: AppColors.textoSecundario),
        ),
      ),
    );
  }
}
