import 'package:flutter/material.dart';

// Importamos las pantallas que se mostrarán en cada pestaña
import 'historial_screen.dart';
import 'nuevo_screen.dart';
import 'producto_screen.dart';
import 'inicio_screen.dart';
import 'reporte_screen.dart';

// Widget principal que gestiona la navegación con BottomNavigationBar
class Navegacion extends StatefulWidget {
  const Navegacion({super.key});

  @override
  State<Navegacion> createState() => _NavegacionState();
}

// Estado del widget Navegacion
class _NavegacionState extends State<Navegacion> {
  // Índice de la pestaña seleccionada actualmente (0 = Inicio)
  int _selectedIndex = 0;

  // Lista de pantallas disponibles en la navegación
  // El orden coincide con el orden de los ítems en BottomNavigationBar
  final List<Widget> _widgetOptions = <Widget>[
    const InicioScreen(),     // Índice 0: Inicio
    const ProductoScreen(),   // Índice 1: Productos
    const NuevoScreen(),      // Índice 2: Nuevo
    const HistorialScreen(),  // Índice 3: Historial
    const ReporteScreen(),    // Índice 4: Reportes
  ];

  // Método que actualiza el índice seleccionado al tocar un ítem
  // setState() notifica al framework que el estado ha cambiado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold estructura la pantalla con AppBar, body y BottomNavigationBar
    return Scaffold(
      // AppBar muestra el título de la aplicación
      appBar: AppBar(title: const Text('Inventario App')),

      // body muestra la pantalla correspondiente al índice seleccionado
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      // BottomNavigationBar: barra de navegación inferior con 5 ítems
      bottomNavigationBar: BottomNavigationBar(
        // type.fixed permite que todos los labels sean visibles siempre
        type: BottomNavigationBarType.fixed,

        // Definición de los 5 ítems de navegación
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Productos'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Nuevo'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Reportes'),
        ],

        // Índice del ítem actualmente seleccionado
        currentIndex: _selectedIndex,

        // Color del ítem seleccionado (amarillo/dorado)
        selectedItemColor: Colors.amber[800],

        // Color de los ítems no seleccionados (gris)
        unselectedItemColor: Colors.grey,

        // Callback que se ejecuta al tocar un ítem
        onTap: _onItemTapped,
      ),
    );
  }
}
