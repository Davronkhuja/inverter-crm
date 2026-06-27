# Inverter CRM — Warranty & Service

Professional CRM mobile application (Flutter) for tracking inverter **installation,
faults, repairs, replacements and inventory history** for warranty & service teams.

Built with **Material 3**, light & dark themes, offline‑first local database, and
Excel / PDF export.

---

## Features

| Area | What it does |
|------|--------------|
| **Dashboard** | All inverter records as cards with live stats (total / replaced / open faults). |
| **Search** | By ASN, client name, model or location. |
| **Filters** | Replacement status, fault type, model, installation‑date range, sale‑date range. |
| **Replacement management** | Mark a unit replaced and link the **New ASN**. The New ASN is clickable and opens the new inverter's page. |
| **History tracking** | Full replacement chain `Old ASN → New ASN → Next ASN`, all records linked both ways. |
| **Old unit tracking** | "Old Inverter Current Location": Warehouse / Service Center / Customer Site / Returned to Factory / Scrapped / Other. |
| **Detail page** | Full info, fault & repair history (service log), replacement history, photos, notes, attached documents. |
| **CRUD** | Add, edit, delete (with confirmation). ASN is validated as unique — it is the linking key. |
| **Export** | Excel (`.xlsx`) and PDF, shared through the system share sheet. |
| **UI** | Material 3, custom teal "energy" palette, dark mode, responsive, 60 fps. |

---

## Project structure

```
lib/
├── main.dart                      # Entry point, providers, theme wiring
├── core/
│   ├── constants/enums.dart       # FaultType, OldInverterLocation, ServiceEventType
│   ├── theme/app_theme.dart       # Material 3 light/dark theme (tokens)
│   └── utils/formatters.dart      # Date formatting
├── data/
│   ├── models/
│   │   ├── inverter.dart          # Main entity + (de)serialization
│   │   └── service_event.dart     # Fault / repair / inspection log entry
│   ├── db/database_helper.dart    # sqflite schema + demo seed
│   └── repositories/
│       └── inverter_repository.dart  # CRUD + replacement linking / chain
├── state/
│   ├── inverter_provider.dart     # ChangeNotifier app state
│   └── inverter_filter.dart       # Search + filter logic
├── features/
│   ├── dashboard/                 # List, search, filters, stats
│   ├── detail/                    # Detail page, replacement chain, service log
│   ├── form/                      # Add / edit form
│   └── export/export_service.dart # Excel + PDF export
└── widgets/                       # Reusable UI (badges, info tiles, section cards)
```

---

## How replacement linking works

* Every inverter has a unique **`asn`** (serial number) and an optional **`newAsn`**.
* When a unit is replaced, `replaced = true` and `newAsn` points to the replacement's `asn`.
* The detail page resolves links **both directions** from the in‑memory cache:
  * **Replaced by** → the inverter whose `asn == newAsn`.
  * **Replacement for** → the inverter whose `newAsn == this.asn`.
* The full chain is reconstructed by walking back to the first ancestor and forward to
  the last successor (`InverterRepository.getReplacementChain`).
* Deleting a unit clears any `newAsn` links that point to it, so no broken links remain.

---

## Tech stack

* **Flutter** (Material 3) · **provider** (state) · **sqflite** (local DB)
* **excel** (.xlsx) · **pdf** + **printing** (PDF) · **share_plus** (sharing)
* **image_picker** / **file_picker** (attachments) · **google_fonts** (Manrope) · **intl**

## Run / build

```bash
flutter pub get
flutter run                 # debug on a connected device/emulator
flutter test                # unit tests (models, filters)
flutter build apk --release # release APK → build/app/outputs/flutter-apk/app-release.apk
```

Minimum Android: `flutter.minSdkVersion`. The bundled database is seeded with a few
demo records (including a replacement chain) on first launch.
