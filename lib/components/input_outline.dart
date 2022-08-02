import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class InputOutline extends StatelessWidget {
  const InputOutline({
    Key? key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number
          ? [
              CurrencyTextInputFormatter(
                locale: 'pt_BR',
                name: '',
              )
            ]
          : [],
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(prefixIcon),
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: .5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: .5,
          ),
        ),
        focusColor: Theme.of(context).primaryColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: .5,
          ),
        ),
      ),
    );
  }
}
