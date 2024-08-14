<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

Flutter table widget: Highly customizable, performant, and easy to use.

> We're actively developing this package. Expect detailed documentation and examples in the upcoming
> releases.

----
## Features

- Fix headers to the top
- Fix columns to the left or right or both
- Pagination support available

## Getting started

### Installation
Add the following line to `pubspec.yaml`
```yaml
dependencies:
  fl_table:
```

## Usage
Check example for more details.
### Basic Setup
Import the dependency.
```dart
import 'package:fl_table/fl_table.dart';

```
Snippet to render the table widget.
```dart
FlTable(
  columns: [
    FlTableColumn(
        key: "id",
        label: "Id",
        fixed: FlTableColumnFixedPosition.leading),
    FlTableColumn(key: "name", label: "Name"),
    FlTableColumn(key: "email", label: "Email"),
    FlTableColumn(key: "phone", label: "Phone"),
    FlTableColumn(key: "col5", label: "Column 5"),
    FlTableColumn(key: "col6", label: "Column 6")
  ],
  rows: List.generate(150, (index) {
    return FlTableRow(
      id: "$index",
      cells: [
        FlTableCell(
          key: "id",
          cell: Text((index).toString()),
        ),
        FlTableCell(
          key: "name",
          cell: Text("Full name $index"),
        ),
        FlTableCell(
          key: "email",
          cell: Text("email$index@ifour.io"),
        ),
        FlTableCell(
          key: "phone",
          cell: Text("+919999999${index + 1}"),
        ),
        FlTableCell(
          key: "col5",
          cell: Text("Col5 ${index + 1}"),
        ),
        FlTableCell(
          key: "col6",
          cell: Text("Col6 ${index + 1}"),
        ),
      ],
    );
  }).toList(),
)
```

<!--
## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
-->