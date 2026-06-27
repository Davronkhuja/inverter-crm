import 'dart:io';

import 'package:excel/excel.dart' as xls;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/constants/enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';

enum ExportFormat { excel, pdf }

/// Экспорт записей инверторов в Excel (.xlsx) и PDF и шаринг файла системой.
class ExportService {
  static const _headers = <String>[
    'Order No',
    'Model',
    'ASN',
    'Client',
    'Installation Date',
    'Sale Date',
    'Location',
    'Fault Type',
    'Fault Description',
    'Solution',
    'Replaced',
    'New ASN',
    'Old Unit Location',
  ];

  List<String> _row(Inverter inv) => [
    inv.orderNo,
    inv.model,
    inv.asn,
    inv.clientName,
    Formatters.date(inv.installationDate),
    Formatters.date(inv.saleDate),
    inv.locationLabel,
    inv.faultType == FaultType.none ? '' : inv.faultType.label,
    inv.faultDescription,
    inv.solution,
    inv.replaced ? 'Yes' : 'No',
    inv.newAsn ?? '',
    inv.replaced ? inv.oldInverterLocation.label : '',
  ];

  Future<void> export(List<Inverter> items, ExportFormat format) async {
    final stamp = Formatters.fileStamp(DateTime.now());
    final dir = await getTemporaryDirectory();
    final File file;

    if (format == ExportFormat.excel) {
      file = File('${dir.path}/inverters_$stamp.xlsx');
      await file.writeAsBytes(_buildExcel(items));
    } else {
      file = File('${dir.path}/inverters_$stamp.pdf');
      await file.writeAsBytes(await _buildPdf(items));
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Inverter CRM export',
        text: 'Inverter records (${items.length})',
      ),
    );
  }

  List<int> _buildExcel(List<Inverter> items) {
    final excel = xls.Excel.createExcel();
    final sheet = excel['Inverters'];
    excel.delete('Sheet1');

    final headerStyle = xls.CellStyle(
      bold: true,
      backgroundColorHex: xls.ExcelColor.fromHexString('FF0E7C7B'),
      fontColorHex: xls.ExcelColor.fromHexString('FFFFFFFF'),
    );

    for (var c = 0; c < _headers.length; c++) {
      final cell = sheet.cell(
        xls.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
      );
      cell.value = xls.TextCellValue(_headers[c]);
      cell.cellStyle = headerStyle;
    }

    for (var r = 0; r < items.length; r++) {
      final values = _row(items[r]);
      for (var c = 0; c < values.length; c++) {
        sheet
            .cell(
              xls.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1),
            )
            .value = xls.TextCellValue(
          values[c],
        );
      }
    }

    for (var c = 0; c < _headers.length; c++) {
      sheet.setColumnAutoFit(c);
    }

    return excel.save() ?? <int>[];
  }

  Future<List<int>> _buildPdf(List<Inverter> items) async {
    final doc = pw.Document();
    final accent = PdfColor.fromInt(0xFF0E7C7B);

    // Компактный набор колонок, чтобы таблица влезла в альбомный лист.
    const cols = [
      'Order No',
      'Model',
      'ASN',
      'Client',
      'Installed',
      'Location',
      'Fault',
      'Replaced',
      'New ASN',
    ];

    List<String> compactRow(Inverter inv) => [
      inv.orderNo,
      inv.model,
      inv.asn,
      inv.clientName,
      Formatters.date(inv.installationDate),
      inv.locationLabel,
      inv.faultType == FaultType.none ? '—' : inv.faultType.label,
      inv.replaced ? 'Yes' : 'No',
      inv.newAsn ?? '—',
    ];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 14),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Inverter Warranty & Service CRM',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: accent,
                    ),
                  ),
                  pw.Text(
                    'Records report',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Text(
                '${items.length} records  •  ${Formatters.dateTime(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ),
        footer: (ctx) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
          ),
        ),
        build: (ctx) => [
          pw.TableHelper.fromTextArray(
            headers: cols,
            data: items.map(compactRow).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 8.5,
            ),
            headerDecoration: pw.BoxDecoration(color: accent),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellHeight: 22,
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              ),
            ),
            cellAlignments: {7: pw.Alignment.center},
            columnWidths: {
              0: const pw.FlexColumnWidth(1.1),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(1.4),
              3: const pw.FlexColumnWidth(1.6),
              4: const pw.FlexColumnWidth(1.1),
              5: const pw.FlexColumnWidth(1.8),
              6: const pw.FlexColumnWidth(1.2),
              7: const pw.FlexColumnWidth(0.8),
              8: const pw.FlexColumnWidth(1.4),
            },
          ),
        ],
      ),
    );

    return doc.save();
  }
}
