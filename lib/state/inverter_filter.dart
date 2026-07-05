import '../core/constants/enums.dart';
import '../data/models/inverter.dart';

enum SortBy { installDate, saleDate, model, client, orderNo }

enum SortDir { asc, desc }

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
  final SortBy sortBy;
  final SortDir sortDir;

  const InverterFilter({
    this.query = '',
    this.replaced = ReplacedFilter.notReplaced,
    this.faultType,
    this.model,
    this.installedFrom,
    this.installedTo,
    this.soldFrom,
    this.soldTo,
    this.sortBy = SortBy.installDate,
    this.sortDir = SortDir.desc,
  });

  bool get hasActiveFilters =>
      replaced != ReplacedFilter.notReplaced ||
      faultType != null ||
      model != null ||
      installedFrom != null ||
      installedTo != null ||
      soldFrom != null ||
      soldTo != null;

  int get activeCount {
    var n = 0;
    if (replaced != ReplacedFilter.notReplaced) n++;
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
    SortBy? sortBy,
    SortDir? sortDir,
  }) {
    return InverterFilter(
      query: query ?? this.query,
      replaced: replaced ?? this.replaced,
      faultType: clearFaultType ? null : (faultType ?? this.faultType),
      model: clearModel ? null : (model ?? this.model),
      installedFrom: clearInstalled ? null : (installedFrom ?? this.installedFrom),
      installedTo: clearInstalled ? null : (installedTo ?? this.installedTo),
      soldFrom: clearSold ? null : (soldFrom ?? this.soldFrom),
      soldTo: clearSold ? null : (soldTo ?? this.soldTo),
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
    );
  }

  /// Применяет поиск, фильтры и сортировку к списку.
  List<Inverter> apply(List<Inverter> all) {
    final q = query.trim().toLowerCase();
    final filtered = all.where((inv) {
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

    filtered.sort((a, b) {
      int cmp;
      switch (sortBy) {
        case SortBy.installDate:
          final da = a.installationDate ?? DateTime(0);
          final db = b.installationDate ?? DateTime(0);
          cmp = da.compareTo(db);
          break;
        case SortBy.saleDate:
          final da = a.saleDate ?? DateTime(0);
          final db = b.saleDate ?? DateTime(0);
          cmp = da.compareTo(db);
          break;
        case SortBy.model:
          cmp = a.model.toLowerCase().compareTo(b.model.toLowerCase());
          break;
        case SortBy.client:
          cmp = a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase());
          break;
        case SortBy.orderNo:
          cmp = a.orderNo.compareTo(b.orderNo);
          break;
      }
      return sortDir == SortDir.asc ? cmp : -cmp;
    });

    return filtered;
  }

  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);
}
