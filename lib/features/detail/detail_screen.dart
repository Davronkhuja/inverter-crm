import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../core/constants/enums.dart';
import '../../core/theme/app_icons.dart';
import '../../core/theme/app_icons_context.dart';
import '../../core/utils/enum_localizations.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/inverter.dart';
import '../../data/models/service_event.dart';
import '../../l10n/app_localizations.dart';
import '../../state/inverter_provider.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/status_badge.dart';
import '../form/inverter_form_screen.dart';
import 'widgets/replacement_chain.dart';

/// Детальная страница инвертора (ТЗ §6): полная информация, история
/// неисправностей и ремонтов, цепочка замен, фото, документы, заметки.
class DetailScreen extends StatefulWidget {
  final String inverterId;
  const DetailScreen({super.key, required this.inverterId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<ServiceEvent>> _eventsFuture;
  String _eventsAsn = '';

  @override
  void initState() {
    super.initState();
    _eventsFuture = Future.value(const []);
  }

  void _loadEvents(String asn) {
    _eventsAsn = asn;
    _eventsFuture = context.read<InverterProvider>().getEvents(asn);
  }

  Inverter? _byAsn(List<Inverter> all, String? asn) {
    if (asn == null || asn.trim().isEmpty) return null;
    for (final i in all) {
      if (i.asn == asn) return i;
    }
    return null;
  }

  /// Цепочка замен, посчитанная по кешу провайдера (без обращения к БД).
  List<Inverter> _chain(List<Inverter> all, Inverter inv) {
    final seen = <String>{};
    var root = inv;
    var guard = 0;
    while (guard++ < 50) {
      final prev = all.cast<Inverter?>().firstWhere(
        (i) => i!.newAsn == root.asn && i.replaced,
        orElse: () => null,
      );
      if (prev == null || seen.contains(prev.asn)) break;
      seen.add(prev.asn);
      root = prev;
    }
    seen.clear();
    final chain = <Inverter>[];
    Inverter? cur = root;
    guard = 0;
    while (cur != null && guard++ < 50) {
      if (seen.contains(cur.asn)) break;
      seen.add(cur.asn);
      chain.add(cur);
      cur = cur.replaced ? _byAsn(all, cur.newAsn) : null;
    }
    return chain;
  }

  void _openInverter(Inverter inv) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DetailScreen(inverterId: inv.id)));
  }

  Future<void> _edit(Inverter inv) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => InverterFormScreen(existing: inv)),
    );
    if (!mounted) return;
    setState(() => _loadEvents(inv.asn));
  }

  Future<void> _delete(Inverter inv) async {
    final l10n = AppLocalizations.of(context)!;
    final icons = context.icons;
    final provider = context.read<InverterProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(icons.delete),
        title: Text(l10n.detailDeleteConfirmTitle),
        content: Text(l10n.detailDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await provider.remove(inv);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _addEvent(String asn) async {
    final provider = context.read<InverterProvider>();
    final event = await showModalBottomSheet<ServiceEvent>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddEventSheet(inverterAsn: asn),
    );
    if (event == null) return;
    await provider.addEvent(event);
    if (!mounted) return;
    setState(() => _loadEvents(asn));
  }

  Future<void> _deleteEvent(ServiceEvent e) async {
    await context.read<InverterProvider>().removeEvent(e.id);
    if (!mounted) return;
    setState(() => _loadEvents(e.inverterAsn));
  }

  void _openPhoto(String path) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            InteractiveViewer(child: Center(child: Image.file(File(path)))),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(context.icons.clear, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocument(String path) async {
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final icons = context.icons;
    final provider = context.watch<InverterProvider>();
    final all = provider.all;

    Inverter? inv;
    for (final i in all) {
      if (i.id == widget.inverterId) {
        inv = i;
        break;
      }
    }

    if (inv == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.detailNotFound)),
      );
    }

    if (_eventsAsn != inv.asn) {
      _loadEvents(inv.asn);
    }

    final replacement = _byAsn(all, inv.replaced ? inv.newAsn : null);
    final predecessor = all.cast<Inverter?>().firstWhere(
      (i) => i!.newAsn == inv!.asn && i.replaced,
      orElse: () => null,
    );
    final chain = _chain(all, inv);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            actions: [
              IconButton(
                tooltip: l10n.detailEdit,
                icon: Icon(icons.edit),
                onPressed: () => _edit(inv!),
              ),
              IconButton(
                tooltip: l10n.detailDelete,
                icon: Icon(icons.delete),
                onPressed: () => _delete(inv!),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 18,
                bottom: 14,
                right: 18,
              ),
              title: Text(
                inv.model.isEmpty ? inv.asn : inv.model,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: _HeaderBackground(icon: icons.unit),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
            sliver: SliverList.list(
              children: [
                _statusRow(theme, scheme, icons, inv, l10n),
                const SizedBox(height: 14),

                if (replacement != null || predecessor != null) ...[
                  _linkBanner(theme, scheme, icons, inv, replacement, predecessor, l10n),
                  const SizedBox(height: 14),
                ],

                SectionCard(
                  title: l10n.detailGeneralInfo,
                  icon: icons.about,
                  child: Column(
                    children: [
                      InfoTile(
                        icon: icons.orderNo,
                        label: l10n.fieldOrderNoLabel,
                        value: inv.orderNo,
                      ),
                      InfoTile(
                        icon: icons.asn,
                        label: l10n.fieldAsnLabel,
                        value: inv.asn,
                      ),
                      InfoTile(
                        icon: icons.orderNo,
                        label: l10n.fieldDataloggerSn,
                        value: inv.dataloggerSn,
                      ),
                      InfoTile(
                        icon: icons.asn,
                        label: l10n.fieldInverterSn,
                        value: inv.inverterSn,
                      ),
                      InfoTile(
                        icon: icons.model,
                        label: l10n.fieldModelLabel,
                        value: inv.model,
                      ),
                      InfoTile(
                        icon: icons.client,
                        label: l10n.fieldClientLabel,
                        value: inv.clientName,
                      ),
                      InfoTile(
                        icon: icons.location,
                        label: l10n.fieldInstallLocationLabel,
                        value: inv.locationLabel,
                      ),
                      InfoTile(
                        icon: icons.calendar,
                        label: l10n.fieldInstallationDate,
                        value: Formatters.date(inv.installationDate),
                      ),
                      InfoTile(
                        icon: icons.calendar,
                        label: l10n.fieldSaleDate,
                        value: Formatters.date(inv.saleDate),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SectionCard(
                  title: l10n.detailFaultSection,
                  icon: icons.statFaults,
                  child: Column(
                    children: [
                      InfoTile(
                        icon: icons.fault,
                        label: l10n.fieldFaultType,
                        value: inv.faultType == FaultType.none
                            ? l10n.detailNoFault
                            : inv.faultType.l10n(l10n),
                      ),
                      InfoTile(
                        icon: icons.description,
                        label: l10n.fieldFaultDescription,
                        value: inv.faultDescription,
                      ),
                      InfoTile(
                        icon: icons.solution,
                        label: l10n.fieldSolution,
                        value: inv.solution,
                      ),
                      if (inv.approvedBy.trim().isNotEmpty)
                        InfoTile(
                          icon: icons.technician,
                          label: l10n.fieldApprovedBy,
                          value: inv.approvedBy,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SectionCard(
                  title: l10n.detailReplacementSection,
                  icon: icons.swap,
                  child: _replacementBody(theme, scheme, icons, inv, replacement, l10n),
                ),
                const SizedBox(height: 12),

                if (chain.length > 1) ...[
                  SectionCard(
                    title: l10n.detailReplacementHistory,
                    icon: icons.history,
                    child: ReplacementChain(
                      chain: chain,
                      currentAsn: inv.asn,
                      onTap: _openInverter,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                _serviceLog(theme, scheme, icons, inv, l10n),
                const SizedBox(height: 12),

                if (inv.photos.isNotEmpty) ...[
                  SectionCard(
                    title: l10n.detailPhotos,
                    icon: icons.photo,
                    child: _photoGrid(inv),
                  ),
                  const SizedBox(height: 12),
                ],

                if (inv.documents.isNotEmpty) ...[
                  SectionCard(
                    title: l10n.detailDocuments,
                    icon: icons.document,
                    child: _documentList(theme, scheme, icons, inv),
                  ),
                  const SizedBox(height: 12),
                ],

                if (inv.notes.trim().isNotEmpty)
                  SectionCard(
                    title: l10n.detailNotes,
                    icon: icons.notes,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(inv.notes, style: theme.textTheme.bodyLarge),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    Inverter inv,
    AppLocalizations l10n,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        inv.replaced
            ? StatusBadge(
                label: l10n.cardStatusReplaced,
                color: scheme.error,
                icon: icons.statusReplaced,
                subtle: false,
              )
            : StatusBadge(
                label: l10n.cardStatusActive,
                color: const Color(0xFF2E9E5B),
                icon: icons.statusActive,
                subtle: false,
              ),
        if (inv.faultType != FaultType.none)
          StatusBadge(
            label: inv.faultType.l10n(l10n),
            color: scheme.tertiary,
            icon: icons.fault,
          ),
        if (inv.replaced)
          StatusBadge(
            label: l10n.detailOldLocationLabel(inv.oldInverterLocation.l10n(l10n)),
            color: scheme.secondary,
            icon: inv.oldInverterLocation.icon,
          ),
      ],
    );
  }

  Widget _linkBanner(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    Inverter inv,
    Inverter? replacement,
    Inverter? predecessor,
    AppLocalizations l10n,
  ) {
    final children = <Widget>[];
    if (predecessor != null) {
      children.add(
        _LinkTile(
          icon: icons.arrowOutward,
          caption: l10n.detailReplacementFor,
          asn: predecessor.asn,
          model: predecessor.model,
          color: scheme.secondary,
          onTap: () => _openInverter(predecessor),
        ),
      );
    }
    if (replacement != null) {
      children.add(
        _LinkTile(
          icon: icons.swap,
          caption: l10n.detailReplacedBy,
          asn: replacement.asn,
          model: replacement.model,
          color: scheme.primary,
          onTap: () => _openInverter(replacement),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _replacementBody(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    Inverter inv,
    Inverter? replacement,
    AppLocalizations l10n,
  ) {
    if (!inv.replaced) {
      return Row(
        children: [
          Icon(
            icons.statusActive,
            size: 18,
            color: const Color(0xFF2E9E5B),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.detailActiveNotReplaced,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        InfoTile(
          icon: icons.inventory,
          label: l10n.detailOldLocationField,
          value: inv.oldInverterLocation.l10n(l10n),
        ),
        InfoTile(
          icon: icons.swap,
          label: l10n.detailNewAsnField,
          valueWidget: replacement == null
              ? Text(
                  l10n.detailNotInDatabase(inv.newAsn ?? '—'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : _AsnLink(
                  asn: replacement.asn,
                  icon: icons.openExternal,
                  onTap: () => _openInverter(replacement),
                ),
        ),
      ],
    );
  }

  Widget _serviceLog(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    Inverter inv,
    AppLocalizations l10n,
  ) {
    return SectionCard(
      title: l10n.detailFaultRepairHistory,
      icon: icons.history,
      trailing: IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(icons.add),
        tooltip: l10n.detailAddEvent,
        onPressed: () => _addEvent(inv.asn),
      ),
      child: FutureBuilder<List<ServiceEvent>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final events = snapshot.data ?? const [];
          if (events.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icons.history,
                    size: 18,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.detailNoServiceEvents,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              for (final e in events) _eventTile(theme, scheme, e, l10n),
            ],
          );
        },
      ),
    );
  }

  Widget _eventTile(
    ThemeData theme,
    ColorScheme scheme,
    ServiceEvent e,
    AppLocalizations l10n,
  ) {
    final color = e.type.color(scheme);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(e.type.icon, size: 16, color: color),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    StatusBadge(label: e.type.l10n(l10n), color: color),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${Formatters.date(e.date)}'
                  '${e.technician.isEmpty ? '' : '  •  ${e.technician}'}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (e.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(e.description, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              context.icons.clear,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
            onPressed: () => _deleteEvent(e),
          ),
        ],
      ),
    );
  }

  Widget _photoGrid(Inverter inv) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final path in inv.photos)
          GestureDetector(
            onTap: () => _openPhoto(path),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(context.icons.photo),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _documentList(
    ThemeData theme,
    ColorScheme scheme,
    AppIconSet icons,
    Inverter inv,
  ) {
    return Column(
      children: [
        for (final path in inv.documents)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icons.document, color: scheme.primary),
            title: Text(
              p.basename(path),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(icons.share, size: 18),
            onTap: () => _openDocument(path),
          ),
      ],
    );
  }
}

/// Кликабельный ASN — открывает связанный инвертор.
class _AsnLink extends StatelessWidget {
  final String asn;
  final IconData icon;
  final VoidCallback onTap;
  const _AsnLink({required this.asn, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                asn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: scheme.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 15, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String asn;
  final String model;
  final Color color;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.caption,
    required this.asn,
    required this.model,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caption,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      asn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      model.isEmpty ? '—' : model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(context.icons.chevronRight, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final IconData icon;
  const _HeaderBackground({required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary.withValues(alpha: 0.22), scheme.surface],
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, right: 18),
          child: Icon(
            icon,
            size: 92,
            color: scheme.primary.withValues(alpha: 0.12),
          ),
        ),
      ),
    );
  }
}

/// Лист добавления события в журнал обслуживания.
class _AddEventSheet extends StatefulWidget {
  final String inverterAsn;
  const _AddEventSheet({required this.inverterAsn});

  @override
  State<_AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends State<_AddEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _technician = TextEditingController();
  ServiceEventType _type = ServiceEventType.fault;
  DateTime _date = _today();

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _technician.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2010),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ServiceEvent(
        id: const Uuid().v4(),
        inverterAsn: widget.inverterAsn,
        type: _type,
        date: _date,
        title: _title.text.trim(),
        description: _description.text.trim(),
        technician: _technician.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final icons = context.icons;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addEventTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ServiceEventType.values.map((t) {
                  return ChoiceChip(
                    label: Text(t.l10n(l10n)),
                    avatar: Icon(t.icon, size: 16),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.eventTitleField,
                  prefixIcon: Icon(icons.description),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.eventRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.eventDescriptionField,
                  prefixIcon: Icon(icons.notes),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _technician,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.eventTechnicianField,
                  prefixIcon: Icon(icons.technician),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.eventDateField,
                    prefixIcon: Icon(icons.calendar),
                  ),
                  child: Text(Formatters.date(_date)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _submit,
                child: Text(l10n.eventAddButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
