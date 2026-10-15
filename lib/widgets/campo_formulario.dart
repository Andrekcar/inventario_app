import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Etiqueta superior de un campo de formulario.
class EtiquetaCampo extends StatelessWidget {
  const EtiquetaCampo(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textoEtiqueta,
        ),
      ),
    );
  }
}

/// Campo de texto estilizado según el diseño de los mockups de InventarioX.
class CampoFormulario extends StatelessWidget {
  const CampoFormulario({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.prefixText,
    this.suffixText,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final String? prefixText;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaCampo(labelText),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            prefixStyle: const TextStyle(color: Colors.white70, fontSize: 14),
            suffixText: suffixText,
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 20, color: AppColors.textoSecundario),
          ),
        ),
      ],
    );
  }
}
