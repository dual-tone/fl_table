
import 'fl_table_pagination.dart';

sealed class ITableEvents {}

class FlTableOnSelection extends ITableEvents {
  Set<String> selected;

  FlTableOnSelection({required this.selected});
}

class FlTableOnGoOnePageForward extends ITableEvents {
  FlTablePagination pagination;

  FlTableOnGoOnePageForward({required this.pagination});
}

class FlTableOnGoOnePageBackward extends ITableEvents {
  FlTablePagination pagination;

  FlTableOnGoOnePageBackward({required this.pagination});
}

class FlTableOnGoToLastPage extends ITableEvents {
  FlTablePagination pagination;

  FlTableOnGoToLastPage({required this.pagination});
}

class FlTableOnGoToFirstPage extends ITableEvents {
  FlTablePagination pagination;

  FlTableOnGoToFirstPage({required this.pagination});
}

class FlTableOnPageSizeChange extends ITableEvents {
  FlTablePagination pagination;
  int selectedPageSize;

  FlTableOnPageSizeChange({
    required this.pagination,
    required this.selectedPageSize,
  });
}
