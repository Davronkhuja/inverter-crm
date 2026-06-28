import '../../core/constants/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_filter.dart';

/// Локализованные подписи для enum'ов через AppLocalizations.
/// Старые `.label` геттеры в enum-файлах остаются для мест, где контекст
/// локализации недоступен (например, генерация PDF/Excel вне build()).
extension OldInverterLocationL10n on OldInverterLocation {
  String l10n(AppLocalizations t) {
    switch (this) {
      case OldInverterLocation.warehouse:
        return t.oldLocationWarehouse;
      case OldInverterLocation.serviceCenter:
        return t.oldLocationServiceCenter;
      case OldInverterLocation.customerSite:
        return t.oldLocationCustomerSite;
      case OldInverterLocation.returnedToFactory:
        return t.oldLocationReturnedToFactory;
      case OldInverterLocation.scrapped:
        return t.oldLocationScrapped;
      case OldInverterLocation.other:
        return t.oldLocationOther;
    }
  }
}

extension FaultTypeL10n on FaultType {
  String l10n(AppLocalizations t) {
    switch (this) {
      case FaultType.none:
        return t.faultNone;
      case FaultType.overheating:
        return t.faultOverheating;
      case FaultType.noPower:
        return t.faultNoPower;
      case FaultType.communication:
        return t.faultCommunication;
      case FaultType.fanFailure:
        return t.faultFanFailure;
      case FaultType.gridFault:
        return t.faultGridFault;
      case FaultType.displayFailure:
        return t.faultDisplayFailure;
      case FaultType.softwareError:
        return t.faultSoftwareError;
      case FaultType.isolationFault:
        return t.faultIsolationFault;
      case FaultType.overVoltage:
        return t.faultOverVoltage;
      case FaultType.other:
        return t.faultOther;
    }
  }
}

extension ReplacedFilterL10n on ReplacedFilter {
  String l10n(AppLocalizations t) {
    switch (this) {
      case ReplacedFilter.any:
        return t.filterStatusAll;
      case ReplacedFilter.replaced:
        return t.filterStatusReplaced;
      case ReplacedFilter.notReplaced:
        return t.filterStatusNotReplaced;
    }
  }
}

extension ServiceEventTypeL10n on ServiceEventType {
  String l10n(AppLocalizations t) {
    switch (this) {
      case ServiceEventType.fault:
        return t.serviceFault;
      case ServiceEventType.repair:
        return t.serviceRepair;
      case ServiceEventType.inspection:
        return t.serviceInspection;
      case ServiceEventType.replacement:
        return t.serviceReplacement;
    }
  }
}
