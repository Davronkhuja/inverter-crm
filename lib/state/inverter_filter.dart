import '../core/constants/enums.dart';
import '../data/models/inverter.dart';

/// Тристейт фильтра по статусу замены.
enum ReplacedFilter {
  any,
  replaced,
  notReplaced;

  String get label {
    switch (this) {
      case ReplacedFilter.any:
        return 'All';
      case ReplacedFilter.replaced:
        return 'Replaced';
      case ReplacedFilter.notReplaced:
        return 'Not replaced';
    }
  }
}

/// Набор активных фильтров и поискового запроса для дашборда.
class InverterFilter {
  final String query;
  final ReplacedFilter replaced;
  final FaultType? faultType;
  final String? model;
  final DateTime? installedFrom;
  final DateTime? installedTo;
  final DateTime? soldFrom;
  final DateTime? soldTo;

  const InverterFilter({
    this.query = '',
    this.replaced = ReplacedFilter.any,
    this.faultType,
    this.model,
    this.installedFrom,
    this.installedTo,
    this.soldFrom,
    this.soldTo,
  });

  bool get hasActiveFilters =>
      replaced != ReplacedFilter.any ||
      faultType != null ||
      model != null ||
      installedFrom != null ||
      installedTo != null ||
      soldFrom != null ||
      soldTo != null;

  int get activeCount {
    var n = 0;
    if (replaced != ReplacedFilter.any) n++;
    if (faultType != null) n++;
    if (model != null) n++;
    if (installedFrom != null || installedTo != null) n++;
    if (soldFrom != null || soldTo != null) n++;
    return n;
  }

  InverterFilter copyWith({
    String? query,
    ReplacedFilter? replaced,
    FaultType? faultType,
    bool clearFaultType = false,
    String? model,
    bool clearModel = false,
    DateTime? installedFrom,
    DateTime? installedTo,
    DateTime? soldFrom,
    DateTime? soldTo,
    bool clearInstalled = false,
    bool clearSold = false,
  }) {
    return InverterFilter(
      query: query ?? this.query,
      replaced: replaced ?? this.replaced,
      faultType: clearFaultType ? null : (faultType ?? this.faultType),
      model: clearModel ? null : (model ?? this.model),
      installedFrom: clearInstalled
          ? null
          : (installedFrom ?? this.installedFrom),
      installedTo: clearInstalled ? null : (installedTo ?? this.installedTo),
      soldFrom: clearSold ? null : (soldFrom ?? this.soldFrom),
      soldTo: clearSold ? null : (soldTo ?? this.soldTo),
    );
  }

  /// Применяет поиск и фильтры к списку. Поиск — по ASN, имени клиента,
  /// модели и локации (ТЗ §1).
  List<Inverter> apply(List<Inverter> all) {
    final q = query.trim().toLowerCase();
    return all.where((inv) {
      if (q.isNotEmpty) {
        final haystack = [
          inv.asn,
          inv.clientName,
          inv.model,
          inv.locationLabel,
          inv.orderNo,
          inv.newAsn ?? '',
        ].join(' ').toLowerCase();
        if (!haystack.contains(q)) return false;
      }

      switch (replaced) {
        case ReplacedFilter.replaced:
          if (!inv.replaced) return false;
          break;
        case ReplacedFilter.notReplaced:
          if (inv.replaced) return false;
          break;
        case ReplacedFilter.any:
          break;
      }

      if (faultType != null && inv.faultType != faultType) return false;
      if (model != null && inv.model != model) return false;

      if (installedFrom != null &&
          (inv.installationDate == null ||
              inv.installationDate!.isBefore(installedFrom!))) {
        return false;
      }
      if (installedTo != null &&
          (inv.installationDate == null ||
              inv.installationDate!.isAfter(_endOfDay(installedTo!)))) {
        return false;
      }
      if (soldFrom != null &&
          (inv.saleDate == null || inv.saleDate!.isBefore(soldFrom!))) {
        return false;
      }
      if (soldTo != null &&
          (inv.saleDate == null || inv.saleDate!.isAfter(_endOfDay(soldTo!)))) {
        return false;
      }
      return true;
    }).toList();
  }

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);
}
