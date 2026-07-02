// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inverter CRM';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navWarehouse => 'Warehouse';

  @override
  String get navAccount => 'Account';

  @override
  String get statTotalUnits => 'Total units';

  @override
  String get statReplaced => 'Replaced';

  @override
  String get statOpenFaults => 'Open faults';

  @override
  String get searchHint => 'Search ASN, client, model, location';

  @override
  String shownOfTotal(int shown, int total) {
    return '$shown of $total shown';
  }

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get retry => 'Retry';

  @override
  String get addInverter => 'Add inverter';

  @override
  String get cardUnknownModel => 'Unknown model';

  @override
  String get cardStatusReplaced => 'Replaced';

  @override
  String get cardStatusActive => 'Active';

  @override
  String cardInstalledOn(String date) {
    return 'Installed $date';
  }

  @override
  String get emptyNoMatchesTitle => 'No matches';

  @override
  String get emptyNoMatchesMessage => 'Try adjusting search or filters.';

  @override
  String get emptyNoDataTitle => 'No inverters yet';

  @override
  String get emptyNoDataMessage =>
      'Add your first inverter record to get started.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get exportTooltip => 'Export';

  @override
  String get exportToExcel => 'Export to Excel';

  @override
  String get exportToPdf => 'Export to PDF';

  @override
  String get exportNothing => 'Nothing to export with current filters.';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get toggleTheme => 'Toggle theme';

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterModel => 'Model';

  @override
  String get filterFaultType => 'Fault type';

  @override
  String get filterReplacedOnly => 'Replaced only';

  @override
  String get filterActiveFaultsOnly => 'Active faults only';

  @override
  String get filterStatusAll => 'All';

  @override
  String get filterStatusReplaced => 'Replaced';

  @override
  String get filterStatusNotReplaced => 'Not replaced';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterReset => 'Reset';

  @override
  String get filterAllModels => 'All models';

  @override
  String get filterAllFaults => 'All fault types';

  @override
  String get formNewTitle => 'New inverter';

  @override
  String get formEditTitle => 'Edit inverter';

  @override
  String get sectionIdentification => 'Identification';

  @override
  String get fieldOrderNo => 'Order No (serial)';

  @override
  String get fieldOrderNoAuto => 'Order No (auto-generated)';

  @override
  String get fieldModel => 'Inverter model *';

  @override
  String get fieldAsn => 'Inverter ASN (serial number) *';

  @override
  String get fieldDataloggerSn => 'Datalogger SN';

  @override
  String get fieldInverterSn => 'Inverter SN';

  @override
  String get fieldClientName => 'Client name *';

  @override
  String get sectionDates => 'Dates';

  @override
  String get fieldInstallationDate => 'Installation date';

  @override
  String get fieldSaleDate => 'Sale date';

  @override
  String get dateSelect => 'Select';

  @override
  String get sectionLocation => 'Installation location';

  @override
  String get fieldCountry => 'Country';

  @override
  String get fieldCity => 'City';

  @override
  String get fieldSite => 'Site / object';

  @override
  String get sectionFault => 'Fault & solution';

  @override
  String get fieldFaultType => 'Fault type';

  @override
  String get fieldFaultDescription => 'Fault description';

  @override
  String get fieldSolution => 'Solution';

  @override
  String get fieldApprovedBy => 'Approved by';

  @override
  String get sectionReplacement => 'Replacement';

  @override
  String get replacedSwitchTitle => 'Inverter replaced';

  @override
  String get replacedSwitchSubtitleOn => 'Link the replacement unit by its ASN';

  @override
  String get replacedSwitchSubtitleOff => 'Turn on if this unit was swapped';

  @override
  String get fieldNewAsn => 'New inverter ASN *';

  @override
  String get fieldNewAsnValidator => 'Enter the new ASN';

  @override
  String get fieldOldLocation => 'Old inverter current location';

  @override
  String get sectionAttachments => 'Attachments & notes';

  @override
  String get attachmentPhotos => 'Photos';

  @override
  String get attachmentDocuments => 'Documents';

  @override
  String get attachmentNoneAttached => 'None attached';

  @override
  String attachmentCountAttached(int count) {
    return '$count attached';
  }

  @override
  String get attachmentAdd => 'Add';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get createRecord => 'Create record';

  @override
  String get requiredField => 'Required field';

  @override
  String asnDuplicate(String asn) {
    return 'ASN \"$asn\" already exists. It must be unique.';
  }

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get photoTakePhoto => 'Take photo';

  @override
  String get photoChooseGallery => 'Choose from gallery';

  @override
  String photoAddFailed(String error) {
    return 'Could not add photo: $error';
  }

  @override
  String documentAddFailed(String error) {
    return 'Could not add document: $error';
  }

  @override
  String get oldLocationWarehouse => 'Warehouse';

  @override
  String get oldLocationServiceCenter => 'Service Center';

  @override
  String get oldLocationCustomerSite => 'Customer Site';

  @override
  String get oldLocationReturnedToFactory => 'Returned to Factory';

  @override
  String get oldLocationScrapped => 'Scrapped';

  @override
  String get oldLocationOther => 'Other';

  @override
  String get faultNone => 'No Fault';

  @override
  String get faultOverheating => 'Overheating';

  @override
  String get faultNoPower => 'No Power Output';

  @override
  String get faultCommunication => 'Communication Error';

  @override
  String get faultFanFailure => 'Fan Failure';

  @override
  String get faultGridFault => 'Grid Fault';

  @override
  String get faultDisplayFailure => 'Display Failure';

  @override
  String get faultSoftwareError => 'Software Error';

  @override
  String get faultIsolationFault => 'Isolation Fault';

  @override
  String get faultOverVoltage => 'Over Voltage';

  @override
  String get faultOther => 'Other';

  @override
  String get detailTitle => 'Inverter detail';

  @override
  String get detailEdit => 'Edit';

  @override
  String get detailDelete => 'Delete';

  @override
  String get detailDeleteConfirmTitle => 'Delete inverter?';

  @override
  String get detailDeleteConfirmMessage =>
      'This will permanently remove this record and its service history.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get detailReplacementChain => 'Replacement chain';

  @override
  String get chainCurrent => 'Current';

  @override
  String get detailServiceHistory => 'Service history';

  @override
  String get detailNoEvents => 'No service events recorded.';

  @override
  String get detailNotFound => 'Record not found';

  @override
  String get detailGeneralInfo => 'General information';

  @override
  String get detailFaultSection => 'Fault & solution';

  @override
  String get detailNoFault => 'No fault';

  @override
  String get detailReplacementSection => 'Replacement';

  @override
  String get detailReplacementHistory => 'Replacement history';

  @override
  String get detailFaultRepairHistory => 'Fault & repair history';

  @override
  String get detailAddEvent => 'Add event';

  @override
  String get detailPhotos => 'Photos';

  @override
  String get detailDocuments => 'Documents';

  @override
  String get detailNotes => 'Notes';

  @override
  String get detailActiveNotReplaced =>
      'This inverter is in service and has not been replaced.';

  @override
  String detailOldLocationLabel(String location) {
    return 'Old unit: $location';
  }

  @override
  String get detailReplacementFor => 'Replacement for';

  @override
  String get detailReplacedBy => 'Replaced by';

  @override
  String get detailOldLocationField => 'Old inverter current location';

  @override
  String get detailNewAsnField => 'New inverter ASN';

  @override
  String detailNotInDatabase(String asn) {
    return '$asn  (not in database)';
  }

  @override
  String get detailNoServiceEvents =>
      'No service events logged. Tap + to add a fault or repair.';

  @override
  String get fieldOrderNoLabel => 'Order No';

  @override
  String get fieldAsnLabel => 'Inverter ASN';

  @override
  String get fieldModelLabel => 'Model';

  @override
  String get fieldClientLabel => 'Client';

  @override
  String get fieldInstallLocationLabel => 'Installation location';

  @override
  String get addEventTitle => 'Add service event';

  @override
  String get eventTitleField => 'Title *';

  @override
  String get eventDescriptionField => 'Description';

  @override
  String get eventTechnicianField => 'Technician';

  @override
  String get eventDateField => 'Date';

  @override
  String get eventAddButton => 'Add event';

  @override
  String get eventRequired => 'Required';

  @override
  String get serviceFault => 'Fault';

  @override
  String get serviceRepair => 'Repair';

  @override
  String get serviceInspection => 'Inspection';

  @override
  String get serviceReplacement => 'Replacement';

  @override
  String get warehouseTitle => 'Warehouse';

  @override
  String get warehouseTotalInStock => 'In stock';

  @override
  String get warehouseAtCustomers => 'At customers';

  @override
  String get warehouseAtService => 'At service';

  @override
  String get warehouseByLocation => 'By location';

  @override
  String get warehouseByModel => 'By model';

  @override
  String get warehouseEmpty => 'No inventory data yet.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountAppearance => 'Appearance';

  @override
  String get accountTheme => 'Theme';

  @override
  String get appearanceLabel => 'Style';

  @override
  String get appearancePower => 'Power';

  @override
  String get appearanceNature => 'Nature';

  @override
  String get appearanceTech => 'Tech';

  @override
  String get accountDataExport => 'Data export';

  @override
  String get exportDescription =>
      'Export the inverters currently visible on the dashboard.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get accountLanguage => 'Language';

  @override
  String get languageUzbek => 'O‘zbekcha';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get accountSecurity => 'Security';

  @override
  String get securityAppLock => 'App lock';

  @override
  String get securityAppLockSubtitle =>
      'Require PIN or biometrics to open the app';

  @override
  String get securityChangePin => 'Change PIN';

  @override
  String get securitySetPin => 'Set PIN';

  @override
  String get securityBiometric => 'Use biometrics';

  @override
  String get securityBiometricSubtitle => 'Unlock with fingerprint or face';

  @override
  String get accountAbout => 'About';

  @override
  String get accountVersion => 'Version';

  @override
  String get lockTitle => 'Enter PIN';

  @override
  String get lockSubtitle => 'Enter your PIN to unlock';

  @override
  String get lockUseBiometric => 'Use biometrics';

  @override
  String get lockWrongPin => 'Incorrect PIN, try again.';

  @override
  String get lockForgotHint =>
      'Contact your administrator if you forgot your PIN.';

  @override
  String get pinSetupTitle => 'Set a PIN';

  @override
  String get pinSetupSubtitle => 'Create a 4-digit PIN to protect the app';

  @override
  String get pinConfirmTitle => 'Confirm PIN';

  @override
  String get pinConfirmSubtitle => 'Enter the PIN again to confirm';

  @override
  String get pinMismatch => 'PINs do not match. Try again.';

  @override
  String get pinSavedSuccess => 'PIN set successfully.';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
