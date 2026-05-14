# Code Style — Gazgan City

## Umumiy qoidalar

- Kod sodda, toza va o‘qilishi oson bo‘lsin.
- Katta widgetlar mayda widgetlarga bo‘linsin.
- Har bir fayl bitta aniq vazifani bajarsin.
- Ranglar hardcode qilinmasin: `AppColors` ishlatilsin.
- Text style hardcode qilinmasin: `AppTextStyles` ishlatilsin.
- Takroriy UI element reusable widgetga chiqarilsin.

## Naming

Fayl nomlari snake_case:

- `home_screen.dart`
- `weather_status_card.dart`
- `app_bottom_nav.dart`

Class nomlari PascalCase:

- `HomeScreen`
- `WeatherStatusCard`
- `AppBottomNav`

## Widget qoidalari

- `const` ishlatilishi mumkin bo‘lgan joyda `const` qo‘yilsin.
- `Expanded/Flexible` ehtiyotkor ishlatilsin.
- Uzun matnlarga `maxLines` va `overflow` qo‘yilsin.
- List sahifalarda bottom padding bo‘lsin.

## UI xavfsizlik

- SafeArea har ekranda bo‘lsin.
- Bottom nav overlay qilmasin.
- Keyboard ochilganda inputlar yopilib qolmasin.
- 9:16 mobil formatda overflow bo‘lmasin.

## Comment qoidasi

- Keraksiz comment yozilmasin.
- Murakkab layout qarori bo‘lsa, qisqa comment yozilsin.

## Dependency qoidasi

Yangi dependency qo‘shishdan oldin:

1. nega kerakligini yoz;
2. lightweight alternativani o‘yla;
3. backend yoki real API paketlarini prototip bosqichida qo‘shma.
