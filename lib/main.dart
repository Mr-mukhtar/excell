import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTableWidget(),
    );
  }
}

class MyTableWidget extends StatefulWidget {
  @override
  _MyTableWidgetState createState() => _MyTableWidgetState();
}

class _MyTableWidgetState extends State<MyTableWidget> {
  List<List<dynamic>> _tableData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Table'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Pick File'),
          ),
          Expanded(
            child: SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _tableData.isNotEmpty
                    ? _tableData.first
                    .map((column) => DataColumn(label: Text('$column')))
                    .toList()g
                    : [],
                rows: _tableData.skip(1).map((row) {
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(Text('$cell'));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.single.path!);
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      var table = excel.tables.values.first;
      setState(() {
        _tableData = table.rows;
      });
    }
  }
}