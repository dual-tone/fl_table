import 'dart:async';

import 'package:flutter/material.dart';

import 'fl_table_view.dart';
import 'models/fl_table_column.dart';
import 'models/fl_table_events.dart';
import 'models/fl_table_pagination.dart';
import 'models/fl_table_row.dart';
import 'models/fl_table_style.dart';

class FlTable extends StatefulWidget {
  final List<FlTableColumn> columns;
  final List<FlTableRow> rows;
  final List<Widget>? tableLeadingActions;
  final List<Widget>? tableTrailingActions;
  final FlTablePagination? pagination;
  final Set<String>? initialSelection;
  final FlTableStyle? tableStyle;
  final bool? selectable;
  final Widget? showLoader;
  final Function(ITableEvents)? onEvent;

  const FlTable({
    super.key,
    required this.columns,
    required this.rows,
    this.pagination,
    this.selectable,
    this.tableLeadingActions,
    this.tableTrailingActions,
    this.tableStyle,
    this.onEvent,
    this.showLoader,
    this.initialSelection,
  });

  @override
  State<FlTable> createState() => FlTableView();
}

abstract class FlTableState extends State<FlTable> {
  ScrollController tableHeaderScrollController = ScrollController();
  ScrollController tableBodyHorizontalScrollController = ScrollController();
  ScrollController tableBodyVerticalScrollController = ScrollController();
  ScrollController tableFixedColScrollController = ScrollController();

  final double checkboxColumnWidth = 53;
  double rowHeight = 45;
  double headerHeight = 45;
  EdgeInsets cellPadding = const EdgeInsets.symmetric(
    horizontal: 13,
  );
  Color borderColor = Colors.black38;
  Color? alternateRowColor;

  List<FlTableRow> _totalRows = [];
  List<FlTableRow> rows = [];
  StreamController<Set<String>> selectedStream =
      StreamController<Set<String>>.broadcast();
  StreamController<FlTablePagination> paginationStream =
      StreamController<FlTablePagination>.broadcast();

  Function(ITableEvents)? onEvent;

  @override
  void initState() {
    super.initState();

    // Synchronise the header and body scroll movement
    tableBodyHorizontalScrollController.addListener(() {
      tableHeaderScrollController.animateTo(
        tableBodyHorizontalScrollController.offset,
        duration: const Duration(milliseconds: 5),
        curve: Curves.linear,
      );
    });
    tableBodyVerticalScrollController.addListener(() {
      tableFixedColScrollController.animateTo(
        tableBodyVerticalScrollController.offset,
        duration: const Duration(milliseconds: 5),
        curve: Curves.linear,
      );
    });
  }

  configureTableDefaults() {
    rowHeight = widget.tableStyle?.rowHeight ?? rowHeight;
    cellPadding = widget.tableStyle?.cellPadding ?? cellPadding;
    borderColor = widget.tableStyle?.borderColor ?? borderColor;
    alternateRowColor = widget.tableStyle?.showAlternateRowColor == true
        ? (widget.tableStyle?.alternateRowColor ?? Colors.black12)
        : null;

    FlTablePagination p =
        (widget.pagination ?? FlTablePagination(enabled: false)).copyWith(
      position: widget.pagination?.position ?? MainAxisAlignment.end,
      pageSizes: widget.pagination?.pageSizes ?? [5, 25, 50],
      selectedPageSize: widget.pagination?.selectedPageSize ??
          widget.pagination?.pageSizes?.first ??
          5,
      rowsPerPage: widget.pagination?.rowsPerPage ?? 25,
      currentPage: 1,
      totalRows: widget.rows.length,
    );
    _totalRows = widget.rows;
    rows = widget.rows;

    if (p.enabled == true && p.asynchronous != true) {
      rows = _totalRows.take(p.selectedPageSize!).toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedStream.sink.add(widget.initialSelection ?? {});
      paginationStream.sink.add(p);
    });

    onEvent = widget.onEvent;
  }

  onSelectAll(bool val) {
    switch (val) {
      case true:
        Set<String> newSelection = rows.map((r) => r.id).toSet();
        selectedStream.sink.add(newSelection);

        if (onEvent != null) {
          onEvent!(FlTableOnSelection(selected: newSelection));
        }
        break;
      case false:
        selectedStream.sink.add({});
        if (onEvent != null) {
          onEvent!(FlTableOnSelection(selected: {}));
        }
        break;
    }
  }

  onSelection(Set<String> selection, String key, bool val) async {
    switch (val) {
      case true:
        selection.add(key);
        selectedStream.sink.add(selection);
        if (onEvent != null) {
          onEvent!(FlTableOnSelection(selected: selection));
        }
        break;
      case false:
        selection.remove(key);
        selectedStream.sink.add(selection);
        if (onEvent != null) {
          onEvent!(FlTableOnSelection(selected: selection));
        }
        break;
    }
  }

  onPaginationEvent(ITableEvents event) {
    late FlTablePagination pagination;

    if (event is FlTableOnGoOnePageBackward &&
        event.pagination.asynchronous == true) {
      pagination = event.pagination;
      emitPaginationEvent(event);
      return;
    }
    if (event is FlTableOnGoOnePageForward &&
        event.pagination.asynchronous == true) {
      pagination = event.pagination;
      emitPaginationEvent(event);
      return;
    }
    if (event is FlTableOnGoToFirstPage &&
        event.pagination.asynchronous == true) {
      pagination = event.pagination;
      emitPaginationEvent(event);
      return;
    }
    if (event is FlTableOnGoToLastPage &&
        event.pagination.asynchronous == true) {
      pagination = event.pagination;
      emitPaginationEvent(event);
      return;
    }
    if (event is FlTableOnPageSizeChange &&
        event.pagination.asynchronous == true) {
      pagination = event.pagination;
      emitPaginationEvent(event);
      return;
    }

    if (event is FlTableOnGoOnePageForward) {
      List<FlTableRow> r = _totalRows
          .skip(event.pagination.currentPage! *
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.currentPage! + 1,
      ));
    }
    if (event is FlTableOnGoOnePageBackward) {
      List<FlTableRow> r = _totalRows
          .skip(((event.pagination.currentPage! - 1) *
                  event.pagination.selectedPageSize!) -
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.currentPage! - 1,
      ));
    }
    if (event is FlTableOnGoToLastPage) {
      List<FlTableRow> r = _totalRows
          .skip((event.pagination.totalPages! - 1) *
              event.pagination.selectedPageSize!)
          .take(event.pagination.selectedPageSize!)
          .toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: event.pagination.totalPages!,
      ));
    }
    if (event is FlTableOnGoToFirstPage) {
      List<FlTableRow> r =
          _totalRows.take(event.pagination.selectedPageSize!).toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: 1,
      ));
    }
    if (event is FlTableOnPageSizeChange) {
      List<FlTableRow> r = _totalRows.take(event.selectedPageSize).toList();
      setState(() {
        rows = r;
      });
      paginationStream.sink.add(event.pagination.copyWith(
        currentPage: 1,
        selectedPageSize: event.selectedPageSize,
      ));
    }
  }

  emitPaginationEvent(ITableEvents event) {
    if (onEvent != null) {
      onEvent!(event);
      return;
    }

    debugPrint("Pagination event fired. No handler registered.");
  }

  calculateColumnWidth(FlTableColumn col, double availableWidth) =>
      col.widthInPercentage != null
          ? switch (col.widthInPercentage ?? 0) {
              > 0 => col.widthInPercentage! * (availableWidth / 100),
              _ => null,
            }
          : col.width != null
              ? switch (col.width ?? 0) {
                  > 0 => col.width!,
                  _ => null,
                }
              : null;
}
