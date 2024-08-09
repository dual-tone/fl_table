import 'package:flutter/cupertino.dart';

class FlTableStyle {
  final EdgeInsets? cellPadding;
  final double? rowHeight;
  final Color? borderColor;
  final Color? alternateRowColor;
  final bool? showAlternateRowColor;

  FlTableStyle({
    this.cellPadding,
    this.rowHeight,
    this.borderColor,
    this.alternateRowColor,
    this.showAlternateRowColor,
  });
}
