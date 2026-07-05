import 'dart:io';

import 'package:excel/excel.dart' as xls;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/enums.dart';
import '../../core/utils/enum_localizations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';
import '../../l10n/app_localizations.dart';

enum ExportFormat { excel, pdf }

class ExportService {
  Future<void> export(
    List<Inverter> items,
    ExportFormat format,
    AppLocalizations l10n,
  ) async {
    final stamp = Formatters.fileStamp(DateTime.now());
    final dir = await getTemporaryDirectory();
    final File file;

    if (format == ExportFormat.excel) {
      file = File('${dir.path}/inverters_$stamp.xlsx');
      await file.writeAsBytes(_buildExcel(items, l10n));
    } else {
      file = File('${dir.path}/inverters_$stamp.pdf');
      await file.writeAsBytes(await _buildPdf(items, l10n));
    }

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Inverter CRM export',
        text: 'Inverter records (${items.length})',
      ),
    );
  }

  List<String> _headers(AppLocalizations l) => [
    l.exportColOrderNo,
    l.exportColModel,
    l.exportColAsn,
    l.exportColDataloggerSn,
    l.exportColClient,
    l.exportColInstallDate,
    l.exportColSaleDate,
    l.exportColLocation,
    l.exportColFaultType,
    l.exportColFaultDesc,
    l.exportColSolution,
    l.exportColApprovedBy,
    l.exportColReplaced,
    l.exportColNewAsn,
    l.exportColOldLocation,
  ];

  List<String> _row(Inverter inv, AppLocalizations l) => [
    inv.orderNo,
    inv.model,
    inv.asn,
    inv.dataloggerSn,
    inv.clientName,
    Formatters.exportDate(inv.installationDate),
    Formatters.exportDate(inv.saleDate),
    inv.locationLabel,
    inv.faultType == FaultType.none ? l.exportNoFault : inv.faultType.l10n(l),
    inv.faultDescription,
    inv.solution,
    inv.approvedBy,
    inv.replaced ? l.exportYes : l.exportNo,
    inv.newAsn ?? '',
    inv.replaced ? inv.oldInverterLocation.l10n(l) : '',
  ];

  List<int> _buildExcel(List<Inverter> items, AppLocalizations l) {
    final excel = xls.Excel.createExcel();

    final active = items.where((i) => !i.replaced).toList();
    final warehouse = items.where((i) => i.replaced).toList();

    _fillSheet(excel, l.exportActiveSheet, active, l);
    if (warehouse.isNotEmpty) {
      _fillSheet(excel, l.exportWarehouseSheet, warehouse, l);
    }

    excel.delete('Sheet1');
    return excel.save() ?? <int>[];
  }

  void _fillSheet(
    xls.Excel excel,
    String sheetName,
    List<Inverter> items,
    AppLocalizations l,
  ) {
    final sheet = excel[sheetName];
    final headers = _headers(l);

    final headerStyle = xls.CellStyle(
      bold: true,
      backgroundColorHex: xls.ExcelColor.fromHexString('FF0E7C7B'),
      fontColorHex: xls.ExcelColor.fromHexString('FFFFFFFF'),
    );

    for (var c = 0; c < headers.length; c++) {
      final cell = sheet.cell(
        xls.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0),
      );
      cell.value = xls.TextCellValue(headers[c]);
      cell.cellStyle = headerStyle;
    }

    for (var r = 0; r < items.length; r++) {
      final values = _row(items[r], l);
      for (var c = 0; c < values.length; c++) {
        sheet
            .cell(
              xls.CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1),
            )
            .value = xls.TextCellValue(values[c]);
      }
    }

    for (var c = 0; c < headers.length; c++) {
      sheet.setColumnAutoFit(c);
    }
  }

  Future<List<int>> _buildPdf(List<Inverter> items, AppLocalizations l) async {
    final doc = pw.Document();
    final accent = PdfColor.fromInt(0xFF0E7C7B);
    final warehouseAccent = PdfColor.fromInt(0xFFE53935);

    final regular = await PdfGoogleFonts.notoSansRegular();
    final bold = await PdfGoogleFonts.notoSansBold();

    final baseStyle = pw.TextStyle(font: regular, fontSize: 8);
    final boldStyle = pw.TextStyle(font: bold, fontSize: 8.5);

    final active = items.where((i) => !i.replaced).toList();
    final warehouse = items.where((i) => i.replaced).toList();

    final cols = [
      l.exportColOrderNo,
      l.exportColModel,
      l.exportColAsn,
      l.exportColDataloggerSn,
      l.exportColClient,
      l.exportColInstallDate,
      l.exportColLocation,
      l.exportColFaultDesc,
      l.exportColSolution,
      l.exportColApprovedBy,
      l.exportColReplaced,
      l.exportColNewAsn,
    ];

    List<String> compactRow(Inverter inv) => [
      inv.orderNo,
      inv.model,
      inv.asn,
      inv.dataloggerSn,
      inv.clientName,
      Formatters.exportDate(inv.installationDate),
      inv.locationLabel,
      inv.faultDescription.isEmpty ? '—' : inv.faultDescription,
      inv.solution.isEmpty ? '—' : inv.solution,
      inv.approvedBy.isEmpty ? '—' : inv.approvedBy,
      inv.replaced ? l.exportYes : l.exportNo,
      inv.newAsn ?? '—',
    ];

    pw.Widget _header(String title, int count, PdfColor color) =>
        pw.Container(
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
                      font: bold,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                    ),
                  ),
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Text(
                '$count ${l.exportColReplaced.isEmpty ? "records" : "records"}  •  ${Formatters.exportDateTime(DateTime.now())}',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        );

    pw.Widget _footer(pw.Context ctx) => pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 8),
      child: pw.Text(
        'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
        style: pw.TextStyle(font: regular, fontSize: 8, color: PdfColors.grey),
      ),
    );

    pw.Widget _table(List<Inverter> rows, PdfColor hdrColor) =>
        pw.TableHelper.fromTextArray(
          headers: cols,
          data: rows.map(compactRow).toList(),
          headerStyle: boldStyle.copyWith(color: PdfColors.white),
          headerDecoration: pw.BoxDecoration(color: hdrColor),
          cellStyle: baseStyle,
          cellHeight: 22,
          rowDecoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
          ),
          cellAlignments: {10: pw.Alignment.center},
          columnWidths: {
            0: const pw.FlexColumnWidth(1.0),
            1: const pw.FlexColumnWidth(1.1),
            2: const pw.FlexColumnWidth(1.3),
            3: const pw.FlexColumnWidth(1.2),
            4: const pw.FlexColumnWidth(1.4),
            5: const pw.FlexColumnWidth(1.0),
            6: const pw.FlexColumnWidth(1.5),
            7: const pw.FlexColumnWidth(2.0),
            8: const pw.FlexColumnWidth(1.8),
            9: const pw.FlexColumnWidth(1.2),
            10: const pw.FlexColumnWidth(0.8),
            11: const pw.FlexColumnWidth(1.3),
          },
        );

    if (active.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(28),
          header: (ctx) => _header(l.exportActiveSheet, active.length, accent),
          footer: _footer,
          build: (ctx) => [_table(active, accent)],
        ),
      );
    }

    if (warehouse.isNotEmpty) {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(28),
          header: (ctx) =>
              _header(l.exportWarehouseSheet, warehouse.length, warehouseAccent),
          footer: _footer,
          build: (ctx) => [_table(warehouse, warehouseAccent)],
        ),
      );
    }

    return doc.save();
  }
}
