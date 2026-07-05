// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Inverter CRM';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navWarehouse => 'Ombor';

  @override
  String get navAccount => 'Hisob';

  @override
  String get statTotalUnits => 'Jami birliklar';

  @override
  String get statReplaced => 'Almashtirilgan';

  @override
  String get statOpenFaults => 'Ochiq nosozliklar';

  @override
  String get searchHint => 'ASN, mijoz, model, joylashuv bo‘yicha qidirish';

  @override
  String shownOfTotal(int shown, int total) {
    return '$total tadan $shown tasi ko‘rsatildi';
  }

  @override
  String get clearFilters => 'Filtrlarni tozalash';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get addInverter => 'Inverter qo‘shish';

  @override
  String get cardUnknownModel => 'Noma’lum model';

  @override
  String get cardStatusReplaced => 'Almashtirilgan';

  @override
  String get cardStatusActive => 'Faol';

  @override
  String cardInstalledOn(String date) {
    return 'O‘rnatilgan: $date';
  }

  @override
  String get emptyNoMatchesTitle => 'Mos kelmadi';

  @override
  String get emptyNoMatchesMessage =>
      'Qidiruv yoki filtrlarni o‘zgartirib ko‘ring.';

  @override
  String get emptyNoDataTitle => 'Hali inverterlar yo‘q';

  @override
  String get emptyNoDataMessage =>
      'Boshlash uchun birinchi inverter yozuvini qo‘shing.';

  @override
  String get errorTitle => 'Nimadir xato ketdi';

  @override
  String get exportTooltip => 'Eksport';

  @override
  String get exportToExcel => 'Excel’ga eksport';

  @override
  String get exportToPdf => 'PDF’ga eksport';

  @override
  String get exportNothing =>
      'Joriy filtrlar bo‘yicha eksport qilish uchun ma’lumot yo‘q.';

  @override
  String exportFailed(String error) {
    return 'Eksport amalga oshmadi: $error';
  }

  @override
  String get toggleTheme => 'Mavzuni almashtirish';

  @override
  String get filterTitle => 'Filtrlar';

  @override
  String get filterModel => 'Model';

  @override
  String get filterFaultType => 'Nosozlik turi';

  @override
  String get filterReplacedOnly => 'Faqat almashtirilganlar';

  @override
  String get filterActiveFaultsOnly => 'Faqat faol nosozliklar';

  @override
  String get filterStatusAll => 'Barchasi';

  @override
  String get filterStatusReplaced => 'Almashtirilgan';

  @override
  String get filterStatusNotReplaced => 'Almashtirilmagan';

  @override
  String get filterApply => 'Qo‘llash';

  @override
  String get filterReset => 'Tozalash';

  @override
  String get filterAllModels => 'Barcha modellar';

  @override
  String get filterAllFaults => 'Barcha nosozlik turlari';

  @override
  String get formNewTitle => 'Yangi inverter';

  @override
  String get formEditTitle => 'Inverterni tahrirlash';

  @override
  String get sectionIdentification => 'Identifikatsiya';

  @override
  String get fieldOrderNo => 'Buyurtma raqami (seriya)';

  @override
  String get fieldOrderNoAuto => 'Buyurtma raqami (avtomatik beriladi)';

  @override
  String get fieldModel => 'Inverter modeli *';

  @override
  String get fieldAsn => 'Inverter ASN (seriya raqami) *';

  @override
  String get fieldDataloggerSn => 'Datalogger SN';

  @override
  String get fieldClientName => 'Mijoz ismi *';

  @override
  String get sectionDates => 'Sanalar';

  @override
  String get fieldInstallationDate => 'O‘rnatish sanasi';

  @override
  String get fieldSaleDate => 'Sotuv sanasi';

  @override
  String get dateSelect => 'Tanlash';

  @override
  String get sectionLocation => 'O‘rnatish joyi';

  @override
  String get fieldCountry => 'Davlat';

  @override
  String get fieldCity => 'Shahar';

  @override
  String get fieldSite => 'Obyekt';

  @override
  String get sectionFault => 'Nosozlik va yechim';

  @override
  String get fieldFaultType => 'Nosozlik turi';

  @override
  String get fieldFaultDescription => 'Nosozlik tavsifi';

  @override
  String get fieldSolution => 'Yechim';

  @override
  String get fieldApprovedBy => 'Tasdiqlagan';

  @override
  String get sectionReplacement => 'Almashtirish';

  @override
  String get replacedSwitchTitle => 'Inverter almashtirilgan';

  @override
  String get replacedSwitchSubtitleOn =>
      'Almashtirilgan blokning ASN raqamini kiriting';

  @override
  String get replacedSwitchSubtitleOff =>
      'Agar bu blok almashtirilgan bo‘lsa, yoqing';

  @override
  String get fieldNewAsn => 'Yangi inverter ASN raqami *';

  @override
  String get fieldNewAsnValidator => 'Yangi ASN raqamini kiriting';

  @override
  String get fieldOldLocation => 'Eski inverterning hozirgi joylashuvi';

  @override
  String get sectionAttachments => 'Qo‘shimchalar va izohlar';

  @override
  String get attachmentPhotos => 'Fotosuratlar';

  @override
  String get attachmentDocuments => 'Hujjatlar';

  @override
  String get attachmentNoneAttached => 'Hech narsa biriktirilmagan';

  @override
  String attachmentCountAttached(int count) {
    return '$count ta biriktirilgan';
  }

  @override
  String get attachmentAdd => 'Qo‘shish';

  @override
  String get fieldNotes => 'Izohlar';

  @override
  String get saveChanges => 'O‘zgarishlarni saqlash';

  @override
  String get createRecord => 'Yozuv yaratish';

  @override
  String get requiredField => 'Majburiy maydon';

  @override
  String asnDuplicate(String asn) {
    return '\"$asn\" ASN raqami allaqachon mavjud. U yagona bo‘lishi kerak.';
  }

  @override
  String saveFailed(String error) {
    return 'Saqlash amalga oshmadi: $error';
  }

  @override
  String get photoTakePhoto => 'Surat olish';

  @override
  String get photoChooseGallery => 'Galereyadan tanlash';

  @override
  String photoAddFailed(String error) {
    return 'Fotosurat qo‘shilmadi: $error';
  }

  @override
  String documentAddFailed(String error) {
    return 'Hujjat qo‘shilmadi: $error';
  }

  @override
  String get oldLocationWarehouse => 'Ombor';

  @override
  String get oldLocationServiceCenter => 'Servis markazi';

  @override
  String get oldLocationCustomerSite => 'Mijoz obyekti';

  @override
  String get oldLocationReturnedToFactory => 'Zavodga qaytarilgan';

  @override
  String get oldLocationScrapped => 'Chiqindiga chiqarilgan';

  @override
  String get oldLocationOther => 'Boshqa';

  @override
  String get faultNone => 'Nosozlik yo‘q';

  @override
  String get faultOverheating => 'Qizib ketish';

  @override
  String get faultNoPower => 'Quvvat chiqishi yo‘q';

  @override
  String get faultCommunication => 'Aloqa xatosi';

  @override
  String get faultFanFailure => 'Ventilyator nosozligi';

  @override
  String get faultGridFault => 'Tarmoq xatosi';

  @override
  String get faultDisplayFailure => 'Displey nosozligi';

  @override
  String get faultSoftwareError => 'Dasturiy xato';

  @override
  String get faultIsolationFault => 'Izolyatsiya xatosi';

  @override
  String get faultOverVoltage => 'Kuchlanish ortishi';

  @override
  String get faultOther => 'Boshqa';

  @override
  String get detailTitle => 'Inverter tafsilotlari';

  @override
  String get detailEdit => 'Tahrirlash';

  @override
  String get detailDelete => 'O‘chirish';

  @override
  String get detailDeleteConfirmTitle => 'Inverterni o‘chirish?';

  @override
  String get detailDeleteConfirmMessage =>
      'Bu yozuv va uning xizmat ko‘rsatish tarixi butunlay o‘chiriladi.';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get delete => 'O‘chirish';

  @override
  String get detailReplacementChain => 'Almashtirish zanjiri';

  @override
  String get chainCurrent => 'Joriy';

  @override
  String get detailServiceHistory => 'Xizmat ko‘rsatish tarixi';

  @override
  String get detailNoEvents => 'Xizmat ko‘rsatish voqealari qayd etilmagan.';

  @override
  String get detailNotFound => 'Yozuv topilmadi';

  @override
  String get detailGeneralInfo => 'Umumiy ma’lumot';

  @override
  String get detailFaultSection => 'Nosozlik va yechim';

  @override
  String get detailNoFault => 'Nosozlik yo‘q';

  @override
  String get detailReplacementSection => 'Almashtirish';

  @override
  String get detailReplacementHistory => 'Almashtirish tarixi';

  @override
  String get detailFaultRepairHistory => 'Nosozlik va ta’mirlash tarixi';

  @override
  String get detailAddEvent => 'Voqea qo‘shish';

  @override
  String get detailPhotos => 'Fotosuratlar';

  @override
  String get detailDocuments => 'Hujjatlar';

  @override
  String get detailNotes => 'Izohlar';

  @override
  String get detailActiveNotReplaced =>
      'Bu inverter ishlamoqda va almashtirilmagan.';

  @override
  String detailOldLocationLabel(String location) {
    return 'Eski blok: $location';
  }

  @override
  String get detailReplacementFor => 'Quyidagiga almashtirilgan';

  @override
  String get detailReplacedBy => 'Quyidagi bilan almashtirilgan';

  @override
  String get detailOldLocationField => 'Eski inverterning hozirgi joylashuvi';

  @override
  String get detailNewAsnField => 'Yangi inverter ASN raqami';

  @override
  String detailNotInDatabase(String asn) {
    return '$asn  (bazada yo‘q)';
  }

  @override
  String get detailNoServiceEvents =>
      'Xizmat ko‘rsatish voqealari yo‘q. Nosozlik yoki ta’mirlash qo‘shish uchun + tugmasini bosing.';

  @override
  String get fieldOrderNoLabel => 'Buyurtma raqami';

  @override
  String get fieldAsnLabel => 'Inverter ASN';

  @override
  String get fieldModelLabel => 'Model';

  @override
  String get fieldClientLabel => 'Mijoz';

  @override
  String get fieldInstallLocationLabel => 'O‘rnatish joyi';

  @override
  String get addEventTitle => 'Xizmat ko‘rsatish voqeasini qo‘shish';

  @override
  String get eventTitleField => 'Nomi *';

  @override
  String get eventDescriptionField => 'Tavsif';

  @override
  String get eventTechnicianField => 'Texnik';

  @override
  String get eventDateField => 'Sana';

  @override
  String get eventAddButton => 'Voqea qo‘shish';

  @override
  String get eventRequired => 'Majburiy';

  @override
  String get serviceFault => 'Nosozlik';

  @override
  String get serviceRepair => 'Ta’mirlash';

  @override
  String get serviceInspection => 'Tekshiruv';

  @override
  String get serviceReplacement => 'Almashtirish';

  @override
  String get warehouseTitle => 'Ombor';

  @override
  String get warehouseTotalInStock => 'Omborda mavjud';

  @override
  String get warehouseAtCustomers => 'Mijozlarda';

  @override
  String get warehouseAtService => 'Servisda';

  @override
  String get warehouseByLocation => 'Joylashuv bo‘yicha';

  @override
  String get warehouseByModel => 'Model bo‘yicha';

  @override
  String get warehouseEmpty => 'Hozircha ombor ma’lumotlari yo‘q.';

  @override
  String get accountTitle => 'Hisob';

  @override
  String get accountAppearance => 'Ko‘rinish';

  @override
  String get accountTheme => 'Mavzu';

  @override
  String get appearanceLabel => 'Uslub';

  @override
  String get appearancePower => 'Quvvat';

  @override
  String get appearanceNature => 'Tabiat';

  @override
  String get appearanceTech => 'Texno';

  @override
  String get accountDataExport => 'Ma’lumotlarni eksport qilish';

  @override
  String get exportDescription => 'Barcha inverter yozuvlarini eksport qiling.';

  @override
  String get themeSystem => 'Tizim';

  @override
  String get themeLight => 'Yorug‘';

  @override
  String get themeDark => 'Qorong‘i';

  @override
  String get accountLanguage => 'Til';

  @override
  String get languageUzbek => 'O‘zbekcha';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get accountSecurity => 'Xavfsizlik';

  @override
  String get securityAppLock => 'Ilova qulfi';

  @override
  String get securityAppLockSubtitle =>
      'Ilovani ochishda PIN yoki biometriya talab qilinsin';

  @override
  String get securityChangePin => 'PIN’ni o‘zgartirish';

  @override
  String get securitySetPin => 'PIN o‘rnatish';

  @override
  String get securityBiometric => 'Biometriyadan foydalanish';

  @override
  String get securityBiometricSubtitle =>
      'Barmoq izi yoki yuz orqali qulfdan chiqish';

  @override
  String get accountAbout => 'Ilova haqida';

  @override
  String get accountVersion => 'Versiya';

  @override
  String get lockTitle => 'PIN kiriting';

  @override
  String get lockSubtitle => 'Qulfdan chiqish uchun PIN’ni kiriting';

  @override
  String get lockUseBiometric => 'Biometriyadan foydalanish';

  @override
  String get lockWrongPin => 'PIN noto‘g‘ri, qaytadan urinib ko‘ring.';

  @override
  String get lockForgotHint =>
      'PIN’ni unutgan bo‘lsangiz, administratorga murojaat qiling.';

  @override
  String get pinSetupTitle => 'PIN o‘rnating';

  @override
  String get pinSetupSubtitle =>
      'Ilovani himoyalash uchun 4 xonali PIN yarating';

  @override
  String get pinConfirmTitle => 'PIN’ni tasdiqlang';

  @override
  String get pinConfirmSubtitle => 'Tasdiqlash uchun PIN’ni qayta kiriting';

  @override
  String get pinMismatch => 'PIN kodlar mos kelmadi. Qaytadan urinib ko‘ring.';

  @override
  String get pinSavedSuccess => 'PIN muvaffaqiyatli o‘rnatildi.';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Saqlash';

  @override
  String get yes => 'Ha';

  @override
  String get no => 'Yo’q';

  @override
  String get sortBy => 'Saralash';

  @override
  String get sortByDate => 'O’rnatish sanasi';

  @override
  String get sortByModel => 'Model';

  @override
  String get sortByClient => 'Mijoz';

  @override
  String get sortByOrderNo => 'Tartib raqami';

  @override
  String get sortAscending => 'O’sish tartibida';

  @override
  String get sortDescending => 'Kamayish tartibida';

  @override
  String get warrantyExpired => 'Kafolat tugagan';

  @override
  String warrantyDaysLeft(int days) {
    return '$days kun qoldi';
  }

  @override
  String get navAnalytics => 'Statistika';

  @override
  String get analyticsTitle => 'Statistika';

  @override
  String get analyticsByFaultType => 'Nosozlik turlari';

  @override
  String get analyticsByModel => 'Modellar bo’yicha';

  @override
  String get analyticsByStatus => 'Holat bo’yicha';

  @override
  String get analyticsNoData => 'Ma’lumot yo’q';

  @override
  String analyticsRecords(int count) {
    return '$count ta yozuv';
  }

  @override
  String get exportColOrderNo => 'Buyurtma raqami';

  @override
  String get exportColModel => 'Model';

  @override
  String get exportColAsn => 'ASN';

  @override
  String get exportColDataloggerSn => 'Datalogger SN';

  @override
  String get exportColClient => 'Mijoz';

  @override
  String get exportColInstallDate => 'O’rnatish sanasi';

  @override
  String get exportColSaleDate => 'Sotuv sanasi';

  @override
  String get exportColLocation => 'Joylashuv';

  @override
  String get exportColFaultType => 'Nosozlik turi';

  @override
  String get exportColFaultDesc => 'Nosozlik tavsifi';

  @override
  String get exportColSolution => 'Yechim';

  @override
  String get exportColApprovedBy => 'Tasdiqlagan';

  @override
  String get exportColReplaced => 'Almashtirilgan';

  @override
  String get exportColNewAsn => 'Yangi ASN';

  @override
  String get exportColOldLocation => 'Eski joylashuv';

  @override
  String get exportYes => 'Ha';

  @override
  String get exportNo => 'Yo’q';

  @override
  String get exportNoFault => 'Nosozlik yo’q';

  @override
  String get exportActiveSheet => 'Faol inverterlar';

  @override
  String get exportWarehouseSheet => 'Ombor';

  @override
  String get shareInverter => 'Ulashish';
}
