# Flutter Architecture — Gazgan City

## Maqsad

UI prototipni toza, kengaytiriladigan va feature-based strukturada yozish.

## Tavsiya qilingan papka strukturasi

```text
lib/
  main.dart
  app.dart

  core/
    theme/
      app_colors.dart
      app_text_styles.dart
      app_theme.dart
    constants/
      app_strings.dart
      app_assets.dart
      app_sizes.dart
    widgets/
      app_card.dart
      app_button.dart
      app_search_field.dart
      app_bottom_nav.dart
      section_header.dart
      category_chip.dart
      empty_state.dart

  data/
    models/
      listing_model.dart
      news_model.dart
      map_place_model.dart
      reception_model.dart
      service_model.dart
    mock/
      mock_home.dart
      mock_listings.dart
      mock_news.dart
      mock_map_places.dart
      mock_profile.dart

  features/
    splash/
      splash_screen.dart
    home/
      home_screen.dart
      widgets/
        home_header.dart
        weather_status_card.dart
        official_announcement_card.dart
        quick_action_grid.dart
        reception_card.dart
        compact_news_card.dart
        useful_section_card.dart
        local_service_card.dart
    map/
      map_screen.dart
      widgets/
        map_search_bar.dart
        map_category_chips.dart
        city_map_mock.dart
        map_place_card.dart
        quick_place_card.dart
    listings/
      listings_screen.dart
      listing_detail_screen.dart
      add_listing_screen.dart
      widgets/
        listing_card.dart
        listing_category_item.dart
        safety_banner.dart
        listing_filter_sheet.dart
    news/
      news_screen.dart
      news_detail_screen.dart
      widgets/
        featured_news_card.dart
        news_list_card.dart
        news_category_chip.dart
    profile/
      profile_screen.dart
      settings_screen.dart
      widgets/
        profile_header_card.dart
        profile_menu_item.dart
```

## Paketlar

Minimal paketlar:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts:
  lucide_icons:
  go_router:
```

Hozircha qo‘shilmasin:

- supabase_flutter
- firebase_core
- google_maps_flutter
- payment packages
- auth packages

## Navigation

Bottom navigation 5 asosiy ekran orasida ishlaydi:

- HomeScreen
- MapScreen
- ListingsScreen
- NewsScreen
- ProfileScreen

`go_router` ishlatilishi mumkin. Oddiy Navigator ham mumkin, lekin structure toza bo‘lsin.

## State management

UI prototip bosqichida murakkab state management kerak emas.

Ruxsat:

- StatefulWidget;
- ValueNotifier;
- oddiy mock data.

Hozircha kerak emas:

- Bloc;
- Riverpod;
- Provider;
- Redux.

## Model qoidasi

Har bir data turi uchun oddiy model:

- ListingModel
- NewsModel
- MapPlaceModel
- ReceptionModel
- ServiceModel

## Build validation

Har taskdan keyin:

```bash
flutter analyze
```

Agar testlar mavjud bo‘lsa:

```bash
flutter test
```
