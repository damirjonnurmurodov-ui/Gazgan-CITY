# AI Workflow — Gazgan City

Bu workflow Codex, Claude Code va boshqa AI agentlar uchun.

## Asosiy sikl

Har bir vazifa quyidagi tartibda bajarilsin:

1. **Read minimal context**
   - `AGENTS.md`
   - taskga tegishli screen hujjati
   - `RESTRICTIONS.md`
   - kerak bo‘lsa `DESIGN_SYSTEM.md`

2. **Inspect files**
   - mavjud strukturani ko‘r;
   - kerakli fayllarni top;
   - kod yozishga shoshilma.

3. **Plan**
   - 3–7 bandli qisqa reja yoz;
   - qaysi fayllarga tegilishini ayt.

4. **Implement**
   - faqat kerakli fayllarni o‘zgartir;
   - bitta taskda bitta ekran/modul.

5. **Verify**
   - `flutter analyze` ishlat;
   - UI overflow va bottom nav muammolarini tekshir.

6. **Report**
   - qisqa xulosa;
   - o‘zgargan fayllar;
   - tekshiruv natijasi;
   - keyingi qadam.

## Token tejash qoidasi

Agent har safar barcha hujjatlarni to‘liq o‘qimasin.

Taskga qarab minimal hujjatlar:

### HomeScreen task

- `AGENTS.md`
- `RESTRICTIONS.md`
- `DESIGN_SYSTEM.md`
- `screens/01_home_screen.md`
- `UI_REFERENCE_GUIDE.md`

### MapScreen task

- `AGENTS.md`
- `RESTRICTIONS.md`
- `screens/02_map_screen.md`
- `UI_REFERENCE_GUIDE.md`

### Listings task

- `AGENTS.md`
- `RESTRICTIONS.md`
- `screens/03_listings_screen.md`
- `UI_REFERENCE_GUIDE.md`

### News task

- `AGENTS.md`
- `RESTRICTIONS.md`
- `screens/04_news_screen.md`
- `UI_REFERENCE_GUIDE.md`

### Profile task

- `AGENTS.md`
- `RESTRICTIONS.md`
- `screens/05_profile_screen.md`
- `UI_REFERENCE_GUIDE.md`

## Stop rules

Agent to‘xtasin va hisobot bersin, agar:

- task backend talab qilsa;
- real API kerak bo‘lsa;
- Gazgan Invest yoki marmar/invest moduli so‘ralsa;
- project structure topilmasa;
- `pubspec.yaml` yo‘q bo‘lsa;
- `flutter analyze` hal qilib bo‘lmaydigan xato bersa.

## Retry qoidasi

Bir xatoni avtomatik tuzatishga maksimum 2 marta urinish mumkin.
2 martadan keyin to‘xtab, aniq xato va tavsiya yozilsin.
