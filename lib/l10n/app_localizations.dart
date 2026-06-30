import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Inverter CRM'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get navWarehouse;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @statTotalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total units'**
  String get statTotalUnits;

  /// No description provided for @statReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get statReplaced;

  /// No description provided for @statOpenFaults.
  ///
  /// In en, this message translates to:
  /// **'Open faults'**
  String get statOpenFaults;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search ASN, client, model, location'**
  String get searchHint;

  /// No description provided for @shownOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total} shown'**
  String shownOfTotal(int shown, int total);

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @addInverter.
  ///
  /// In en, this message translates to:
  /// **'Add inverter'**
  String get addInverter;

  /// No description provided for @cardUnknownModel.
  ///
  /// In en, this message translates to:
  /// **'Unknown model'**
  String get cardUnknownModel;

  /// No description provided for @cardStatusReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get cardStatusReplaced;

  /// No description provided for @cardStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cardStatusActive;

  /// No description provided for @cardInstalledOn.
  ///
  /// In en, this message translates to:
  /// **'Installed {date}'**
  String cardInstalledOn(String date);

  /// No description provided for @emptyNoMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get emptyNoMatchesTitle;

  /// No description provided for @emptyNoMatchesMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting search or filters.'**
  String get emptyNoMatchesMessage;

  /// No description provided for @emptyNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No inverters yet'**
  String get emptyNoDataTitle;

  /// No description provided for @emptyNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first inverter record to get started.'**
  String get emptyNoDataMessage;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @exportTooltip.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTooltip;

  /// No description provided for @exportToExcel.
  ///
  /// In en, this message translates to:
  /// **'Export to Excel'**
  String get exportToExcel;

  /// No description provided for @exportToPdf.
  ///
  /// In en, this message translates to:
  /// **'Export to PDF'**
  String get exportToPdf;

  /// No description provided for @exportNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export with current filters.'**
  String get exportNothing;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get toggleTheme;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterTitle;

  /// No description provided for @filterModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get filterModel;

  /// No description provided for @filterFaultType.
  ///
  /// In en, this message translates to:
  /// **'Fault type'**
  String get filterFaultType;

  /// No description provided for @filterReplacedOnly.
  ///
  /// In en, this message translates to:
  /// **'Replaced only'**
  String get filterReplacedOnly;

  /// No description provided for @filterActiveFaultsOnly.
  ///
  /// In en, this message translates to:
  /// **'Active faults only'**
  String get filterActiveFaultsOnly;

  /// No description provided for @filterStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterStatusAll;

  /// No description provided for @filterStatusReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get filterStatusReplaced;

  /// No description provided for @filterStatusNotReplaced.
  ///
  /// In en, this message translates to:
  /// **'Not replaced'**
  String get filterStatusNotReplaced;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @filterAllModels.
  ///
  /// In en, this message translates to:
  /// **'All models'**
  String get filterAllModels;

  /// No description provided for @filterAllFaults.
  ///
  /// In en, this message translates to:
  /// **'All fault types'**
  String get filterAllFaults;

  /// No description provided for @formNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New inverter'**
  String get formNewTitle;

  /// No description provided for @formEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit inverter'**
  String get formEditTitle;

  /// No description provided for @sectionIdentification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get sectionIdentification;

  /// No description provided for @fieldOrderNo.
  ///
  /// In en, this message translates to:
  /// **'Order No (serial)'**
  String get fieldOrderNo;

  /// No description provided for @fieldOrderNoAuto.
  ///
  /// In en, this message translates to:
  /// **'Order No (auto-generated)'**
  String get fieldOrderNoAuto;

  /// No description provided for @fieldModel.
  ///
  /// In en, this message translates to:
  /// **'Inverter model *'**
  String get fieldModel;

  /// No description provided for @fieldAsn.
  ///
  /// In en, this message translates to:
  /// **'Inverter ASN (serial number) *'**
  String get fieldAsn;

  /// No description provided for @fieldClientName.
  ///
  /// In en, this message translates to:
  /// **'Client name *'**
  String get fieldClientName;

  /// No description provided for @sectionDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get sectionDates;

  /// No description provided for @fieldInstallationDate.
  ///
  /// In en, this message translates to:
  /// **'Installation date'**
  String get fieldInstallationDate;

  /// No description provided for @fieldSaleDate.
  ///
  /// In en, this message translates to:
  /// **'Sale date'**
  String get fieldSaleDate;

  /// No description provided for @dateSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get dateSelect;

  /// No description provided for @sectionLocation.
  ///
  /// In en, this message translates to:
  /// **'Installation location'**
  String get sectionLocation;

  /// No description provided for @fieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get fieldCountry;

  /// No description provided for @fieldCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get fieldCity;

  /// No description provided for @fieldSite.
  ///
  /// In en, this message translates to:
  /// **'Site / object'**
  String get fieldSite;

  /// No description provided for @sectionFault.
  ///
  /// In en, this message translates to:
  /// **'Fault & solution'**
  String get sectionFault;

  /// No description provided for @fieldFaultType.
  ///
  /// In en, this message translates to:
  /// **'Fault type'**
  String get fieldFaultType;

  /// No description provided for @fieldFaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Fault description'**
  String get fieldFaultDescription;

  /// No description provided for @fieldSolution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get fieldSolution;

  /// No description provided for @fieldApprovedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved by'**
  String get fieldApprovedBy;

  /// No description provided for @sectionReplacement.
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get sectionReplacement;

  /// No description provided for @replacedSwitchTitle.
  ///
  /// In en, this message translates to:
  /// **'Inverter replaced'**
  String get replacedSwitchTitle;

  /// No description provided for @replacedSwitchSubtitleOn.
  ///
  /// In en, this message translates to:
  /// **'Link the replacement unit by its ASN'**
  String get replacedSwitchSubtitleOn;

  /// No description provided for @replacedSwitchSubtitleOff.
  ///
  /// In en, this message translates to:
  /// **'Turn on if this unit was swapped'**
  String get replacedSwitchSubtitleOff;

  /// No description provided for @fieldNewAsn.
  ///
  /// In en, this message translates to:
  /// **'New inverter ASN *'**
  String get fieldNewAsn;

  /// No description provided for @fieldNewAsnValidator.
  ///
  /// In en, this message translates to:
  /// **'Enter the new ASN'**
  String get fieldNewAsnValidator;

  /// No description provided for @fieldOldLocation.
  ///
  /// In en, this message translates to:
  /// **'Old inverter current location'**
  String get fieldOldLocation;

  /// No description provided for @sectionAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments & notes'**
  String get sectionAttachments;

  /// No description provided for @attachmentPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get attachmentPhotos;

  /// No description provided for @attachmentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get attachmentDocuments;

  /// No description provided for @attachmentNoneAttached.
  ///
  /// In en, this message translates to:
  /// **'None attached'**
  String get attachmentNoneAttached;

  /// No description provided for @attachmentCountAttached.
  ///
  /// In en, this message translates to:
  /// **'{count} attached'**
  String attachmentCountAttached(int count);

  /// No description provided for @attachmentAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get attachmentAdd;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @createRecord.
  ///
  /// In en, this message translates to:
  /// **'Create record'**
  String get createRecord;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @asnDuplicate.
  ///
  /// In en, this message translates to:
  /// **'ASN \"{asn}\" already exists. It must be unique.'**
  String asnDuplicate(String asn);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// No description provided for @photoTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get photoTakePhoto;

  /// No description provided for @photoChooseGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoChooseGallery;

  /// No description provided for @photoAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add photo: {error}'**
  String photoAddFailed(String error);

  /// No description provided for @documentAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add document: {error}'**
  String documentAddFailed(String error);

  /// No description provided for @oldLocationWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get oldLocationWarehouse;

  /// No description provided for @oldLocationServiceCenter.
  ///
  /// In en, this message translates to:
  /// **'Service Center'**
  String get oldLocationServiceCenter;

  /// No description provided for @oldLocationCustomerSite.
  ///
  /// In en, this message translates to:
  /// **'Customer Site'**
  String get oldLocationCustomerSite;

  /// No description provided for @oldLocationReturnedToFactory.
  ///
  /// In en, this message translates to:
  /// **'Returned to Factory'**
  String get oldLocationReturnedToFactory;

  /// No description provided for @oldLocationScrapped.
  ///
  /// In en, this message translates to:
  /// **'Scrapped'**
  String get oldLocationScrapped;

  /// No description provided for @oldLocationOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get oldLocationOther;

  /// No description provided for @faultNone.
  ///
  /// In en, this message translates to:
  /// **'No Fault'**
  String get faultNone;

  /// No description provided for @faultOverheating.
  ///
  /// In en, this message translates to:
  /// **'Overheating'**
  String get faultOverheating;

  /// No description provided for @faultNoPower.
  ///
  /// In en, this message translates to:
  /// **'No Power Output'**
  String get faultNoPower;

  /// No description provided for @faultCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication Error'**
  String get faultCommunication;

  /// No description provided for @faultFanFailure.
  ///
  /// In en, this message translates to:
  /// **'Fan Failure'**
  String get faultFanFailure;

  /// No description provided for @faultGridFault.
  ///
  /// In en, this message translates to:
  /// **'Grid Fault'**
  String get faultGridFault;

  /// No description provided for @faultDisplayFailure.
  ///
  /// In en, this message translates to:
  /// **'Display Failure'**
  String get faultDisplayFailure;

  /// No description provided for @faultSoftwareError.
  ///
  /// In en, this message translates to:
  /// **'Software Error'**
  String get faultSoftwareError;

  /// No description provided for @faultIsolationFault.
  ///
  /// In en, this message translates to:
  /// **'Isolation Fault'**
  String get faultIsolationFault;

  /// No description provided for @faultOverVoltage.
  ///
  /// In en, this message translates to:
  /// **'Over Voltage'**
  String get faultOverVoltage;

  /// No description provided for @faultOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get faultOther;

  /// No description provided for @detailTitle.
  ///
  /// In en, this message translates to:
  /// **'Inverter detail'**
  String get detailTitle;

  /// No description provided for @detailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get detailEdit;

  /// No description provided for @detailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get detailDelete;

  /// No description provided for @detailDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete inverter?'**
  String get detailDeleteConfirmTitle;

  /// No description provided for @detailDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this record and its service history.'**
  String get detailDeleteConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @detailReplacementChain.
  ///
  /// In en, this message translates to:
  /// **'Replacement chain'**
  String get detailReplacementChain;

  /// No description provided for @chainCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get chainCurrent;

  /// No description provided for @detailServiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service history'**
  String get detailServiceHistory;

  /// No description provided for @detailNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No service events recorded.'**
  String get detailNoEvents;

  /// No description provided for @detailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get detailNotFound;

  /// No description provided for @detailGeneralInfo.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get detailGeneralInfo;

  /// No description provided for @detailFaultSection.
  ///
  /// In en, this message translates to:
  /// **'Fault & solution'**
  String get detailFaultSection;

  /// No description provided for @detailNoFault.
  ///
  /// In en, this message translates to:
  /// **'No fault'**
  String get detailNoFault;

  /// No description provided for @detailReplacementSection.
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get detailReplacementSection;

  /// No description provided for @detailReplacementHistory.
  ///
  /// In en, this message translates to:
  /// **'Replacement history'**
  String get detailReplacementHistory;

  /// No description provided for @detailFaultRepairHistory.
  ///
  /// In en, this message translates to:
  /// **'Fault & repair history'**
  String get detailFaultRepairHistory;

  /// No description provided for @detailAddEvent.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get detailAddEvent;

  /// No description provided for @detailPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get detailPhotos;

  /// No description provided for @detailDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get detailDocuments;

  /// No description provided for @detailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get detailNotes;

  /// No description provided for @detailActiveNotReplaced.
  ///
  /// In en, this message translates to:
  /// **'This inverter is in service and has not been replaced.'**
  String get detailActiveNotReplaced;

  /// No description provided for @detailOldLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Old unit: {location}'**
  String detailOldLocationLabel(String location);

  /// No description provided for @detailReplacementFor.
  ///
  /// In en, this message translates to:
  /// **'Replacement for'**
  String get detailReplacementFor;

  /// No description provided for @detailReplacedBy.
  ///
  /// In en, this message translates to:
  /// **'Replaced by'**
  String get detailReplacedBy;

  /// No description provided for @detailOldLocationField.
  ///
  /// In en, this message translates to:
  /// **'Old inverter current location'**
  String get detailOldLocationField;

  /// No description provided for @detailNewAsnField.
  ///
  /// In en, this message translates to:
  /// **'New inverter ASN'**
  String get detailNewAsnField;

  /// No description provided for @detailNotInDatabase.
  ///
  /// In en, this message translates to:
  /// **'{asn}  (not in database)'**
  String detailNotInDatabase(String asn);

  /// No description provided for @detailNoServiceEvents.
  ///
  /// In en, this message translates to:
  /// **'No service events logged. Tap + to add a fault or repair.'**
  String get detailNoServiceEvents;

  /// No description provided for @fieldOrderNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Order No'**
  String get fieldOrderNoLabel;

  /// No description provided for @fieldAsnLabel.
  ///
  /// In en, this message translates to:
  /// **'Inverter ASN'**
  String get fieldAsnLabel;

  /// No description provided for @fieldModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get fieldModelLabel;

  /// No description provided for @fieldClientLabel.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get fieldClientLabel;

  /// No description provided for @fieldInstallLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Installation location'**
  String get fieldInstallLocationLabel;

  /// No description provided for @addEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Add service event'**
  String get addEventTitle;

  /// No description provided for @eventTitleField.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get eventTitleField;

  /// No description provided for @eventDescriptionField.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get eventDescriptionField;

  /// No description provided for @eventTechnicianField.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get eventTechnicianField;

  /// No description provided for @eventDateField.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDateField;

  /// No description provided for @eventAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get eventAddButton;

  /// No description provided for @eventRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get eventRequired;

  /// No description provided for @serviceFault.
  ///
  /// In en, this message translates to:
  /// **'Fault'**
  String get serviceFault;

  /// No description provided for @serviceRepair.
  ///
  /// In en, this message translates to:
  /// **'Repair'**
  String get serviceRepair;

  /// No description provided for @serviceInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get serviceInspection;

  /// No description provided for @serviceReplacement.
  ///
  /// In en, this message translates to:
  /// **'Replacement'**
  String get serviceReplacement;

  /// No description provided for @warehouseTitle.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouseTitle;

  /// No description provided for @warehouseTotalInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get warehouseTotalInStock;

  /// No description provided for @warehouseAtCustomers.
  ///
  /// In en, this message translates to:
  /// **'At customers'**
  String get warehouseAtCustomers;

  /// No description provided for @warehouseAtService.
  ///
  /// In en, this message translates to:
  /// **'At service'**
  String get warehouseAtService;

  /// No description provided for @warehouseByLocation.
  ///
  /// In en, this message translates to:
  /// **'By location'**
  String get warehouseByLocation;

  /// No description provided for @warehouseByModel.
  ///
  /// In en, this message translates to:
  /// **'By model'**
  String get warehouseByModel;

  /// No description provided for @warehouseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No inventory data yet.'**
  String get warehouseEmpty;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @accountAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get accountAppearance;

  /// No description provided for @accountTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get accountTheme;

  /// No description provided for @appearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get appearanceLabel;

  /// No description provided for @appearancePower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get appearancePower;

  /// No description provided for @appearanceNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get appearanceNature;

  /// No description provided for @appearanceTech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get appearanceTech;

  /// No description provided for @accountDataExport.
  ///
  /// In en, this message translates to:
  /// **'Data export'**
  String get accountDataExport;

  /// No description provided for @exportDescription.
  ///
  /// In en, this message translates to:
  /// **'Export the inverters currently visible on the dashboard.'**
  String get exportDescription;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @languageUzbek.
  ///
  /// In en, this message translates to:
  /// **'O‘zbekcha'**
  String get languageUzbek;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get accountSecurity;

  /// No description provided for @securityAppLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get securityAppLock;

  /// No description provided for @securityAppLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require PIN or biometrics to open the app'**
  String get securityAppLockSubtitle;

  /// No description provided for @securityChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get securityChangePin;

  /// No description provided for @securitySetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get securitySetPin;

  /// No description provided for @securityBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get securityBiometric;

  /// No description provided for @securityBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint or face'**
  String get securityBiometricSubtitle;

  /// No description provided for @accountAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get accountAbout;

  /// No description provided for @accountVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get accountVersion;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get lockTitle;

  /// No description provided for @lockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to unlock'**
  String get lockSubtitle;

  /// No description provided for @lockUseBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get lockUseBiometric;

  /// No description provided for @lockWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN, try again.'**
  String get lockWrongPin;

  /// No description provided for @lockForgotHint.
  ///
  /// In en, this message translates to:
  /// **'Contact your administrator if you forgot your PIN.'**
  String get lockForgotHint;

  /// No description provided for @pinSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN'**
  String get pinSetupTitle;

  /// No description provided for @pinSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a 4-digit PIN to protect the app'**
  String get pinSetupSubtitle;

  /// No description provided for @pinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get pinConfirmTitle;

  /// No description provided for @pinConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again to confirm'**
  String get pinConfirmSubtitle;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get pinMismatch;

  /// No description provided for @pinSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN set successfully.'**
  String get pinSavedSuccess;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
