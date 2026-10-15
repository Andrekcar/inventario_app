final _separadorMiles = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

/// formatemos con separador de miles (ej. `$2.500,50`).
String formatearPrecio(double precio) {
  final partes = precio.toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(_separadorMiles, (m) => '${m[1]}.');
  final decimales = partes[1];
  return decimales == '00' ? '\$$entero' : '\$$entero,$decimales';
}
