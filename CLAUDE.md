# Gazgan City — Claude Code Memory

## Project

Gazgan City is an official city service Flutter app for G‘ozg‘on city residents.

## Current phase

UI prototype only.

Do not connect backend, Supabase, Firebase, auth, payment, or real Google Maps.

## Must not add

- Gazgan Invest
- Marble products
- Investment modules
- ROI calculator
- Marble trade/export/catalog

Gazgan City is only for official city services, news, local listings, map, taxi, services, jobs, and useful contacts.

## Visual reference

Use only the approved PNG UI prototypes in `ui_images/`.
Do not reference any external app.
Do not invent a new visual style.

## Main screens

- Splash
- Home
- Map
- Listings
- News
- Profile

## Design

Premium Official City App:

- white background
- dark navy text
- official blue accents
- light gray cards
- gold official badge
- rounded cards
- readable Uzbek text
- mobile-first 9:16 layout
- SafeArea everywhere

## Flutter structure

Use feature-based structure:

- `core/theme`
- `core/widgets`
- `data/models`
- `data/mock`
- `features/home`
- `features/map`
- `features/listings`
- `features/news`
- `features/profile`
- `features/splash`

## Work loop

1. Inspect existing files.
2. Plan minimal changes.
3. Modify only relevant files.
4. Run `flutter analyze`.
5. Report concise summary.

## Stop conditions

Stop and ask/report if:

- Flutter project is missing;
- `pubspec.yaml` is missing;
- design PNG files are missing;
- task requires backend or real API;
- task asks to add Gazgan Invest or marmar/invest functionality.
