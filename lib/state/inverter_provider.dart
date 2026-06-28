import 'package:flutter/foundation.dart';

import '../data/models/inverter.dart';
import '../data/models/service_event.dart';
import '../data/repositories/inverter_repository.dart';
import 'inverter_filter.dart';

/// Центральное состояние приложения: загруженные инверторы, активный фильтр,
/// производные данные для дашборда. Слушается через Provider/ChangeNotifier.
class InverterProvider extends ChangeNotifier {
  final InverterRepository _repo;
  InverterProvider(this._repo);

  bool _loading = true;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<Inverter> _all = [];
  List<Inverter> get all => List.unmodifiable(_all);

  InverterFilter _filter = const InverterFilter();
  InverterFilter get filter => _filter;

  /// Отфильтрованный и отсортированный список для дашборда.
  List<Inverter> get visible => _filter.apply(_all);

  /// Уникальные модели — для выпадающего фильтра.
  List<String> get models {
    final set = _all
        .map((e) => e.model)
        .where((m) => m.trim().isNotEmpty)
        .toSet();
    final list = set.toList()..sort();
    return list;
  }

  int get totalCount => _all.length;
  int get replacedCount => _all.where((e) => e.replaced).length;
  int get activeFaultCount =>
      _all.where((e) => !e.replaced && e.faultType.name != 'none').length;

  /// Следующий автоматический номер заказа в формате ORD-XXXX.
  /// Ищет максимальный числовой суффикс среди существующих order_no
  /// с этим префиксом и увеличивает на 1, чтобы не зависеть от порядка
  /// создания/удаления записей.
  String get nextOrderNo {
    const prefix = 'ORD-';
    var maxNumber = 1000;
    for (final inv in _all) {
      final raw = inv.orderNo.trim();
      if (!raw.startsWith(prefix)) continue;
      final numPart = raw.substring(prefix.length);
      final parsed = int.tryParse(numPart);
      if (parsed != null && parsed > maxNumber) maxNumber = parsed;
    }
    return '$prefix${maxNumber + 1}';
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _all = await _repo.getAll();
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _filter = _filter.copyWith(query: value);
    notifyListeners();
  }

  void setFilter(InverterFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearFilters() {
    _filter = InverterFilter(query: _filter.query);
    notifyListeners();
  }

  // ---- CRUD, прокидывает в репозиторий и обновляет кеш ----

  Future<void> add(Inverter inverter) async {
    await _repo.insert(inverter);
    await load();
  }

  Future<void> update(Inverter inverter) async {
    await _repo.update(inverter);
    await load();
  }

  Future<void> remove(Inverter inverter) async {
    await _repo.delete(inverter);
    await load();
  }

  Future<bool> asnExists(String asn, {String? exceptId}) =>
      _repo.asnExists(asn, exceptId: exceptId);

  Future<Inverter?> getByAsn(String asn) => _repo.getByAsn(asn);

  Future<Inverter?> getReplacement(Inverter inv) => _repo.getReplacement(inv);

  Future<Inverter?> getReplacedPredecessor(Inverter inv) =>
      _repo.getReplacedPredecessor(inv);

  Future<List<Inverter>> getReplacementChain(Inverter inv) =>
      _repo.getReplacementChain(inv);

  // ---- Журнал обслуживания ----

  Future<List<ServiceEvent>> getEvents(String asn) => _repo.getEvents(asn);

  Future<void> addEvent(ServiceEvent event) async {
    await _repo.insertEvent(event);
    notifyListeners();
  }

  Future<void> removeEvent(String id) async {
    await _repo.deleteEvent(id);
    notifyListeners();
  }
}
