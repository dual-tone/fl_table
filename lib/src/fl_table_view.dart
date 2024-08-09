import 'package:flutter/material.dart';

import 'fl_table.dart';
import 'models/fl_table_column.dart';
import 'models/fl_table_events.dart';
import 'models/fl_table_row.dart';

class FlTableView extends FlTableState {
  Widget _buildSelectionCell({
    bool? showBorder,
    bool? showBackground,
    double? rowHeight,
    bool? selected,
    Function(bool)? onChange,
    bool? indeterminate,
  }) {
    return Container(
      height: rowHeight,
      width: checkboxColumnWidth,
      padding: cellPadding,
      decoration: BoxDecoration(
        color: showBackground == true ? alternateRowColor : null,
        border: showBorder == true
            ? Border(
                bottom: BorderSide(
                  color: borderColor,
                ),
              )
            : null,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: indeterminate == true ? null : selected ?? false,
          tristate: indeterminate == true,
          onChanged: (val) {
            if (onChange != null) onChange(val!);
          },
        ),
      ),
    );
  }

  List<Widget> _buildLeadingFixedHeaderColumn({
    required List<FlTableColumn> fixedLeadingColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return [
      widget.selectable == true
          ? StreamBuilder<Set<String>>(
              stream: selectedStream.stream,
              builder: (context, snapshot) {
                return _buildSelectionCell(
                  showBorder: true,
                  rowHeight: headerHeight,
                  indeterminate: (snapshot.data ?? {}).isNotEmpty &&
                      snapshot.data!.length < rows.length,
                  selected: snapshot.data?.length == rows.length,
                  onChange: onSelectAll,
                );
              },
            )
          : Container(),
      ...(fixedLeadingColumns.map((col) {
        double? calculatedWidth = calculateColumnWidth(col, availableWidth);

        return Container(
          height: headerHeight,
          width: calculatedWidth ?? defaultColumnWidth,
          padding: cellPadding,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          child: Align(
            alignment: col.headerTitleAlignment ?? Alignment.centerLeft,
            child: Text(
              col.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }))
    ];
  }

  _buildLeadingFixedBodyColumn({
    required List<FlTableColumn> fixedLeadingColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return [
      widget.selectable == true
          ? SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tableFixedColScrollController,
              scrollDirection: Axis.vertical,
              child: Wrap(
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                children: List.generate(rows.length, (i) {
                  FlTableRow row = rows[i];

                  return StreamBuilder<Set<String>>(
                    stream: selectedStream.stream,
                    builder: (context, snapshot) {
                      return _buildSelectionCell(
                        showBackground: i % 2 == 0,
                        rowHeight: rowHeight,
                        selected: snapshot.data?.contains(row.id),
                        onChange: (val) {
                          onSelection(snapshot.data ?? {}, row.id, val);
                        },
                      );
                    },
                  );
                }),
              ),
            )
          : Container(),
      ...(fixedLeadingColumns.map((col) {
        double? calculatedWidth = calculateColumnWidth(col, availableWidth);

        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tableFixedColScrollController,
          scrollDirection: Axis.vertical,
          child: Wrap(
            direction: Axis.vertical,
            children: List.generate(rows.length, (i) {
              FlTableRow currentRow = rows[i];

              return Container(
                height: rowHeight,
                width: calculatedWidth ?? defaultColumnWidth,
                color: i % 2 == 0 ? alternateRowColor : null,
                padding: cellPadding,
                child:
                    currentRow.cells.firstWhere((c) => c.key == col.key).cell,
              );
            }),
          ),
        );
      }))
    ];
  }

  _buildTrailingFixedHeaderColumn({
    required List<FlTableColumn> fixedTrailingColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return fixedTrailingColumns.map((col) {
      double? calculatedWidth = calculateColumnWidth(col, availableWidth);

      return Container(
        height: headerHeight,
        padding: cellPadding,
        width: calculatedWidth ?? defaultColumnWidth,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: borderColor,
            ),
          ),
        ),
        child: Align(
          alignment: col.headerTitleAlignment ?? Alignment.centerLeft,
          child: Text(
            col.label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

  _buildTrailingFixedBodyColumn({
    required List<FlTableColumn> fixedTrailingColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return fixedTrailingColumns.map((col) {
      double? calculatedWidth = calculateColumnWidth(col, availableWidth);

      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tableFixedColScrollController,
        scrollDirection: Axis.vertical,
        child: Wrap(
          direction: Axis.vertical,
          children: List.generate(rows.length, (i) {
            FlTableRow currentRow = rows[i];

            return Container(
              color: i % 2 == 0 ? alternateRowColor : null,
              padding: cellPadding,
              height: rowHeight,
              width: calculatedWidth ?? defaultColumnWidth,
              child: currentRow.cells.firstWhere((c) => c.key == col.key).cell,
            );
          }),
        ),
      );
    });
  }

  _buildHeaderColumn({
    required List<FlTableColumn> unfixedColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return unfixedColumns.map((col) {
      double? calculatedWidth = calculateColumnWidth(col, availableWidth);

      return Container(
        height: headerHeight,
        width: calculatedWidth ?? defaultColumnWidth,
        padding: cellPadding,
        child: Align(
          alignment: col.headerTitleAlignment ?? Alignment.centerLeft,
          child: Text(
            col.label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildBody({
    required List<FlTableColumn> unfixedColumns,
    required double availableWidth,
    double? defaultColumnWidth,
  }) {
    return List.generate(rows.length, (i) {
      FlTableRow row = rows[i];

      return Container(
        color: i % 2 == 0 ? alternateRowColor : null,
        child: Row(
          children: List.generate(unfixedColumns.length, (j) {
            FlTableColumn currentColumn = unfixedColumns[j];
            double? calculatedWidth =
                calculateColumnWidth(currentColumn, availableWidth);

            return Container(
              height: rowHeight,
              padding: cellPadding,
              width: calculatedWidth ?? defaultColumnWidth,
              child:
                  row.cells.firstWhere((c) => c.key == currentColumn.key).cell,
            );
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        configureTableDefaults();

        double defaultColumnWidth = widget.columns.length <= 4
            ? constraints.maxWidth / widget.columns.length
            : switch (constraints.maxWidth) {
                < 390 => constraints.maxWidth / 3,
                > 390 && <= 600 => constraints.maxWidth / 4,
                > 600 => constraints.maxWidth / 5,
                > 960 => constraints.maxWidth / 6,
                _ => constraints.maxWidth / 3,
              };

        List<FlTableColumn> fixedLeadingColumns = widget.columns
            .where((c) =>
                c.fixed != null && c.fixed == FlTableColumnFixedPosition.leading)
            .toList();
        List<FlTableColumn> fixedTrailingColumns = widget.columns
            .where((c) =>
                c.fixed != null &&
                c.fixed == FlTableColumnFixedPosition.trailing)
            .toList();
        List<FlTableColumn> unfixedColumns =
            widget.columns.where((c) => c.fixed == null).toList();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          child: Column(
            children: [
              // Optional table placements
              Container(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    ...(widget.tableLeadingActions ?? []),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    ...(widget.tableTrailingActions ?? [])
                  ],
                ),
              ),
              // Header block
              Row(
                children: [
                  ..._buildLeadingFixedHeaderColumn(
                    fixedLeadingColumns: fixedLeadingColumns,
                    defaultColumnWidth: defaultColumnWidth,
                    availableWidth: constraints.maxWidth,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: tableHeaderScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Wrap(
                        direction: Axis.vertical,
                        children: List.generate(1, (i) {
                          return Container(
                            decoration: BoxDecoration(
                              border: i == 0
                                  ? Border(
                                      bottom: BorderSide(
                                      color: borderColor,
                                    ))
                                  : null,
                            ),
                            child: Row(
                              children: _buildHeaderColumn(
                                unfixedColumns: unfixedColumns,
                                availableWidth: constraints.maxWidth,
                                defaultColumnWidth: defaultColumnWidth,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  ..._buildTrailingFixedHeaderColumn(
                    fixedTrailingColumns: fixedTrailingColumns,
                    availableWidth: constraints.maxWidth,
                    defaultColumnWidth: defaultColumnWidth,
                  )
                ],
              ),
              // Body block
              Expanded(
                child: widget.showLoader != null
                    ? widget.showLoader!
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildLeadingFixedBodyColumn(
                            availableWidth: constraints.maxWidth,
                            fixedLeadingColumns: fixedLeadingColumns,
                            defaultColumnWidth: defaultColumnWidth,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              controller: tableBodyVerticalScrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: tableBodyHorizontalScrollController,
                                child: Wrap(
                                  direction: Axis.vertical,
                                  children: _buildBody(
                                    unfixedColumns: unfixedColumns,
                                    availableWidth: constraints.maxWidth,
                                    defaultColumnWidth: defaultColumnWidth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ..._buildTrailingFixedBodyColumn(
                            fixedTrailingColumns: fixedTrailingColumns,
                            availableWidth: constraints.maxWidth,
                            defaultColumnWidth: defaultColumnWidth,
                          )
                        ],
                      ),
              ),
              // Footer block
              StreamBuilder(
                stream: paginationStream.stream,
                builder: (context, snapshot) {
                  return snapshot.data == null || snapshot.data?.enabled != true
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(
                            left: 13,
                            right: 13,
                            bottom: 10,
                            top: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: constraints.maxWidth < 500
                                ? MainAxisAlignment.spaceBetween
                                : snapshot.data!.position!,
                            children: [
                              constraints.maxWidth < 500 ? Container() : SizedBox(
                                height: headerHeight * 0.9,
                                width: constraints.maxWidth < 350 ? 95 : 150,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 13,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: snapshot.data!.selectedPageSize,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      isDense: true,
                                      items: snapshot.data!.pageSizes!
                                          .map<DropdownMenuItem<int>>(
                                              (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: SizedBox(
                                            width: constraints.maxWidth < 350
                                                ? 35
                                                : 100,
                                            child: Text(
                                              "$value per page",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          onPaginationEvent(
                                            FlTableOnPageSizeChange(
                                              pagination: snapshot.data!,
                                              selectedPageSize: value,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: snapshot.data!.canGoBack == true
                                    ? () {
                                        onPaginationEvent(
                                          FlTableOnGoToFirstPage(
                                              pagination: snapshot.data!),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.skip_previous_rounded),
                              ),
                              IconButton(
                                onPressed: snapshot.data!.canGoBack == true
                                    ? () {
                                        onPaginationEvent(
                                          FlTableOnGoOnePageBackward(
                                              pagination: snapshot.data!),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text(
                                  "${snapshot.data!.currentPage} of ${snapshot.data!.totalPages}"),
                              IconButton(
                                onPressed: snapshot.data!.canGoForward == true
                                    ? () {
                                        onPaginationEvent(
                                          FlTableOnGoOnePageForward(
                                              pagination: snapshot.data!),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                              IconButton(
                                onPressed: snapshot.data!.canGoForward == true
                                    ? () {
                                        onPaginationEvent(
                                          FlTableOnGoToLastPage(
                                              pagination: snapshot.data!),
                                        );
                                      }
                                    : null,
                                icon: const Icon(Icons.skip_next_rounded),
                              ),
                            ],
                          ),
                        );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
