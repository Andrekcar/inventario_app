import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'historial_screen.dart';
import 'inicio_screen.dart';
import 'nuevo_screen.dart';
import 'producto_screen.dart';
import 'reporte_screen.dart';

/// Datos de cada pestaña de la barra inferior.
class _Seccion {
  const _Seccion({
    required this.titulo,
    required this.etiqueta,
    required this.icono,
    required this.pantalla,
  });

  final String titulo;
  final String etiqueta;
  final IconData icono;
  final Widget pantalla;
}

const _secciones = <_Seccion>[
  _Seccion(
    titulo: 'Inicio',
    etiqueta: 'Inicio',
    icono: Icons.home_outlined,
    pantalla: InicioScreen(),
  ),
  _Seccion(
    titulo: 'Productos',
    etiqueta: 'Productos',
    icono: Icons.hexagon_outlined,
    pantalla: ProductoScreen(),
  ),
  _Seccion(
    titulo: 'Nuevo producto',
    etiqueta: 'Nuevo',
    icono: Icons.add_circle_outline,
    pantalla: NuevoScreen(),
  ),
  _Seccion(
    titulo: 'Historial',
    etiqueta: 'Historial',
    icono: Icons.access_time,
    pantalla: HistorialScreen(),
  ),
  _Seccion(
    titulo: 'Reportes',
    etiqueta: 'Reportes',
    icono: Icons.description_outlined,
    pantalla: ReporteScreen(),
  ),
];

const _indiceProductos = 1;

/// Estructura principal de la app: AppBar + pestañas con BottomNavigationBar.
class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  /// Arrancamos en Productos, como en el mockup.
  int _indice = _indiceProductos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_secciones[_indice].titulo)),
      // IndexedStack conserva el estado de cada pestaña (p. ej. el formulario a medio llenar).
      body: SafeArea(
        child: IndexedStack(
          index: _indice,
          children: [for (final s in _secciones) s.pantalla],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.bordeNavegacion)),
        ),
        // Sin efecto de onda al tocar las pestañas.
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _indice,
            onTap: (i) => setState(() => _indice = i),
            items: [
              for (final s in _secciones)
                BottomNavigationBarItem(icon: Icon(s.icono), label: s.etiqueta),
            ],
          ),
        ),
      ),
    );
  }
}
