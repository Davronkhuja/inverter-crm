import 'package:intl/intl.dart';

/// Единое форматирование дат во всём приложении.
class Formatters {
  Formatters._();

  static final DateFormat _date = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, HH:mm');

  static String date(DateTime? d) => d == null ? '—' : _date.format(d);
  static String dateTime(DateTime? d) => d == null ? '—' : _dateTime.format(d);

  /// Дата для имён файлов экспорта: 2026-06-26_1530.
  static String fileStamp(DateTime d) =>
      DateFormat('yyyy-MM-dd_HHmm').format(d);
}
