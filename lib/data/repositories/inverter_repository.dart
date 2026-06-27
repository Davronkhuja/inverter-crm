import '../db/database_helper.dart';
import '../models/inverter.dart';
import '../models/service_event.dart';

/// Доступ к данным инверторов и журнала обслуживания.
/// Содержит всю логику связывания замен и построения цепочки истории.
class InverterRepository {
  final DatabaseHelper _dbHelper;
  InverterRepository([DatabaseHelper? helper])
    : _dbHelper = helper ?? DatabaseHelper.instance;

  // ---- Инверторы ----

  Future<List<Inverter>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query('inverters', orderBy: 'updated_at DESC');
    return rows.map(Inverter.fromMap).toList();
  }

  Future<Inverter?> getByAsn(String asn) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'inverters',
      where: 'asn = ?',
      whereArgs: [asn],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Inverter.fromMap(rows.first);
  }

  Future<bool> asnExists(String asn, {String? exceptId}) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'inverters',
      columns: ['id'],
      where: exceptId == null ? 'asn = ?' : 'asn = ? AND id != ?',
      whereArgs: exceptId == null ? [asn] : [asn, exceptId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<void> insert(Inverter inverter) async {
    final db = await _dbHelper.database;
    await db.insert('inverters', inverter.toMap());
  }

  Future<void> update(Inverter inverter) async {
    final db = await _dbHelper.database;
    await db.update(
      'inverters',
      inverter.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [inverter.id],
    );
  }

  /// Удаление инвертора. Ссылки замен, указывающие на его ASN, обнуляются,
  /// чтобы не оставалось «битых» связей. Журнал обслуживания тоже чистится.
  Future<void> delete(Inverter inverter) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      await txn.update(
        'inverters',
        {'new_asn': null},
        where: 'new_asn = ?',
        whereArgs: [inverter.asn],
      );
      await txn.delete(
        'service_events',
        where: 'inverter_asn = ?',
        whereArgs: [inverter.asn],
      );
      await txn.delete('inverters', where: 'id = ?', whereArgs: [inverter.id]);
    });
  }

  // ---- Связывание замен ----

  /// Инвертор, который ПРИШЁЛ НА ЗАМЕНУ данному (по его new_asn).
  Future<Inverter?> getReplacement(Inverter inverter) async {
    if (!inverter.hasNewReplacement) return null;
    return getByAsn(inverter.newAsn!);
  }

  /// Инвертор, который был ЗАМЕНЁН данным (тот, у кого new_asn == asn данного).
  Future<Inverter?> getReplacedPredecessor(Inverter inverter) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'inverters',
      where: 'new_asn = ?',
      whereArgs: [inverter.asn],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Inverter.fromMap(rows.first);
  }

  /// Полная цепочка замен, в которой участвует инвертор:
  /// от самого первого предка до самого последнего преемника.
  /// Пример: ASN-1 -> ASN-2 -> ASN-3.
  Future<List<Inverter>> getReplacementChain(Inverter inverter) async {
    final chain = <Inverter>[];
    final seen = <String>{};

    // Идём назад к самому первому инвертору.
    Inverter root = inverter;
    var guard = 0;
    while (guard++ < 50) {
      final prev = await getReplacedPredecessor(root);
      if (prev == null || seen.contains(prev.asn)) break;
      seen.add(prev.asn);
      root = prev;
    }

    // Идём вперёд от корня, собирая всю цепочку.
    seen.clear();
    Inverter? current = root;
    guard = 0;
    while (current != null && guard++ < 50) {
      if (seen.contains(current.asn)) break;
      seen.add(current.asn);
      chain.add(current);
      current = await getReplacement(current);
    }
    return chain;
  }

  // ---- Журнал обслуживания ----

  Future<List<ServiceEvent>> getEvents(String asn) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'service_events',
      where: 'inverter_asn = ?',
      whereArgs: [asn],
      orderBy: 'date DESC',
    );
    return rows.map(ServiceEvent.fromMap).toList();
  }

  Future<void> insertEvent(ServiceEvent event) async {
    final db = await _dbHelper.database;
    await db.insert('service_events', event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    final db = await _dbHelper.database;
    await db.delete('service_events', where: 'id = ?', whereArgs: [id]);
  }
}
