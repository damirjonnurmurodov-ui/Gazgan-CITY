# Design System — Gazgan City

## Uslub nomi

Premium Official City App

## Umumiy ko‘rinish

- rasmiy;
- zamonaviy;
- toza;
- o‘qilishi oson;
- premium ko‘rinishga ega;
- mobil 9:16 formatga mos;
- xira emas, aniq va tiniq.

## Ranglar

| Nomi | Hex | Vazifasi |
|---|---|---|
| Primary Blue | `#1368E8` | tugmalar, aktiv holat, iconlar |
| Dark Navy | `#061B46` | sarlavha, asosiy matn |
| Light Blue | `#EAF3FF` | yengil fon, badge |
| Marble Gray | `#F4F7FB` | kartalar, sahifa fonlari |
| Border Gray | `#E3E8F0` | border va ajratgichlar |
| Gold Accent | `#D59B2D` | rasmiy badge |
| Green Success | `#17B26A` | tasdiq, faol holat |
| Red Danger | `#F04438` | ogohlantirish, chiqish |
| White | `#FFFFFF` | asosiy fon |
| Muted Text | `#667085` | ikkinchi darajali matn |

## Radius

- kichik elementlar: 12
- chiplar: 14
- kartalar: 18–24
- katta banner: 28–32
- bottom navigation: 28

## Spacing

- screen horizontal padding: 16
- card padding: 16
- section gap: 20
- item gap: 12
- bottom nav safe gap: minimum 88

## Typography

Google Fonts tavsiya:

- Inter
- Manrope

Matn o‘lchamlari:

- large title: 28–34
- screen title: 24–30
- section title: 18–22
- card title: 16–18
- body: 14–16
- caption: 12–13

## UI qoidalari

- Har bir ekran SafeArea ishlatsin.
- Text overflow `maxLines` va `TextOverflow.ellipsis` bilan nazorat qilinsin.
- ListView/SingleChildScrollView pastida bottom nav uchun padding bo‘lsin.
- Cardlar shadow bilan, lekin juda og‘ir emas.
- Rasmiy badge oltin accent bilan ko‘rsatiladi.
- Aktiv bottom nav item ko‘k rangda.
- Inaktiv itemlar muted gray.

## Dizayn manbasi

`ui_images/` papkasidagi PNG prototiplar yagona visual reference hisoblanadi.
