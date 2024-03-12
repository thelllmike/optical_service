import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';


class PrintHelper {
  // Method to generate a PDF document with item and prescription details
  Future<pw.Document> generateDocument({
    required String logoAssetPath,
    required String branchName,
    required String branchAddress,
    required String mobileNumber,
    required String customerName,
    required String customerPhone,
    required String invoiceDate,
    required String invoiceNumber,
    required List<Map<String, dynamic>> itemDetails,
    required List<Map<String, dynamic>> prescriptionDetails,
    required double total,
    required double advancePaid,
    required String takenBy,
  }) async {
    final pdf = pw.Document();

    // Load the logo and font from the assets
    final Uint8List logoBytes = (await rootBundle.load(logoAssetPath)).buffer.asUint8List();
    final pw.MemoryImage logo = pw.MemoryImage(logoBytes);
    final Uint8List fontData = (await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")).buffer.asUint8List();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  final double widthInPoints = 14.5 * 72 / 2.54;
  final double heightInPoints = 19.5 * 72 / 2.54;
  final PdfPageFormat customPageSize = PdfPageFormat(widthInPoints, heightInPoints);

    // Create a PDF document using the data
    pdf.addPage(
      pw.Page(
           pageFormat: customPageSize, 
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Image(logo, width: 100, height: 100),
            pw.Text(branchName, style: pw.TextStyle(font: ttf)),
            pw.Text(branchAddress, style: pw.TextStyle(font: ttf)),
            pw.Text('Mobile: $mobileNumber', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Text('Customer: $customerName', style: pw.TextStyle(font: ttf)),
            pw.Text('Tel: $customerPhone', style: pw.TextStyle(font: ttf)),
            pw.SizedBox(height: 20),
            pw.Text('Invoice Date: $invoiceDate', style: pw.TextStyle(font: ttf)),
            pw.Text('Invoice No: $invoiceNumber', style: pw.TextStyle(font: ttf)),
            pw.Divider(),
            pw.Table.fromTextArray(
              context: context,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              headerHeight: 25,
              cellHeight: 40,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
              cellStyle: pw.TextStyle(font: ttf),
              headers: ['Description', 'Qty', 'Unit Price', 'Total'],
              data: itemDetails.map((item) => [
                item['description'],
                item['quantity'].toString(),
                item['unitPrice'].toString(),
                item['total'].toString(),
              ]).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Prescription Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf)),
            pw.Table.fromTextArray(
              context: context,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              headerHeight: 25,
              cellHeight: 40,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
              cellStyle: pw.TextStyle(font: ttf),
              headers: ['Eye', 'PD', 'SPH', 'CYL', 'AXIS', 'ADD'],
            data: prescriptionDetails.map((detail) => [
              detail['Eye'].toString(), // Assuming you want to include the 'Eye' column as well
              detail['PD'].toString(),
              detail['SPH'].toString(),
              detail['CYL'].toString(),
              detail['AXIS'].toString(),
              detail['ADD'].toString(),
            ]).toList(),

            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('GRAND TOTAL', style: pw.TextStyle(font: ttf)),
                pw.Text('\$${total.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('ADVANCE PAID', style: pw.TextStyle(font: ttf)),
                pw.Text('\$${advancePaid.toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('BALANCE AMOUNT', style: pw.TextStyle(font: ttf)),
                pw.Text('\$${(total - advancePaid).toStringAsFixed(2)}', style: pw.TextStyle(font: ttf)),
              ],
            ),
            if (total - advancePaid == 0)
              pw.Center(child: pw.Text('PAID', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24, font: ttf))),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('Taken by: $takenBy', style: pw.TextStyle(font: ttf)),
              ],
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  // Method to print the PDF document and save a copy of it
Future<void> printAndSaveDocument(pw.Document pdf, String suggestedFileName) async {
  try {
    // Open save file dialog
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: suggestedFileName, // Suggested file name
    );

    if (outputPath != null) {
      final File file = File(outputPath);
      await file.writeAsBytes(await pdf.save());
      print("PDF Saved to: $outputPath");

      // Optionally, offer printing directly from the app
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    } else {
      // User canceled the picker
      print("File save operation was canceled.");
    }
  } catch (e) {
    print("Error during print/save: $e");
  }
}


}
