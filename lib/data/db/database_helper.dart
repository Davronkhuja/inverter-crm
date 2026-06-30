import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Инициализация и схема локальной БД (sqflite).
/// Хранит инверторы и журнал обслуживания. Связывание замен — по полю new_asn.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'inverter_crm.db';
  static const _dbVersion = 2;

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE inverters ADD COLUMN approved_by TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE inverters (
        id TEXT PRIMARY KEY,
        order_no TEXT NOT NULL,
        model TEXT NOT NULL,
        asn TEXT NOT NULL UNIQUE,
        client_name TEXT NOT NULL,
        installation_date TEXT,
        sale_date TEXT,
        country TEXT,
        city TEXT,
        site TEXT,
        fault_description TEXT,
        fault_type TEXT,
        solution TEXT,
        replaced INTEGER NOT NULL DEFAULT 0,
        new_asn TEXT,
        old_location TEXT,
        approved_by TEXT NOT NULL DEFAULT '',
        notes TEXT,
        photos TEXT,
        documents TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_inverters_asn ON inverters(asn)');
    await db.execute(
      'CREATE INDEX idx_inverters_new_asn ON inverters(new_asn)',
    );

    await db.execute('''
      CREATE TABLE service_events (
        id TEXT PRIMARY KEY,
        inverter_asn TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        technician TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_events_asn ON service_events(inverter_asn)',
    );

    await _seedDemoData(db);
  }

  /// Несколько демонстрационных записей, чтобы дашборд не был пустым
  /// при первом запуске и сразу демонстрировал цепочку замен.
  Future<void> _seedDemoData(Database db) async {
    final now = DateTime.now();
    String iso(DateTime d) => d.toIso8601String();

    final demo = <Map<String, Object?>>[
      {
        'id': 'seed-1',
        'order_no': 'ORD-1001',
        'model': 'SUN-5K-G03',
        'asn': 'ASN-2023-0001',
        'client_name': 'GreenPower Solar LLC',
        'installation_date': iso(DateTime(2023, 4, 12)),
        'sale_date': iso(DateTime(2023, 3, 20)),
        'country': 'Uzbekistan',
        'city': 'Tashkent',
        'site': 'Rooftop A, Yunusabad',
        'fault_description':
            'Inverter shuts down at midday, overheating alarm.',
        'fault_type': 'overheating',
        'solution':
            'Replaced cooling fan, cleaned heatsink. Issue persisted, unit swapped.',
        'replaced': 1,
        'new_asn': 'ASN-2024-0042',
        'old_location': 'returnedToFactory',
        'approved_by': 'D. Yusupov',
        'notes': 'Customer under 5-year warranty.',
        'photos': '[]',
        'documents': '[]',
        'created_at': iso(now.subtract(const Duration(days: 120))),
        'updated_at': iso(now.subtract(const Duration(days: 30))),
      },
      {
        'id': 'seed-2',
        'order_no': 'ORD-1042',
        'model': 'SUN-8K-G04',
        'asn': 'ASN-2024-0042',
        'client_name': 'GreenPower Solar LLC',
        'installation_date': iso(DateTime(2024, 1, 18)),
        'sale_date': iso(DateTime(2024, 1, 5)),
        'country': 'Uzbekistan',
        'city': 'Tashkent',
        'site': 'Rooftop A, Yunusabad',
        'fault_description': 'Replacement unit for ASN-2023-0001.',
        'fault_type': 'none',
        'solution': '',
        'replaced': 0,
        'new_asn': null,
        'old_location': 'warehouse',
        'approved_by': '',
        'notes': 'Active, operating normally.',
        'photos': '[]',
        'documents': '[]',
        'created_at': iso(now.subtract(const Duration(days: 30))),
        'updated_at': iso(now.subtract(const Duration(days: 30))),
      },
      {
        'id': 'seed-3',
        'order_no': 'ORD-1100',
        'model': 'SUN-3K-G03',
        'asn': 'ASN-2023-0099',
        'client_name': 'Bright Future Energy',
        'installation_date': iso(DateTime(2023, 9, 2)),
        'sale_date': iso(DateTime(2023, 8, 15)),
        'country': 'Kazakhstan',
        'city': 'Almaty',
        'site': 'Warehouse Gamma',
        'fault_description': 'Communication lost with monitoring portal.',
        'fault_type': 'communication',
        'solution': 'Firmware re-flashed, RS485 cable replaced. Resolved.',
        'replaced': 0,
        'new_asn': null,
        'old_location': 'customerSite',
        'approved_by': 'S. Mirzayev',
        'notes': '',
        'photos': '[]',
        'documents': '[]',
        'created_at': iso(now.subtract(const Duration(days: 60))),
        'updated_at': iso(now.subtract(const Duration(days: 10))),
      },
    ];

    final batch = db.batch();
    for (final row in demo) {
      batch.insert('inverters', row);
    }

    batch.insert('service_events', {
      'id': 'evt-1',
      'inverter_asn': 'ASN-2023-0001',
      'type': 'fault',
      'date': iso(DateTime(2023, 11, 4)),
      'title': 'Overheating shutdown',
      'description': 'Unit reported E-014 thermal fault during peak load.',
      'technician': 'A. Karimov',
    });
    batch.insert('service_events', {
      'id': 'evt-2',
      'inverter_asn': 'ASN-2023-0001',
      'type': 'repair',
      'date': iso(DateTime(2023, 11, 10)),
      'title': 'Cooling fan replaced',
      'description': 'Installed new fan assembly, cleaned heatsink fins.',
      'technician': 'A. Karimov',
    });
    batch.insert('service_events', {
      'id': 'evt-3',
      'inverter_asn': 'ASN-2023-0001',
      'type': 'replacement',
      'date': iso(DateTime(2024, 1, 18)),
      'title': 'Unit swapped to ASN-2024-0042',
      'description': 'Fault persisted after repair, replaced under warranty.',
      'technician': 'Service Center',
    });

    await batch.commit(noResult: true);
  }
}
