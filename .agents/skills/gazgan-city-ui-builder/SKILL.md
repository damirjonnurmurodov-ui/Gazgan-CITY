---
name: gazgan-city-ui-builder
description: Use when building Gazgan City Flutter UI prototype foundation, screens, reusable widgets, mock UI data, navigation shell, or visual polish from the approved local PNG prototypes.
---

# Gazgan City UI Builder

Build only the Gazgan City Flutter UI prototype for the current project phase.

## Read First

Read only the task-relevant documents to save context:

- General task: `AGENTS.md`, `CLAUDE.md`, `RESTRICTIONS.md`
- UI task: `DESIGN_SYSTEM.md`, `UI_REFERENCE_GUIDE.md`, relevant `screens/*.md`
- Architecture task: `FLUTTER_ARCHITECTURE.md`, `CODE_STYLE.md`
- Visual source: relevant approved PNG in `ui_images/`

Use only these approved visual references:

- `ui_images/00_full_ui_prototype_preview.png`
- `ui_images/01_home_screen.png`
- `ui_images/02_map_screen.png`
- `ui_images/03_listings_screen.png`
- `ui_images/04_news_screen.png`
- `ui_images/05_profile_screen.png`

## Workflow

1. Inspect existing files before editing.
2. Write a short implementation plan.
3. Touch only files needed for one screen, one module, or foundation task.
4. Keep feature-based Flutter structure and reusable widgets.
5. Use `AppColors`, `AppTextStyles`, and `AppTheme` instead of hardcoded styling.
6. Use mock/static data only.
7. Put every screen inside `SafeArea`.
8. Prevent overflow, text clipping, and bottom navigation overlap.
9. Run `flutter analyze` after changes when a Flutter project exists.
10. Report what changed, verification result, remaining issues, and next recommendation.

## UI Requirements

- Match the approved PNGs for color, spacing, cards, headers, icons, bottom navigation, and 9:16 mobile layout.
- Keep all UI text in Uzbek Latin.
- Preserve the Premium Official City App style: white background, dark navy text, official blue accent, light gray rounded cards, gold official badge, readable text.
- Split large widgets into smaller reusable widgets.

## Do Not Add

- Gazgan Invest
- marble product catalog, market, trade, export, or investment modules
- ROI calculator or investor features
- backend, real API, Supabase, Firebase, auth, payment, or real Google Maps
- unapproved visual references or external app comparisons
- broad refactors or unnecessary dependencies

## Stop And Report

Stop before coding if the task needs a forbidden feature, a required PNG is missing, or the Flutter project files needed for the task do not exist.
