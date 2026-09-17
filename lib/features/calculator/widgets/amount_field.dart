import 'package:flutter/material.dart';

import '../../../domain/format.dart';
import '../../../shared/formatting/thousands_separator_input_formatter.dart';

class AmountField extends StatefulWidget {
  final String label;
  final String initialRawInput;
  final bool isOverLimit;
  final int maxAmount;
  final ValueChanged<String> onChanged;

  const AmountField({
    super.key,
    required this.label,
    required this.initialRawInput,
    required this.isOverLimit,
    required this.maxAmount,
    required this.onChanged,
  });

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialRawInput);
  }

  @override
  void didUpdateWidget(covariant AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRawInput != _controller.text &&
        widget.initialRawInput != oldWidget.initialRawInput) {
      _controller.value = TextEditingValue(
        text: widget.initialRawInput,
        selection: TextSelection.collapsed(offset: widget.initialRawInput.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      onChanged: widget.onChanged,
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: 'Ar',
        errorText: widget.isOverLimit
            ? 'Plafond dépassé (max ${formatAriary(widget.maxAmount)})'
            : null,
      ),
    );
  }
}
