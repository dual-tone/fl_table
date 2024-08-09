import 'package:flutter/material.dart';

class FlTablePagination {
  bool? enabled;
  List<int>? pageSizes;
  int? selectedPageSize;
  MainAxisAlignment? position;
  int? rowsPerPage;

  // For asynchronous feature
  bool? asynchronous;
  int? totalRows;
  int? currentPage;

  FlTablePagination({
    this.asynchronous,
    this.enabled,
    this.pageSizes,
    this.selectedPageSize,
    this.totalRows,
    this.position,
    this.rowsPerPage,
    this.currentPage,
  });

  get totalPages => (totalRows! / selectedPageSize!).ceil();
  get canGoBack => currentPage! > 1;
  get canGoForward => currentPage! < totalPages;

  copyWith({
    bool? enabled,
    List<int>? pageSizes,
    MainAxisAlignment? position,
    int? rowsPerPage,
    int? selectedPageSize,
    bool? asynchronous,
    int? totalRows,
    int? currentPage,
  }) {
    return FlTablePagination(
      enabled: enabled ?? this.enabled,
      pageSizes: pageSizes ?? this.pageSizes,
      position: position ?? this.position,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      asynchronous: asynchronous ?? this.asynchronous,
      totalRows: totalRows ?? this.totalRows,
      currentPage: currentPage ?? this.currentPage,
      selectedPageSize: selectedPageSize ?? this.selectedPageSize,
    );
  }

  @override
  String toString() {
    return "Enabled: $enabled, Selected page size: $selectedPageSize";
  }

}
