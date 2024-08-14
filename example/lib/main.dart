import 'package:fl_table/fl_table.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FlTable(
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
                    id: "0",
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
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
