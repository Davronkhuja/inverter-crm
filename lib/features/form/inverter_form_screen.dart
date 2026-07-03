import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_icons_context.dart';
import '../../core/utils/enum_localizations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_provider.dart';

/// Форма добавления и редактирования инвертора (ТЗ §7).
/// При [existing] == null создаётся новая запись, иначе редактируется.
/// Order No присваивается автоматически и не редактируется вручную —
/// это гарантирует отсутствие дублей и человеческих ошибок при вводе.
class InverterFormScreen extends StatefulWidget {
  final Inverter? existing;
  const InverterFormScreen({super.key, this.existing});

  bool get isEditing => existing != null;

  @override
  State<InverterFormScreen> createState() => _InverterFormScreenState();
}

class _InverterFormScreenState extends State<InverterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late final TextEditingController _model;
  late final TextEditingController _asn;
  late final TextEditingController _client;
  late final TextEditingController _country;
  late final TextEditingController _city;
  late final TextEditingController _site;
  late final TextEditingController _faultDesc;
  late final TextEditingController _solution;
  late final TextEditingController _approvedBy;
  late final TextEditingController _newAsn;
  late final TextEditingController _dataloggerSn;
  late final TextEditingController _notes;

  /// Зафиксирован один раз при открытии формы для НОВОЙ записи, чтобы
  /// не пересчитываться при каждом setState (иначе номер мог бы "плыть"
  /// при добавлении/удалении других записей в это же время).
  late String _orderNo;

  DateTime? _installationDate;
  DateTime? _saleDate;
  FaultType _faultType = FaultType.none;
  bool _replaced = false;
  OldInverterLocation _oldLocation = OldInverterLocation.warehouse;
  List<String> _photos = [];
  List<String> _documents = [];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _orderNo = e?.orderNo ?? context.read<InverterProvider>().nextOrderNo;
    _model = TextEditingController(text: e?.model ?? '');
    _asn = TextEditingController(text: e?.asn ?? '');
    _client = TextEditingController(text: e?.clientName ?? '');
    _country = TextEditingController(text: e?.country ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _site = TextEditingController(text: e?.site ?? '');
    _faultDesc = TextEditingController(text: e?.faultDescription ?? '');
    _solution = TextEditingController(text: e?.solution ?? '');
    _approvedBy = TextEditingController(text: e?.approvedBy ?? '');
    _newAsn = TextEditingController(text: e?.newAsn ?? '');
    _dataloggerSn = TextEditingController(text: e?.dataloggerSn ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _installationDate = e?.installationDate;
    _saleDate = e?.saleDate;
    _faultType = e?.faultType ?? FaultType.none;
    _replaced = e?.replaced ?? false;
    _oldLocation = e?.oldInverterLocation ?? OldInverterLocation.warehouse;
    _photos = List.of(e?.photos ?? const []);
    _documents = List.of(e?.documents ?? const []);
  }

  @override
  void dispose() {
    for (final c in [
      _model,
      _asn,
      _client,
      _country,
      _city,
      _site,
      _faultDesc,
      _solution,
      _approvedBy,
      _newAsn,
      _dataloggerSn,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate({required bool installation}) async {
    final now = DateTime.now();
    final initial = (installation ? _installationDate : _saleDate) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2010),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      if (installation) {
        _installationDate = picked;
      } else {
        _saleDate = picked;
      }
    });
  }

  /// Копирует выбранный файл в постоянную папку приложения, чтобы путь
  /// не указывал на временный кеш, который система может удалить.
  Future<String> _persist(String sourcePath, String subdir) async {
    final dir = await getApplicationDocumentsDirectory();
    final target = Directory(p.join(dir.path, subdir));
    if (!target.existsSync()) target.createSync(recursive: true);
    final name = '${_uuid.v4()}${p.extension(sourcePath)}';
    final dest = p.join(target.path, name);
    await File(sourcePath).copy(dest);
    return dest;
  }

  Future<void> _addPhoto() async {
    final l10n = AppLocalizations.of(context)!;
    final icons = context.icons;
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(icons.photo),
              title: Text(l10n.photoTakePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(icons.photo),
              title: Text(l10n.photoChooseGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final picked = await picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;
      final saved = await _persist(picked.path, 'photos');
      setState(() => _photos = [..._photos, saved]);
    } catch (e) {
      _snack(l10n.photoAddFailed(e.toString()));
    }
  }

  Future<void> _addDocument() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      final saved = <String>[];
      for (final f in result.files) {
        if (f.path != null) saved.add(await _persist(f.path!, 'documents'));
      }
      setState(() => _documents = [..._documents, ...saved]);
    } catch (e) {
      _snack(l10n.documentAddFailed(e.toString()));
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<InverterProvider>();
    final asn = _asn.text.trim();

    // ASN должен быть уникальным — это ключ связывания замен.
    final duplicate = await provider.asnExists(
      asn,
      exceptId: widget.existing?.id,
    );
    if (duplicate) {
      _snack(l10n.asnDuplicate(asn));
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    final base = widget.existing;
    final inverter = Inverter(
      id: base?.id ?? _uuid.v4(),
      orderNo: _orderNo,
      model: _model.text.trim(),
      asn: asn,
      clientName: _client.text.trim(),
      installationDate: _installationDate,
      saleDate: _saleDate,
      country: _country.text.trim(),
      city: _city.text.trim(),
      site: _site.text.trim(),
      faultDescription: _faultDesc.text.trim(),
      faultType: _faultType,
      solution: _solution.text.trim(),
      approvedBy: _approvedBy.text.trim(),
      dataloggerSn: _dataloggerSn.text.trim(),
      replaced: _replaced,
      newAsn: _replaced ? _newAsn.text.trim() : null,
      oldInverterLocation: _oldLocation,
      notes: _notes.text.trim(),
      photos: _photos,
      documents: _documents,
      createdAt: base?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      if (widget.isEditing) {
        await provider.update(inverter);
      } else {
        await provider.add(inverter);
      }
      if (!mounted) return;
      Navigator.of(context).pop(inverter);
    } catch (e) {
      setState(() => _saving = false);
      _snack(l10n.saveFailed(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final icons = context.icons;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.formEditTitle : l10n.formNewTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _sectionTitle(theme, l10n.sectionIdentification),
            _readonlyField(
              theme: theme,
              label: l10n.fieldOrderNoAuto,
              value: _orderNo,
              icon: icons.orderNo,
            ),
            const SizedBox(height: 12),
            _field(
              controller: _model,
              label: l10n.fieldModel,
              icon: icons.model,
              validator: (v) => _required(v, l10n),
            ),
            _field(
              controller: _asn,
              label: l10n.fieldAsn,
              icon: icons.asn,
              validator: (v) => _required(v, l10n),
            ),
            _field(
              controller: _dataloggerSn,
              label: l10n.fieldDataloggerSn,
              icon: icons.orderNo,
            ),
            _field(
              controller: _client,
              label: l10n.fieldClientName,
              icon: icons.client,
              validator: (v) => _required(v, l10n),
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, l10n.sectionDates),
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    theme,
                    icons.calendar,
                    label: l10n.fieldInstallationDate,
                    value: _installationDate,
                    onTap: () => _pickDate(installation: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateField(
                    theme,
                    icons.calendar,
                    label: l10n.fieldSaleDate,
                    value: _saleDate,
                    onTap: () => _pickDate(installation: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _sectionTitle(theme, l10n.sectionLocation),
            _field(
              controller: _country,
              label: l10n.fieldCountry,
              icon: icons.country,
            ),
            _field(
              controller: _city,
              label: l10n.fieldCity,
              icon: icons.city,
            ),
            _field(
              controller: _site,
              label: l10n.fieldSite,
              icon: icons.site,
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, l10n.sectionFault),
            DropdownButtonFormField<FaultType>(
              initialValue: _faultType,
              decoration: InputDecoration(
                labelText: l10n.fieldFaultType,
                prefixIcon: Icon(icons.fault),
              ),
              items: FaultType.values
                  .map(
                    (f) => DropdownMenuItem(value: f, child: Text(f.l10n(l10n))),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => _faultType = v ?? FaultType.none),
            ),
            const SizedBox(height: 12),
            _field(
              controller: _faultDesc,
              label: l10n.fieldFaultDescription,
              icon: icons.description,
              maxLines: 3,
            ),
            _field(
              controller: _solution,
              label: l10n.fieldSolution,
              icon: icons.solution,
              maxLines: 3,
            ),
            _field(
              controller: _approvedBy,
              label: l10n.fieldApprovedBy,
              icon: icons.technician,
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, l10n.sectionReplacement),
            _replacementSection(theme, icons, l10n),

            const SizedBox(height: 16),
            _sectionTitle(theme, l10n.sectionAttachments),
            _attachmentRow(
              theme,
              icon: icons.photo,
              label: l10n.attachmentPhotos,
              count: _photos.length,
              l10n: l10n,
              icons: icons,
              onAdd: _addPhoto,
              onClear: _photos.isEmpty
                  ? null
                  : () => setState(() => _photos = []),
            ),
            const SizedBox(height: 10),
            _attachmentRow(
              theme,
              icon: icons.document,
              label: l10n.attachmentDocuments,
              count: _documents.length,
              l10n: l10n,
              icons: icons,
              onAdd: _addDocument,
              onClear: _documents.isEmpty
                  ? null
                  : () => setState(() => _documents = []),
            ),
            const SizedBox(height: 12),
            _field(
              controller: _notes,
              label: l10n.fieldNotes,
              icon: icons.notes,
              maxLines: 4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(icons.save),
            label: Text(
              widget.isEditing ? l10n.saveChanges : l10n.createRecord,
            ),
          ),
        ),
      ),
    );
  }

  Widget _replacementSection(
    ThemeData theme,
    AppIconSet icons,
    AppLocalizations l10n,
  ) {
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 12, 12),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.replacedSwitchTitle),
              subtitle: Text(
                _replaced
                    ? l10n.replacedSwitchSubtitleOn
                    : l10n.replacedSwitchSubtitleOff,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              value: _replaced,
              onChanged: (v) => setState(() => _replaced = v),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: _replaced
                  ? Column(
                      children: [
                        const SizedBox(height: 6),
                        _field(
                          controller: _newAsn,
                          label: l10n.fieldNewAsn,
                          icon: icons.swap,
                          validator: (v) =>
                              _replaced && (v == null || v.trim().isEmpty)
                              ? l10n.fieldNewAsnValidator
                              : null,
                        ),
                        DropdownButtonFormField<OldInverterLocation>(
                          initialValue: _oldLocation,
                          decoration: InputDecoration(
                            labelText: l10n.fieldOldLocation,
                            prefixIcon: Icon(icons.inventory),
                          ),
                          items: OldInverterLocation.values
                              .map(
                                (loc) => DropdownMenuItem(
                                  value: loc,
                                  child: Row(
                                    children: [
                                      Icon(loc.icon, size: 18),
                                      const SizedBox(width: 10),
                                      Text(loc.l10n(l10n)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(
                            () => _oldLocation =
                                v ?? OldInverterLocation.warehouse,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentRow(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required int count,
    required AppLocalizations l10n,
    required AppIconSet icons,
    required VoidCallback onAdd,
    required VoidCallback? onClear,
  }) {
    final scheme = theme.colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(label),
        subtitle: Text(
          count == 0
              ? l10n.attachmentNoneAttached
              : l10n.attachmentCountAttached(count),
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              IconButton(
                icon: Icon(icons.delete),
                onPressed: onClear,
              ),
            FilledButton.tonalIcon(
              onPressed: onAdd,
              icon: Icon(icons.add, size: 18),
              label: Text(l10n.attachmentAdd),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 10),
    child: Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
        letterSpacing: 0.2,
      ),
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  /// Поле только для чтения — используется для авто-сгенерированного
  /// номера заказа, чтобы визуально показать, что оно неизменяемо.
  Widget _readonlyField({
    required ThemeData theme,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final scheme = theme.colorScheme;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            context.icons.lock,
            size: 16,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _dateField(
    ThemeData theme,
    IconData icon, {
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        child: Text(
          value == null
              ? AppLocalizations.of(context)!.dateSelect
              : Formatters.date(value),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: value == null ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
      ),
    );
  }

  String? _required(String? v, AppLocalizations l10n) =>
      (v == null || v.trim().isEmpty) ? l10n.requiredField : null;
}
