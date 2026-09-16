# Technical Explanation – PhysioGhar Therapist App

## Why I chose Riverpod

I went with Riverpod mainly because it gives compile-time safety and proper dependency injection without forcing you to pass BuildContext everywhere.  

That separation makes the business logic cleaner and much easier to test — you can just override providers instead of fighting with the widget tree. It also only rebuilds the parts of the UI that actually need to update, which keeps things efficient.

Other options I considered:
- Bloc : too much boilerplate for the size of this project
- GetX : convenient but less type-safe and harder to test cleanly
- setState : fine for tiny apps, but not good once state needs to be shared across multiple screens
- Provider : works, but Riverpod fixes most of the pain points I usually run into with it

## How mock data is handled

All the sample data is kept in one place: `lib/data/mock_data.dart`.

A few intentional choices:

- Sessions, patients and schedule slots are linked properly (referential integrity)
- Dates are generated relative to `DateTime.now()` so the app always looks current
- The PatientNotifier listens to session changes and keeps itself in sync (simulating what a real database relationship or webhook would do)

I thought about using faker or loading JSON files, but a plain Dart class was clearer, had zero extra dependencies, and was easy to tweak while building the features.

## Important architectural decisions

**Feature-based structure**  
Instead of the usual models / views / controllers split, everything related to a feature lives together:

```
features/
  └── sessions/
      ├── domain/
      ├── providers/
      ├── presentation/
      └── widgets/
```

This keeps high cohesion and makes it easier to work on one feature without touching unrelated code.

**Go Router**  
Used for declarative, type-safe navigation. The ShellRoute keeps the bottom navigation bar visible across the main screens.

**Custom theme**  
I didn’t rely on pure Material defaults. The color palette is warmer and more suitable for a healthcare app, and the typography uses Newsreader + Inter + IBM Plex Mono.

**Cross-provider communication**  
When a session request is accepted, the session notifier calls into the schedule notifier to book the slot. Ownership stays clear while still allowing the two pieces to coordinate.

## Features I would improve with more time

- Real backend + authentication instead of mock data
- Offline support (Hive or SQLite)
- Proper unit and integration tests
- Push notifications for upcoming sessions
- Better accessibility (screen readers, focus management, etc.)
- Pagination / lazy loading on long lists
- Timezone handling and more flexible slot durations
- Skeleton loaders, pull-to-refresh, swipe actions
- Crash reporting and a basic CI pipeline

The current structure is clean enough that adding these later shouldn’t require a major rewrite.
