import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExcelSheet extends StatefulWidget {
  @override
  _ExcelSheetState createState() => _ExcelSheetState();
}

class _ExcelSheetState extends State<ExcelSheet> {
  List<List<dynamic>> excelData = [];

  Future<void> readExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/Invoice.xlsx';
    final File file = File(path);
    final List<int> bytes = await file.readAsBytes();
    final Workbook workbook = Workbook();
    final WorksheetCollection sheet = workbook.worksheets;
  }
  @override
  void initState() {
    super.initState();
    readExcel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Excel Sheet"),
      ),
      body: DataTable(
        columns: excelData.isNotEmpty
            ? excelData.map((e) => DataColumn(label: Text(e.toString()))).toList()
            : [],
        rows: excelData
            .skip(1)
            .map((e) => DataRow(cells: e.map((e) => DataCell(Text(e.toString()))).toList()))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: readExcel,
        tooltip: 'Open Excel file',
        child: Icon(Icons.folder_open),
      ),
    );
  }
}