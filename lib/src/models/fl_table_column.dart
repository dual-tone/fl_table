import 'package:flutter/material.dart';

enum FlTableColumnFixedPosition { leading, trailing }

class FlTableColumn {
  final String key;
  final String label;
  final FlTableColumnFixedPosition? fixed;
  final int? widthInPercentage;
  final double? width;
  final Alignment? headerTitleAlignment;

  FlTableColumn({
    required this.key,
    required this.label,
    this.fixed,
    this.widthInPercentage,
    this.width,
    this.headerTitleAlignment,
  });
}
