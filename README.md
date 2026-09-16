# PhysioGhar Therapist App


## How to Run

### Prerequisites
- Flutter SDK **3.14.0** or higher
- Dart SDK **3.14.0** or higher
- Android Studio or Xcode
- A physical device or emulator

### Steps

1. Clone the repository and enter the folder:
```bash
git clone https://github.com/Avashmhzn/Physioghar_app.git


```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

For a release build:
```bash
flutter build apk --release
```

## Flutter / Dart Version

- **Flutter**: 3.14.0-53.0.dev
- **Dart**: ^3.14.0-53.0.dev

## Packages Used

| Package              | Version   | Purpose                          |
|----------------------|-----------|----------------------------------|
| flutter_riverpod     | ^3.4.3    | State management                 |
| go_router            | ^18.0.1   | Navigation                       |
| google_fonts         | ^8.2.1    | Custom fonts (Newsreader, Inter, IBM Plex Mono) |
| intl                 | ^0.20.3   | Date formatting & localization   |
| uuid                 | ^4.6.0    | Unique ID generation             |
| cupertino_icons      | ^1.0.8    | iOS-style icons                  |

Dev dependencies: `flutter_test`, `flutter_lints: ^6.0.0`

## State Management

The app uses **Riverpod** (`flutter_riverpod`).

Why Riverpod?
- Compile-time safety (no runtime `ProviderNotFoundException`)
- Easy to test by overriding providers
- No need to pass `BuildContext` just to read state
- Fine-grained rebuilds — only the widgets that need to update rebuild
- Scales better than plain `setState` or Provider for multi-screen state

Pattern used:
- `StateNotifierProvider` : mutable state (sessions, patients, schedule, complaints)
- `Provider` : derived / filtered data
- `StateProvider` : simple values (language, search query)

## Mock Data

All sample data lives in a single file: `lib/data/mock_data.dart`

It includes:
- Therapist profile
- Sessions in different states (request, upcoming, completed, cancelled)
- Patient records with notes and history
- Weekly availability slots (open / blocked / booked)

Dates are generated relative to `DateTime.now()` so the app always looks current. Sessions and patients stay in sync through a small listener. Everything is in-memory — restarting the app resets the data. No backend is required.

## Project Structure

```
lib/
├── core/
│   ├── constants/       # Theme, colors, typography
│   ├── localization/    # English / Nepali strings
│   ├── router/          # GoRouter setup
│   ├── utils/
│   └── widgets/         # Shared UI components
├── data/
│   └── mock_data.dart   # All mock data
└── features/
    ├── complaints/
    ├── home/
    ├── patients/
    ├── profile/
    ├── schedule/
    └── sessions/
```

Each feature folder contains:
- `domain/` : models
- `providers/` : Riverpod state
- `presentation/` : screens
- `widgets/` : feature-specific widgets

## Key Features

- **Home** – Quick overview of today’s sessions and metrics
- **Sessions** – Accept / decline requests, reschedule, mark complete, view history
- **Patients** – Browse records, view details, add/edit notes
- **Schedule** – Weekly calendar, block/unblock slots, add custom availability
- **Profile** – Edit therapist info + language toggle (English / Nepali)
- **Complaints** – Submit feedback or report issues

## Assumptions

- No real backend — data is mock and resets on restart
- Single therapist (no authentication)
- Simple booking flow (no advanced conflict checking)
- Avatars come from pravatar.cc
- Uses device local time (no timezone support)
- No push notifications or offline mode

## Design Notes

- Warm, cream-based color palette that feels more suitable for healthcare
- Typography: Newsreader (headings), Inter (body), IBM Plex Mono (mono)
- Google Fonts are preloaded at startup
- Custom page transitions (fade + slight slide)
- Edge-to-edge display with transparent system bars

## What Could Be Improved Later

- Real API + authentication
- Offline support (Hive / SQLite)
- Unit & widget tests
- Push notifications for upcoming sessions
- Better accessibility (screen readers, focus management)
- Pagination on long lists
- Timezone handling and more flexible slot durations
- Skeleton loaders, pull-to-refresh, swipe actions

---

Built with Flutter & Riverpod.  
