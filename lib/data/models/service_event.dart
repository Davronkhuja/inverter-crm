import '../../core/constants/enums.dart';

/// Одно событие в журнале обслуживания инвертора:
/// зарегистрированная неисправность, выполненный ремонт, осмотр или замена.
/// Из этих событий строятся "Fault history" и "Repair history" на детальной странице.
class ServiceEvent {
  final String id;

  /// ASN инвертора, к которому относится событие (связь по серийному номеру).
  final String inverterAsn;
  final ServiceEventType type;
  final DateTime date;
  final String title;
  final String description;
  final String technician;

  const ServiceEvent({
    required this.id,
    required this.inverterAsn,
    required this.type,
    required this.date,
    required this.title,
    this.description = '',
    this.technician = '',
  });

  ServiceEvent copyWith({
    String? id,
    String? inverterAsn,
    ServiceEventType? type,
    DateTime? date,
    String? title,
    String? description,
    String? technician,
  }) {
    return ServiceEvent(
      id: id ?? this.id,
      inverterAsn: inverterAsn ?? this.inverterAsn,
      type: type ?? this.type,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      technician: technician ?? this.technician,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'inverter_asn': inverterAsn,
      'type': type.name,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'technician': technician,
    };
  }

  factory ServiceEvent.fromMap(Map<String, Object?> map) {
    return ServiceEvent(
      id: map['id'] as String,
      inverterAsn: map['inverter_asn'] as String,
      type: ServiceEventType.fromName(map['type'] as String?),
      date: DateTime.parse(map['date'] as String),
      title: (map['title'] as String?) ?? '',
      description: (map['description'] as String?) ?? '',
      technician: (map['technician'] as String?) ?? '',
    );
  }
}
