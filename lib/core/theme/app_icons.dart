import 'package:flutter/material.dart';

/// Семантический набор иконок приложения. Каждая тема оформления
/// ([AppAppearance]) предоставляет свой собственный набор — иконки
/// называются по смыслу использования, а не по конкретному Material
/// Icon, чтобы тема могла полностью заменить визуальный язык иконок.
class AppIconSet {
  // Навигация
  final IconData navDashboard;
  final IconData navDashboardSelected;
  final IconData navWarehouse;
  final IconData navWarehouseSelected;
  final IconData navAccount;
  final IconData navAccountSelected;

  // Бренд / заголовок
  final IconData brand;

  // Статистика дашборда
  final IconData statTotalUnits;
  final IconData statReplaced;
  final IconData statFaults;

  // Карточка инвертора
  final IconData unit;
  final IconData client;
  final IconData location;
  final IconData calendar;
  final IconData statusActive;
  final IconData statusReplaced;
  final IconData fault;

  // Поиск / фильтры
  final IconData search;
  final IconData filter;
  final IconData clear;

  // Действия
  final IconData add;
  final IconData edit;
  final IconData delete;
  final IconData save;
  final IconData export;
  final IconData exportExcel;
  final IconData exportPdf;
  final IconData share;
  final IconData openExternal;

  // Склад
  final IconData warehouseStock;
  final IconData atCustomer;
  final IconData atService;
  final IconData model;

  // Детали / форма
  final IconData orderNo;
  final IconData asn;
  final IconData country;
  final IconData city;
  final IconData site;
  final IconData solution;
  final IconData description;
  final IconData swap;
  final IconData history;
  final IconData photo;
  final IconData document;
  final IconData notes;
  final IconData technician;
  final IconData chevronRight;
  final IconData arrowOutward;
  final IconData check;
  final IconData inventory;

  // Аккаунт / настройки
  final IconData appearance;
  final IconData language;
  final IconData security;
  final IconData lock;
  final IconData biometric;
  final IconData pin;
  final IconData about;
  final IconData themeSystem;
  final IconData themeLight;
  final IconData themeDark;

  const AppIconSet({
    required this.navDashboard,
    required this.navDashboardSelected,
    required this.navWarehouse,
    required this.navWarehouseSelected,
    required this.navAccount,
    required this.navAccountSelected,
    required this.brand,
    required this.statTotalUnits,
    required this.statReplaced,
    required this.statFaults,
    required this.unit,
    required this.client,
    required this.location,
    required this.calendar,
    required this.statusActive,
    required this.statusReplaced,
    required this.fault,
    required this.search,
    required this.filter,
    required this.clear,
    required this.add,
    required this.edit,
    required this.delete,
    required this.save,
    required this.export,
    required this.exportExcel,
    required this.exportPdf,
    required this.share,
    required this.openExternal,
    required this.warehouseStock,
    required this.atCustomer,
    required this.atService,
    required this.model,
    required this.orderNo,
    required this.asn,
    required this.country,
    required this.city,
    required this.site,
    required this.solution,
    required this.description,
    required this.swap,
    required this.history,
    required this.photo,
    required this.document,
    required this.notes,
    required this.technician,
    required this.chevronRight,
    required this.arrowOutward,
    required this.check,
    required this.inventory,
    required this.appearance,
    required this.language,
    required this.security,
    required this.lock,
    required this.biometric,
    required this.pin,
    required this.about,
    required this.themeSystem,
    required this.themeLight,
    required this.themeDark,
  });

  /// "Power" — округлые, мягкие rounded-иконки. Электрическая тема.
  static const power = AppIconSet(
    navDashboard: Icons.bolt_outlined,
    navDashboardSelected: Icons.bolt_rounded,
    navWarehouse: Icons.battery_charging_full_outlined,
    navWarehouseSelected: Icons.battery_charging_full_rounded,
    navAccount: Icons.account_circle_outlined,
    navAccountSelected: Icons.account_circle_rounded,
    brand: Icons.bolt_rounded,
    statTotalUnits: Icons.flash_on_rounded,
    statReplaced: Icons.cached_rounded,
    statFaults: Icons.error_outline_rounded,
    unit: Icons.flash_on_rounded,
    client: Icons.person_rounded,
    location: Icons.location_on_rounded,
    calendar: Icons.event_rounded,
    statusActive: Icons.check_circle_rounded,
    statusReplaced: Icons.cached_rounded,
    fault: Icons.error_rounded,
    search: Icons.search_rounded,
    filter: Icons.tune_rounded,
    clear: Icons.close_rounded,
    add: Icons.add_rounded,
    edit: Icons.edit_rounded,
    delete: Icons.delete_rounded,
    save: Icons.bolt_rounded,
    export: Icons.ios_share_rounded,
    exportExcel: Icons.grid_on_rounded,
    exportPdf: Icons.description_rounded,
    share: Icons.ios_share_rounded,
    openExternal: Icons.north_east_rounded,
    warehouseStock: Icons.battery_charging_full_rounded,
    atCustomer: Icons.person_pin_circle_rounded,
    atService: Icons.bolt_rounded,
    model: Icons.flash_on_rounded,
    orderNo: Icons.confirmation_number_rounded,
    asn: Icons.qr_code_rounded,
    country: Icons.public_rounded,
    city: Icons.location_city_rounded,
    site: Icons.place_rounded,
    solution: Icons.handyman_rounded,
    description: Icons.notes_rounded,
    swap: Icons.swap_horiz_rounded,
    history: Icons.history_rounded,
    photo: Icons.photo_rounded,
    document: Icons.insert_drive_file_rounded,
    notes: Icons.sticky_note_2_rounded,
    technician: Icons.engineering_rounded,
    chevronRight: Icons.chevron_right_rounded,
    arrowOutward: Icons.north_east_rounded,
    check: Icons.check_rounded,
    inventory: Icons.inventory_2_rounded,
    appearance: Icons.palette_rounded,
    language: Icons.translate_rounded,
    security: Icons.shield_rounded,
    lock: Icons.lock_rounded,
    biometric: Icons.fingerprint_rounded,
    pin: Icons.pin_rounded,
    about: Icons.info_rounded,
    themeSystem: Icons.brightness_auto_rounded,
    themeLight: Icons.light_mode_rounded,
    themeDark: Icons.dark_mode_rounded,
  );

  /// "Nature" — лёгкие outlined-иконки. Солнечно-экологическая тема.
  static const nature = AppIconSet(
    navDashboard: Icons.eco_outlined,
    navDashboardSelected: Icons.eco,
    navWarehouse: Icons.warehouse_outlined,
    navWarehouseSelected: Icons.warehouse,
    navAccount: Icons.person_outline_rounded,
    navAccountSelected: Icons.person_rounded,
    brand: Icons.solar_power_outlined,
    statTotalUnits: Icons.solar_power_outlined,
    statReplaced: Icons.autorenew_outlined,
    statFaults: Icons.warning_amber_outlined,
    unit: Icons.solar_power_outlined,
    client: Icons.person_outline_rounded,
    location: Icons.place_outlined,
    calendar: Icons.event_outlined,
    statusActive: Icons.check_circle_outline_rounded,
    statusReplaced: Icons.autorenew_outlined,
    fault: Icons.warning_amber_outlined,
    search: Icons.search_outlined,
    filter: Icons.filter_alt_outlined,
    clear: Icons.close_outlined,
    add: Icons.add_outlined,
    edit: Icons.edit_outlined,
    delete: Icons.delete_outline_rounded,
    save: Icons.eco_outlined,
    export: Icons.upload_file_outlined,
    exportExcel: Icons.table_chart_outlined,
    exportPdf: Icons.picture_as_pdf_outlined,
    share: Icons.share_outlined,
    openExternal: Icons.open_in_new_outlined,
    warehouseStock: Icons.warehouse_outlined,
    atCustomer: Icons.home_outlined,
    atService: Icons.build_circle_outlined,
    model: Icons.memory_outlined,
    orderNo: Icons.tag_outlined,
    asn: Icons.qr_code_2_outlined,
    country: Icons.public_outlined,
    city: Icons.location_city_outlined,
    site: Icons.place_outlined,
    solution: Icons.build_outlined,
    description: Icons.description_outlined,
    swap: Icons.swap_horiz_outlined,
    history: Icons.history_outlined,
    photo: Icons.photo_library_outlined,
    document: Icons.folder_outlined,
    notes: Icons.notes_outlined,
    technician: Icons.engineering_outlined,
    chevronRight: Icons.chevron_right_outlined,
    arrowOutward: Icons.call_made_outlined,
    check: Icons.check_outlined,
    inventory: Icons.inventory_2_outlined,
    appearance: Icons.palette_outlined,
    language: Icons.language_outlined,
    security: Icons.shield_outlined,
    lock: Icons.lock_outline_rounded,
    biometric: Icons.fingerprint_outlined,
    pin: Icons.pin_outlined,
    about: Icons.info_outline_rounded,
    themeSystem: Icons.brightness_auto_outlined,
    themeLight: Icons.light_mode_outlined,
    themeDark: Icons.dark_mode_outlined,
  );

  /// "Tech" — острые sharp-иконки. Тёмная техно-тема.
  static const tech = AppIconSet(
    navDashboard: Icons.dashboard_sharp,
    navDashboardSelected: Icons.dashboard_sharp,
    navWarehouse: Icons.dns_sharp,
    navWarehouseSelected: Icons.dns_sharp,
    navAccount: Icons.terminal_sharp,
    navAccountSelected: Icons.terminal_sharp,
    brand: Icons.memory_sharp,
    statTotalUnits: Icons.developer_board_sharp,
    statReplaced: Icons.sync_alt_sharp,
    statFaults: Icons.report_sharp,
    unit: Icons.memory_sharp,
    client: Icons.badge_sharp,
    location: Icons.gps_fixed_sharp,
    calendar: Icons.calendar_today_sharp,
    statusActive: Icons.power_settings_new_sharp,
    statusReplaced: Icons.sync_alt_sharp,
    fault: Icons.report_sharp,
    search: Icons.search_sharp,
    filter: Icons.tune_sharp,
    clear: Icons.close_sharp,
    add: Icons.add_sharp,
    edit: Icons.edit_sharp,
    delete: Icons.delete_sharp,
    save: Icons.save_sharp,
    export: Icons.terminal_sharp,
    exportExcel: Icons.grid_on_sharp,
    exportPdf: Icons.article_sharp,
    share: Icons.ios_share_sharp,
    openExternal: Icons.launch_sharp,
    warehouseStock: Icons.dns_sharp,
    atCustomer: Icons.point_of_sale_sharp,
    atService: Icons.precision_manufacturing_sharp,
    model: Icons.developer_board_sharp,
    orderNo: Icons.tag_sharp,
    asn: Icons.qr_code_sharp,
    country: Icons.public_sharp,
    city: Icons.location_city_sharp,
    site: Icons.place_sharp,
    solution: Icons.build_sharp,
    description: Icons.article_sharp,
    swap: Icons.swap_horiz_sharp,
    history: Icons.history_sharp,
    photo: Icons.image_sharp,
    document: Icons.description_sharp,
    notes: Icons.notes_sharp,
    technician: Icons.engineering_sharp,
    chevronRight: Icons.chevron_right_sharp,
    arrowOutward: Icons.trending_flat_sharp,
    check: Icons.check_sharp,
    inventory: Icons.inventory_sharp,
    appearance: Icons.contrast_sharp,
    language: Icons.translate_sharp,
    security: Icons.security_sharp,
    lock: Icons.lock_sharp,
    biometric: Icons.fingerprint_sharp,
    pin: Icons.password_sharp,
    about: Icons.info_sharp,
    themeSystem: Icons.settings_brightness_sharp,
    themeLight: Icons.light_mode_sharp,
    themeDark: Icons.mode_night_sharp,
  );
}
