// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Inverter CRM';

  @override
  String get navDashboard => 'Дашборд';

  @override
  String get navWarehouse => 'Склад';

  @override
  String get navAccount => 'Аккаунт';

  @override
  String get statTotalUnits => 'Всего единиц';

  @override
  String get statReplaced => 'Заменено';

  @override
  String get statOpenFaults => 'Открытые неисправности';

  @override
  String get searchHint => 'Поиск по ASN, клиенту, модели, локации';

  @override
  String shownOfTotal(int shown, int total) {
    return 'Показано $shown из $total';
  }

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get retry => 'Повторить';

  @override
  String get addInverter => 'Добавить инвертор';

  @override
  String get cardUnknownModel => 'Неизвестная модель';

  @override
  String get cardStatusReplaced => 'Заменён';

  @override
  String get cardStatusActive => 'Активен';

  @override
  String cardInstalledOn(String date) {
    return 'Установлен $date';
  }

  @override
  String get emptyNoMatchesTitle => 'Нет совпадений';

  @override
  String get emptyNoMatchesMessage => 'Попробуйте изменить поиск или фильтры.';

  @override
  String get emptyNoDataTitle => 'Пока нет инверторов';

  @override
  String get emptyNoDataMessage =>
      'Добавьте первую запись инвертора, чтобы начать.';

  @override
  String get errorTitle => 'Что-то пошло не так';

  @override
  String get exportTooltip => 'Экспорт';

  @override
  String get exportToExcel => 'Экспорт в Excel';

  @override
  String get exportToPdf => 'Экспорт в PDF';

  @override
  String get exportNothing => 'Нет данных для экспорта с текущими фильтрами.';

  @override
  String exportFailed(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get toggleTheme => 'Сменить тему';

  @override
  String get filterTitle => 'Фильтры';

  @override
  String get filterModel => 'Модель';

  @override
  String get filterFaultType => 'Тип неисправности';

  @override
  String get filterReplacedOnly => 'Только заменённые';

  @override
  String get filterActiveFaultsOnly => 'Только с активными неисправностями';

  @override
  String get filterStatusAll => 'Все';

  @override
  String get filterStatusReplaced => 'Заменён';

  @override
  String get filterStatusNotReplaced => 'Не заменён';

  @override
  String get filterApply => 'Применить';

  @override
  String get filterReset => 'Сбросить';

  @override
  String get filterAllModels => 'Все модели';

  @override
  String get filterAllFaults => 'Все типы неисправностей';

  @override
  String get formNewTitle => 'Новый инвертор';

  @override
  String get formEditTitle => 'Редактирование инвертора';

  @override
  String get sectionIdentification => 'Идентификация';

  @override
  String get fieldOrderNo => '№ заказа (серийный)';

  @override
  String get fieldOrderNoAuto => '№ заказа (создаётся автоматически)';

  @override
  String get fieldModel => 'Модель инвертора *';

  @override
  String get fieldAsn => 'ASN инвертора (серийный номер) *';

  @override
  String get fieldDataloggerSn => 'Datalogger SN';

  @override
  String get fieldClientName => 'Имя клиента *';

  @override
  String get sectionDates => 'Даты';

  @override
  String get fieldInstallationDate => 'Дата установки';

  @override
  String get fieldSaleDate => 'Дата продажи';

  @override
  String get dateSelect => 'Выбрать';

  @override
  String get sectionLocation => 'Место установки';

  @override
  String get fieldCountry => 'Страна';

  @override
  String get fieldCity => 'Город';

  @override
  String get fieldSite => 'Объект';

  @override
  String get sectionFault => 'Неисправность и решение';

  @override
  String get fieldFaultType => 'Тип неисправности';

  @override
  String get fieldFaultDescription => 'Описание неисправности';

  @override
  String get fieldSolution => 'Решение';

  @override
  String get fieldApprovedBy => 'Утверждено';

  @override
  String get sectionReplacement => 'Замена';

  @override
  String get replacedSwitchTitle => 'Инвертор заменён';

  @override
  String get replacedSwitchSubtitleOn => 'Укажите ASN заменяющего блока';

  @override
  String get replacedSwitchSubtitleOff =>
      'Включите, если этот блок был заменён';

  @override
  String get fieldNewAsn => 'ASN нового инвертора *';

  @override
  String get fieldNewAsnValidator => 'Введите новый ASN';

  @override
  String get fieldOldLocation => 'Текущее место старого инвертора';

  @override
  String get sectionAttachments => 'Вложения и заметки';

  @override
  String get attachmentPhotos => 'Фотографии';

  @override
  String get attachmentDocuments => 'Документы';

  @override
  String get attachmentNoneAttached => 'Нет вложений';

  @override
  String attachmentCountAttached(int count) {
    return 'Прикреплено: $count';
  }

  @override
  String get attachmentAdd => 'Добавить';

  @override
  String get fieldNotes => 'Заметки';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get createRecord => 'Создать запись';

  @override
  String get requiredField => 'Обязательное поле';

  @override
  String asnDuplicate(String asn) {
    return 'ASN «$asn» уже существует. Он должен быть уникальным.';
  }

  @override
  String saveFailed(String error) {
    return 'Ошибка сохранения: $error';
  }

  @override
  String get photoTakePhoto => 'Сделать фото';

  @override
  String get photoChooseGallery => 'Выбрать из галереи';

  @override
  String photoAddFailed(String error) {
    return 'Не удалось добавить фото: $error';
  }

  @override
  String documentAddFailed(String error) {
    return 'Не удалось добавить документ: $error';
  }

  @override
  String get oldLocationWarehouse => 'Склад';

  @override
  String get oldLocationServiceCenter => 'Сервисный центр';

  @override
  String get oldLocationCustomerSite => 'Объект клиента';

  @override
  String get oldLocationReturnedToFactory => 'Возвращён на завод';

  @override
  String get oldLocationScrapped => 'Списан';

  @override
  String get oldLocationOther => 'Другое';

  @override
  String get faultNone => 'Нет неисправности';

  @override
  String get faultOverheating => 'Перегрев';

  @override
  String get faultNoPower => 'Нет выходной мощности';

  @override
  String get faultCommunication => 'Ошибка связи';

  @override
  String get faultFanFailure => 'Отказ вентилятора';

  @override
  String get faultGridFault => 'Сбой сети';

  @override
  String get faultDisplayFailure => 'Отказ дисплея';

  @override
  String get faultSoftwareError => 'Программная ошибка';

  @override
  String get faultIsolationFault => 'Ошибка изоляции';

  @override
  String get faultOverVoltage => 'Перенапряжение';

  @override
  String get faultOther => 'Другое';

  @override
  String get detailTitle => 'Детали инвертора';

  @override
  String get detailEdit => 'Изменить';

  @override
  String get detailDelete => 'Удалить';

  @override
  String get detailDeleteConfirmTitle => 'Удалить инвертор?';

  @override
  String get detailDeleteConfirmMessage =>
      'Запись и история обслуживания будут удалены без возможности восстановления.';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get detailReplacementChain => 'Цепочка замен';

  @override
  String get chainCurrent => 'Текущий';

  @override
  String get detailServiceHistory => 'История обслуживания';

  @override
  String get detailNoEvents => 'Событий обслуживания не зафиксировано.';

  @override
  String get detailNotFound => 'Запись не найдена';

  @override
  String get detailGeneralInfo => 'Общая информация';

  @override
  String get detailFaultSection => 'Неисправность и решение';

  @override
  String get detailNoFault => 'Нет неисправности';

  @override
  String get detailReplacementSection => 'Замена';

  @override
  String get detailReplacementHistory => 'История замен';

  @override
  String get detailFaultRepairHistory => 'История неисправностей и ремонта';

  @override
  String get detailAddEvent => 'Добавить событие';

  @override
  String get detailPhotos => 'Фотографии';

  @override
  String get detailDocuments => 'Документы';

  @override
  String get detailNotes => 'Заметки';

  @override
  String get detailActiveNotReplaced =>
      'Этот инвертор в работе и не был заменён.';

  @override
  String detailOldLocationLabel(String location) {
    return 'Старый блок: $location';
  }

  @override
  String get detailReplacementFor => 'Замена для';

  @override
  String get detailReplacedBy => 'Заменён на';

  @override
  String get detailOldLocationField => 'Текущее место старого инвертора';

  @override
  String get detailNewAsnField => 'ASN нового инвертора';

  @override
  String detailNotInDatabase(String asn) {
    return '$asn  (нет в базе)';
  }

  @override
  String get detailNoServiceEvents =>
      'Событий обслуживания нет. Нажмите +, чтобы добавить неисправность или ремонт.';

  @override
  String get fieldOrderNoLabel => '№ заказа';

  @override
  String get fieldAsnLabel => 'ASN инвертора';

  @override
  String get fieldModelLabel => 'Модель';

  @override
  String get fieldClientLabel => 'Клиент';

  @override
  String get fieldInstallLocationLabel => 'Место установки';

  @override
  String get addEventTitle => 'Добавить событие обслуживания';

  @override
  String get eventTitleField => 'Название *';

  @override
  String get eventDescriptionField => 'Описание';

  @override
  String get eventTechnicianField => 'Техник';

  @override
  String get eventDateField => 'Дата';

  @override
  String get eventAddButton => 'Добавить событие';

  @override
  String get eventRequired => 'Обязательно';

  @override
  String get serviceFault => 'Неисправность';

  @override
  String get serviceRepair => 'Ремонт';

  @override
  String get serviceInspection => 'Осмотр';

  @override
  String get serviceReplacement => 'Замена';

  @override
  String get warehouseTitle => 'Склад';

  @override
  String get warehouseTotalInStock => 'На складе';

  @override
  String get warehouseAtCustomers => 'У клиентов';

  @override
  String get warehouseAtService => 'На сервисе';

  @override
  String get warehouseByLocation => 'По местоположению';

  @override
  String get warehouseByModel => 'По модели';

  @override
  String get warehouseEmpty => 'Данных по складу пока нет.';

  @override
  String get accountTitle => 'Аккаунт';

  @override
  String get accountAppearance => 'Оформление';

  @override
  String get accountTheme => 'Тема';

  @override
  String get appearanceLabel => 'Стиль';

  @override
  String get appearancePower => 'Энергия';

  @override
  String get appearanceNature => 'Природа';

  @override
  String get appearanceTech => 'Техно';

  @override
  String get accountDataExport => 'Экспорт данных';

  @override
  String get exportDescription =>
      'Экспортировать инверторы, видимые сейчас на дашборде.';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get accountLanguage => 'Язык';

  @override
  String get languageUzbek => 'O‘zbekcha';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get accountSecurity => 'Безопасность';

  @override
  String get securityAppLock => 'Блокировка приложения';

  @override
  String get securityAppLockSubtitle =>
      'Требовать PIN или биометрию при открытии';

  @override
  String get securityChangePin => 'Изменить PIN';

  @override
  String get securitySetPin => 'Задать PIN';

  @override
  String get securityBiometric => 'Использовать биометрию';

  @override
  String get securityBiometricSubtitle => 'Разблокировка по отпечатку или лицу';

  @override
  String get accountAbout => 'О приложении';

  @override
  String get accountVersion => 'Версия';

  @override
  String get lockTitle => 'Введите PIN';

  @override
  String get lockSubtitle => 'Введите PIN для разблокировки';

  @override
  String get lockUseBiometric => 'Использовать биометрию';

  @override
  String get lockWrongPin => 'Неверный PIN, попробуйте снова.';

  @override
  String get lockForgotHint => 'Обратитесь к администратору, если забыли PIN.';

  @override
  String get pinSetupTitle => 'Установите PIN';

  @override
  String get pinSetupSubtitle => 'Создайте 4-значный PIN для защиты приложения';

  @override
  String get pinConfirmTitle => 'Подтвердите PIN';

  @override
  String get pinConfirmSubtitle => 'Введите PIN ещё раз для подтверждения';

  @override
  String get pinMismatch => 'PIN-коды не совпадают. Попробуйте снова.';

  @override
  String get pinSavedSuccess => 'PIN успешно установлен.';

  @override
  String get ok => 'ОК';

  @override
  String get save => 'Сохранить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';
}
