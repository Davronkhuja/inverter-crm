import 'package:flutter/material.dart';

/// Текущее местонахождение старого (заменённого) инвертора.
/// Значения из ТЗ: Warehouse, Service Center, Customer Site,
/// Returned to Factory, Scrapped, Other.
enum OldInverterLocation {
  warehouse,
  serviceCenter,
  customerSite,
  returnedToFactory,
  scrapped,
  other;

  String get label {
    switch (this) {
      case OldInverterLocation.warehouse:
        return 'Warehouse';
      case OldInverterLocation.serviceCenter:
        return 'Service Center';
      case OldInverterLocation.customerSite:
        return 'Customer Site';
      case OldInverterLocation.returnedToFactory:
        return 'Returned to Factory';
      case OldInverterLocation.scrapped:
        return 'Scrapped';
      case OldInverterLocation.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case OldInverterLocation.warehouse:
        return Icons.warehouse_outlined;
      case OldInverterLocation.serviceCenter:
        return Icons.build_circle_outlined;
      case OldInverterLocation.customerSite:
        return Icons.location_on_outlined;
      case OldInverterLocation.returnedToFactory:
        return Icons.factory_outlined;
      case OldInverterLocation.scrapped:
        return Icons.delete_forever_outlined;
      case OldInverterLocation.other:
        return Icons.help_outline;
    }
  }

  static OldInverterLocation fromName(String? name) {
    return OldInverterLocation.values.firstWhere(
      (e) => e.name == name,
      orElse: () => OldInverterLocation.warehouse,
    );
  }
}

/// Тип неисправности — используется для фильтрации и аналитики.
enum FaultType {
  none,
  overheating,
  noPower,
  communication,
  fanFailure,
  gridFault,
  displayFailure,
  softwareError,
  isolationFault,
  overVoltage,
  other;

  String get label {
    switch (this) {
      case FaultType.none:
        return 'No Fault';
      case FaultType.overheating:
        return 'Overheating';
      case FaultType.noPower:
        return 'No Power Output';
      case FaultType.communication:
        return 'Communication Error';
      case FaultType.fanFailure:
        return 'Fan Failure';
      case FaultType.gridFault:
        return 'Grid Fault';
      case FaultType.displayFailure:
        return 'Display Failure';
      case FaultType.softwareError:
        return 'Software Error';
      case FaultType.isolationFault:
        return 'Isolation Fault';
      case FaultType.overVoltage:
        return 'Over Voltage';
      case FaultType.other:
        return 'Other';
    }
  }

  static FaultType fromName(String? name) {
    return FaultType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => FaultType.none,
    );
  }
}

/// Тип события в журнале обслуживания (история неисправностей и ремонтов).
enum ServiceEventType {
  fault,
  repair,
  inspection,
  replacement;

  String get label {
    switch (this) {
      case ServiceEventType.fault:
        return 'Fault';
      case ServiceEventType.repair:
        return 'Repair';
      case ServiceEventType.inspection:
        return 'Inspection';
      case ServiceEventType.replacement:
        return 'Replacement';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceEventType.fault:
        return Icons.warning_amber_rounded;
      case ServiceEventType.repair:
        return Icons.handyman_outlined;
      case ServiceEventType.inspection:
        return Icons.search_outlined;
      case ServiceEventType.replacement:
        return Icons.swap_horiz_rounded;
    }
  }

  Color color(ColorScheme scheme) {
    switch (this) {
      case ServiceEventType.fault:
        return scheme.error;
      case ServiceEventType.repair:
        return scheme.tertiary;
      case ServiceEventType.inspection:
        return scheme.secondary;
      case ServiceEventType.replacement:
        return scheme.primary;
    }
  }

  static ServiceEventType fromName(String? name) {
    return ServiceEventType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ServiceEventType.fault,
    );
  }
}
