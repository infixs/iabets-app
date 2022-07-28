import 'package:flutter/material.dart';

mixin CustomTheme {
  final InputDecoration textInputDecoration = InputDecoration(
    hintStyle: const TextStyle(color: Colors.black26),
    labelStyle: const TextStyle(color: Colors.black26),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
