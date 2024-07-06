import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bloc_v2/pdf/helper/pdf_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfInvoicePdfHelper {
  static Future<File> generate(List<dynamic> salesData, DateTime startDate, DateTime endDate) async {
    final pdf = pw.Document();

    final Uint8List logoData = await _loadAsset('assets/images/logo.png');

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildTitle(salesData, startDate, endDate, logoData),
        buildSalesTable(salesData),
      ],
    ));

    return PdfHelper.saveDocument(name: 'sales_report.pdf', pdf: pdf);
  }

  static Future<Uint8List> _loadAsset(String path) async {
    return await rootBundle.load(path).then((data) => data.buffer.asUint8List());
  }

  static String capitalizeFirstLetter(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).join(' ');
  }

  static pw.Widget buildTitle(List<dynamic> salesData, DateTime startDate, DateTime endDate, Uint8List logoData) {
    final branchName = salesData.isNotEmpty ? capitalizeFirstLetter(salesData[0]['fn_branch_name']) : '';
    final branchManagerName = "Mahmoud Hossam"; // Add the branch manager's name here
    final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Center(
          child: pw.Text(
            'Sales Report',
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold), // Increased font size
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Image(
            pw.MemoryImage(logoData),
            width: 200, // Adjust the width as needed
            height: 100, // Adjust the height as needed
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Text(
            'Branch Name: $branchName',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold), // Increased font size
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Text(
            'Report Period: $formattedStartDate - $formattedEndDate', // Show start and end dates
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.normal), // Adjust font size
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Text(
            'Branch Manager: $branchManagerName', // Branch manager's name
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold), // Make it bold
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
    );
  }

  static pw.Widget buildSalesTable(List<dynamic> salesData) {
    final headers = [
      'ID',
      'Item Name',
      'Quantity',
      'Total Sales'
    ];

    final data = salesData.map((item) {
      return [
        item['fn_item_id'].toString(),
        capitalizeFirstLetter(item['fn_item_name']),
        item['fn_sales_count'].toString(),
        item['fn_total_sales'].toString(),
      ];
    }).toList();

    final totalSales = salesData.fold(0.0, (sum, item) {
      final totalSalesValue = double.tryParse(item['fn_total_sales'].toString()) ?? 0.0;
      return sum + totalSalesValue;
    });

    data.add([
      '', // Empty cell for ID column
      'Total All Item Sales',
      '', // Empty cell for Quantity column
      totalSales.toStringAsFixed(2),
    ]);

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15), // Increased header font size
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: pw.TextStyle(fontSize: 16), // Increased cell font size
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
      },
    );
  }

  static Future<File> generateComparisonPdf(List<dynamic> comparisonData) async {
    final pdf = pw.Document();

    final Uint8List logoData = await _loadAsset('assets/images/logo.png');

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildComparisonTitle(logoData),
        buildComparisonTable(comparisonData),
      ],
    ));

    return PdfHelper.saveDocument(name: 'comparison_report.pdf', pdf: pdf);
  }

  static pw.Widget buildComparisonTitle(Uint8List logoData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Center(
          child: pw.Text(
            'Branches Sales Comparison Report',
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Image(
            pw.MemoryImage(logoData),
            width: 200,
            height: 100,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Text(
            'Last 30 Days', // Branch manager's name
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold), // Make it bold
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
    );
  }

  static pw.Widget buildComparisonTable(List<dynamic> comparisonData) {
    final headers = [
      'Branch ID',
      'Branch Name',
      'Total Sales',
      'Total Orders'
    ];

    final data = comparisonData.map((branch) {
      return [
        branch['branch_id'].toString(),
        capitalizeFirstLetter(branch['branch_name']),
        branch['total_sales'],
        branch['total_orders'],
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: pw.TextStyle(fontSize: 16),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
      },
    );
  }

  static Future<File> generateOverallPerformancePdf(List<dynamic> performanceData) async {
    final pdf = pw.Document();

    final Uint8List logoData = await _loadAsset('assets/images/logo.png');

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildPerformanceTitle(logoData),
        buildPerformanceTable(performanceData),
      ],
    ));

    return PdfHelper.saveDocument(name: 'overall_performance_report.pdf', pdf: pdf);
  }

  static pw.Widget buildPerformanceTitle(Uint8List logoData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Center(
          child: pw.Text(
            'Overall Performance Report',
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Image(
            pw.MemoryImage(logoData),
            width: 200,
            height: 100,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        pw.Center(
          child: pw.Text(
            'Last 30 Days', // Branch manager's name
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold), // Make it bold
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
    );
  }

  static pw.Widget buildPerformanceTable(List<dynamic> performanceData) {
    final headers = [
      'Sales Date',
      'Total Sales',
      'Total Orders'
    ];

    final data = performanceData.map((entry) {
      final salesDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(entry['sales_date']));
      return [
        salesDate,
        entry['total_sales'],
        entry['total_orders'],
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: pw.TextStyle(fontSize: 16),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
      },
    );
  }
}