import 'package:flutter/material.dart';

import '../state/inventario_scope.dart';
import '../theme/app_colors.dart';
import '../widgets/campo_formulario.dart';

/// Formulario para registrar un nuevo producto en el inventario.
class NuevoScreen extends StatefulWidget {
  const NuevoScreen({super.key});

  @override
  State<NuevoScreen> createState() => _NuevoScreenState();
}

class _NuevoScreenState extends State<NuevoScreen> {
  static const _categorias = [
    'Tecnología',
    'Periféricos',
    'Accesorios',
    'Otros',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _stockMinimoController = TextEditingController();
  String? _categoria;

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  void _guardarProducto() {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Tras validar, los valores son numéricos y válidos.
    InventarioScope.read(context).agregarProducto(
      nombre: _nombreController.text,
      categoria: _categoria!,
      precio: _parsearPrecio(_precioController.text)!,
      cantidad: int.parse(_cantidadController.text.trim()),
      stockMinimo: int.parse(_stockMinimoController.text.trim()),
    );

    _formKey.currentState!.reset();
    setState(() => _categoria = null);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SelectorFoto(),
            const SizedBox(height: 16),
            CampoFormulario(
              controller: _nombreController,
              labelText: 'Nombre del producto *',
              hintText: 'Ej: Teclado mecánico',
              validator: _validarObligatorio,
            ),
            const SizedBox(height: 14),
            const EtiquetaCampo('Categoría *'),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              dropdownColor: AppColors.tarjeta,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textoSecundario,
              ),
              decoration: const InputDecoration(
                hintText: 'Seleccionar categoría',
              ),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: [
                for (final c in _categorias)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (valor) => setState(() => _categoria = valor),
              validator: (valor) =>
                  valor == null ? 'Selecciona una categoría' : null,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CampoFormulario(
                    controller: _precioController,
                    labelText: 'Precio *',
                    hintText: r'$0',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validarPrecio,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CampoFormulario(
                    controller: _cantidadController,
                    labelText: 'Cantidad inicial *',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: _validarEnteroNoNegativo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CampoFormulario(
              controller: _stockMinimoController,
              labelText: 'Stock mínimo *',
              hintText: 'Cantidad mínima de alerta',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: _validarEnteroNoNegativo,
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _guardarProducto,
              child: const Text('Guardar producto'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recuadro para la foto del producto (según mockup).
class _SelectorFoto extends StatelessWidget {
  const _SelectorFoto();

  @override
  Widget build(BuildContext context) {
    // TODO: abrir cámara / galería al tocar.
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.campo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bordeBoton, width: 1.2),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 38, color: AppColors.textoTenue),
          SizedBox(height: 8),
          Text(
            'Tomar foto o elegir de galería',
            style: TextStyle(color: AppColors.textoSecundario, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Acepta coma o punto como separador decimal (ej. `2,5` o `2.5`).
double? _parsearPrecio(String texto) =>
    double.tryParse(texto.trim().replaceAll(',', '.'));

String? _validarObligatorio(String? valor) =>
    (valor == null || valor.trim().isEmpty) ? 'Campo obligatorio' : null;

String? _validarPrecio(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'Obligatorio';
  final precio = _parsearPrecio(valor);
  if (precio == null || precio <= 0) return 'Mayor a 0';
  return null;
}

String? _validarEnteroNoNegativo(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'Obligatorio';
  final numero = int.tryParse(valor.trim());
  if (numero == null || numero < 0) return '≥ 0';
  return null;
}
