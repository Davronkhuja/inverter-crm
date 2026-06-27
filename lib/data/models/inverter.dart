import 'dart:convert';

import '../../core/constants/enums.dart';

/// Главная сущность CRM — запись об инверторе: продажа, установка,
/// неисправность, решение, статус замены и местонахождение старого блока.
///
/// Связывание замен реализовано через [asn] (уникальный серийный номер) и
/// [newAsn] (ASN инвертора, который пришёл на замену). Это позволяет строить
/// цепочку: Old ASN -> New ASN -> Next ASN, не теряя историю.
class Inverter {
  final String id;

  /// Порядковый/складской номер заказа (Order No).
  final String orderNo;
  final String model;

  /// ASN — серийный номер инвертора. Уникален, служит ключом связывания.
  final String asn;
  final String clientName;

  final DateTime? installationDate;
  final DateTime? saleDate;

  // Местоположение установки (Страна / Город / Объект).
  final String country;
  final String city;
  final String site;

  final String faultDescription;
  final FaultType faultType;
  final String solution;

  /// Был ли инвертор заменён (Replacement Status Yes/No).
  final bool replaced;

  /// ASN нового инвертора (если заменён). Кликабелен в UI.
  final String? newAsn;

  /// Текущее местонахождение старого (заменённого) инвертора.
  final OldInverterLocation oldInverterLocation;

  final String notes;

  /// Пути к прикреплённым фотографиям.
  final List<String> photos;

  /// Пути к прикреплённым документам.
  final List<String> documents;

  final DateTime createdAt;
  final DateTime updatedAt;

  const Inverter({
    required this.id,
    required this.orderNo,
    required this.model,
    required this.asn,
    required this.clientName,
    this.installationDate,
    this.saleDate,
    this.country = '',
    this.city = '',
    this.site = '',
    this.faultDescription = '',
    this.faultType = FaultType.none,
    this.solution = '',
    this.replaced = false,
    this.newAsn,
    this.oldInverterLocation = OldInverterLocation.warehouse,
    this.notes = '',
    this.photos = const [],
    this.documents = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Локация одной строкой для отображения и поиска.
  String get locationLabel {
    final parts = [site, city, country].where((p) => p.trim().isNotEmpty);
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  bool get hasNewReplacement =>
      replaced && (newAsn != null && newAsn!.trim().isNotEmpty);

  Inverter copyWith({
    String? id,
    String? orderNo,
    String? model,
    String? asn,
    String? clientName,
    DateTime? installationDate,
    DateTime? saleDate,
    String? country,
    String? city,
    String? site,
    String? faultDescription,
    FaultType? faultType,
    String? solution,
    bool? replaced,
    String? newAsn,
    bool clearNewAsn = false,
    OldInverterLocation? oldInverterLocation,
    String? notes,
    List<String>? photos,
    List<String>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Inverter(
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      model: model ?? this.model,
      asn: asn ?? this.asn,
      clientName: clientName ?? this.clientName,
      installationDate: installationDate ?? this.installationDate,
      saleDate: saleDate ?? this.saleDate,
      country: country ?? this.country,
      city: city ?? this.city,
      site: site ?? this.site,
      faultDescription: faultDescription ?? this.faultDescription,
      faultType: faultType ?? this.faultType,
      solution: solution ?? this.solution,
      replaced: replaced ?? this.replaced,
      newAsn: clearNewAsn ? null : (newAsn ?? this.newAsn),
      oldInverterLocation: oldInverterLocation ?? this.oldInverterLocation,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'order_no': orderNo,
      'model': model,
      'asn': asn,
      'client_name': clientName,
      'installation_date': installationDate?.toIso8601String(),
      'sale_date': saleDate?.toIso8601String(),
      'country': country,
      'city': city,
      'site': site,
      'fault_description': faultDescription,
      'fault_type': faultType.name,
      'solution': solution,
      'replaced': replaced ? 1 : 0,
      'new_asn': newAsn,
      'old_location': oldInverterLocation.name,
      'notes': notes,
      'photos': jsonEncode(photos),
      'documents': jsonEncode(documents),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Inverter.fromMap(Map<String, Object?> map) {
    List<String> decodeList(Object? raw) {
      if (raw == null || (raw as String).isEmpty) return const [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => e.toString()).toList();
    }

    DateTime? parseDate(Object? raw) {
      if (raw == null || (raw as String).isEmpty) return null;
      return DateTime.tryParse(raw);
    }

    return Inverter(
      id: map['id'] as String,
      orderNo: (map['order_no'] as String?) ?? '',
      model: (map['model'] as String?) ?? '',
      asn: (map['asn'] as String?) ?? '',
      clientName: (map['client_name'] as String?) ?? '',
      installationDate: parseDate(map['installation_date']),
      saleDate: parseDate(map['sale_date']),
      country: (map['country'] as String?) ?? '',
      city: (map['city'] as String?) ?? '',
      site: (map['site'] as String?) ?? '',
      faultDescription: (map['fault_description'] as String?) ?? '',
      faultType: FaultType.fromName(map['fault_type'] as String?),
      solution: (map['solution'] as String?) ?? '',
      replaced: (map['replaced'] as int? ?? 0) == 1,
      newAsn: map['new_asn'] as String?,
      oldInverterLocation: OldInverterLocation.fromName(
        map['old_location'] as String?,
      ),
      notes: (map['notes'] as String?) ?? '',
      photos: decodeList(map['photos']),
      documents: decodeList(map['documents']),
      createdAt: parseDate(map['created_at']) ?? DateTime.now(),
      updatedAt: parseDate(map['updated_at']) ?? DateTime.now(),
    );
  }
}
