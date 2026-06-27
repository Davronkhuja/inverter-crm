import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';
import '../../state/inverter_provider.dart';

/// Форма добавления и редактирования инвертора (ТЗ §7).
/// При [existing] == null создаётся новая запись, иначе редактируется.
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

  late final TextEditingController _orderNo;
  late final TextEditingController _model;
  late final TextEditingController _asn;
  late final TextEditingController _client;
  late final TextEditingController _country;
  late final TextEditingController _city;
  late final TextEditingController _site;
  late final TextEditingController _faultDesc;
  late final TextEditingController _solution;
  late final TextEditingController _newAsn;
  late final TextEditingController _notes;

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
    _orderNo = TextEditingController(text: e?.orderNo ?? '');
    _model = TextEditingController(text: e?.model ?? '');
    _asn = TextEditingController(text: e?.asn ?? '');
    _client = TextEditingController(text: e?.clientName ?? '');
    _country = TextEditingController(text: e?.country ?? '');
    _city = TextEditingController(text: e?.city ?? '');
    _site = TextEditingController(text: e?.site ?? '');
    _faultDesc = TextEditingController(text: e?.faultDescription ?? '');
    _solution = TextEditingController(text: e?.solution ?? '');
    _newAsn = TextEditingController(text: e?.newAsn ?? '');
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
      _orderNo,
      _model,
      _asn,
      _client,
      _country,
      _city,
      _site,
      _faultDesc,
      _solution,
      _newAsn,
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
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
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
      _snack('Could not add photo: $e');
    }
  }

  Future<void> _addDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;
      final saved = <String>[];
      for (final f in result.files) {
        if (f.path != null) saved.add(await _persist(f.path!, 'documents'));
      }
      setState(() => _documents = [..._documents, ...saved]);
    } catch (e) {
      _snack('Could not add document: $e');
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<InverterProvider>();
    final asn = _asn.text.trim();

    // ASN должен быть уникальным — это ключ связывания замен.
    final duplicate = await provider.asnExists(
      asn,
      exceptId: widget.existing?.id,
    );
    if (duplicate) {
      _snack('ASN "$asn" already exists. It must be unique.');
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    final base = widget.existing;
    final inverter = Inverter(
      id: base?.id ?? _uuid.v4(),
      orderNo: _orderNo.text.trim(),
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
      _snack('Save failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit inverter' : 'New inverter'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _sectionTitle(theme, 'Identification'),
            _field(
              controller: _orderNo,
              label: 'Order No (serial)',
              icon: Icons.tag_rounded,
            ),
            _field(
              controller: _model,
              label: 'Inverter model *',
              icon: Icons.memory_rounded,
              validator: _required,
            ),
            _field(
              controller: _asn,
              label: 'Inverter ASN (serial number) *',
              icon: Icons.qr_code_2_rounded,
              validator: _required,
            ),
            _field(
              controller: _client,
              label: 'Client name *',
              icon: Icons.person_outline,
              validator: _required,
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, 'Dates'),
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    theme,
                    label: 'Installation date',
                    value: _installationDate,
                    onTap: () => _pickDate(installation: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateField(
                    theme,
                    label: 'Sale date',
                    value: _saleDate,
                    onTap: () => _pickDate(installation: false),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            _sectionTitle(theme, 'Installation location'),
            _field(
              controller: _country,
              label: 'Country',
              icon: Icons.public_rounded,
            ),
            _field(
              controller: _city,
              label: 'City',
              icon: Icons.location_city_rounded,
            ),
            _field(
              controller: _site,
              label: 'Site / object',
              icon: Icons.place_outlined,
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, 'Fault & solution'),
            DropdownButtonFormField<FaultType>(
              initialValue: _faultType,
              decoration: const InputDecoration(
                labelText: 'Fault type',
                prefixIcon: Icon(Icons.warning_amber_rounded),
              ),
              items: FaultType.values
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _faultType = v ?? FaultType.none),
            ),
            const SizedBox(height: 12),
            _field(
              controller: _faultDesc,
              label: 'Fault description',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            _field(
              controller: _solution,
              label: 'Solution',
              icon: Icons.build_outlined,
              maxLines: 3,
            ),

            const SizedBox(height: 8),
            _sectionTitle(theme, 'Replacement'),
            _replacementSection(theme),

            const SizedBox(height: 16),
            _sectionTitle(theme, 'Attachments & notes'),
            _attachmentRow(
              theme,
              icon: Icons.photo_library_outlined,
              label: 'Photos',
              count: _photos.length,
              onAdd: _addPhoto,
              onClear: _photos.isEmpty
                  ? null
                  : () => setState(() => _photos = []),
            ),
            const SizedBox(height: 10),
            _attachmentRow(
              theme,
              icon: Icons.attach_file_rounded,
              label: 'Documents',
              count: _documents.length,
              onAdd: _addDocument,
              onClear: _documents.isEmpty
                  ? null
                  : () => setState(() => _documents = []),
            ),
            const SizedBox(height: 12),
            _field(
              controller: _notes,
              label: 'Notes',
              icon: Icons.notes_rounded,
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
                : const Icon(Icons.save_rounded),
            label: Text(widget.isEditing ? 'Save changes' : 'Create record'),
          ),
        ),
      ),
    );
  }

  Widget _replacementSection(ThemeData theme) {
    final scheme = theme.colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 12, 12),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Inverter replaced'),
              subtitle: Text(
                _replaced
                    ? 'Link the replacement unit by its ASN'
                    : 'Turn on if this unit was swapped',
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
                          label: 'New inverter ASN *',
                          icon: Icons.swap_horiz_rounded,
                          validator: (v) =>
                              _replaced && (v == null || v.trim().isEmpty)
                              ? 'Enter the new ASN'
                              : null,
                        ),
                        DropdownButtonFormField<OldInverterLocation>(
                          initialValue: _oldLocation,
                          decoration: const InputDecoration(
                            labelText: 'Old inverter current location',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          items: OldInverterLocation.values
                              .map(
                                (l) => DropdownMenuItem(
                                  value: l,
                                  child: Row(
                                    children: [
                                      Icon(l.icon, size: 18),
                                      const SizedBox(width: 10),
                                      Text(l.label),
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
    required VoidCallback onAdd,
    required VoidCallback? onClear,
  }) {
    final scheme = theme.colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(label),
        subtitle: Text(
          count == 0 ? 'None attached' : '$count attached',
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: onClear,
              ),
            FilledButton.tonalIcon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add'),
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

  Widget _dateField(
    ThemeData theme, {
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
          prefixIcon: const Icon(Icons.event_outlined),
        ),
        child: Text(
          value == null ? 'Select' : Formatters.date(value),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: value == null ? scheme.onSurfaceVariant : scheme.onSurface,
          ),
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required field' : null;
}
