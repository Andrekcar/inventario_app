import 'package:flutter/material.dart';

import 'screens/navegacion.dart';
import 'state/inventario.dart';
import 'state/inventario_scope.dart';
import 'theme/app_theme.dart';

void main() => runApp(MyApp(inventario: InventarioState()));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.inventario});

  final InventarioState inventario;

  @override
  Widget build(BuildContext context) {
    return InventarioScope(
      inventario: inventario,
      child: MaterialApp(
        title: 'InventarioX',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.oscuro,
        home: const Navegacion(),
      ),
    );
  }
}
