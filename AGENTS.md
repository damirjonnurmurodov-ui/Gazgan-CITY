# Gazgan City — AI Agent Instructions

Bu fayl Codex va boshqa AI coding agentlar uchun asosiy qoida hisoblanadi.

## Loyiha identifikatsiyasi

Gazgan City — G‘ozg‘on shahri aholisi uchun rasmiy shahar xizmatlari mobil platformasi.

## Joriy vazifa

Birinchi bosqichda faqat **Flutter UI prototip** tayyorlanadi.

Asosiy ekranlar:

1. Splash Screen
2. Bosh sahifa
3. Xarita
4. E’lonlar
5. Yangiliklar
6. Profil

## Qat’iy taqiqlar

Quyidagilarni qo‘shma:

- Gazgan Invest;
- marmar mahsulotlari katalogi;
- investitsiya loyihalari;
- ROI kalkulyator;
- marmar savdo;
- marmar eksport;
- marmar market;
- payment;
- real backend;
- Supabase ulanishi;
- Firebase;
- real Google Maps;
- login/auth.

## Dizayn manbasi

Tashqi ilovalar, boshqa loyihalar yoki eski namunalarni tilga olma.

Dizayn uchun yagona manba:

- `ui_images/00_full_ui_prototype_preview.png`
- `ui_images/01_home_screen.png`
- `ui_images/02_map_screen.png`
- `ui_images/03_listings_screen.png`
- `ui_images/04_news_screen.png`
- `ui_images/05_profile_screen.png`

Flutter UI aynan shu PNG prototiplardagi rang, spacing, kartalar, bottom navigation, header, icon uslubi va 9:16 mobil joylashuvga mos qilinsin.

## Til

Barcha UI matnlari o‘zbek tilida, lotin yozuvida bo‘lsin.

## Dizayn uslubi

**Premium Official City App**

- oq fon;
- to‘q ko‘k matn;
- rasmiy ko‘k accent;
- och kulrang kartalar;
- oltin badge;
- yumaloq kartalar;
- katta va o‘qilishi oson matn;
- real mobil ilova ko‘rinishi.

## Texnik qoidalar

- Flutter ishlatilsin.
- Feature-based folder structure ishlatilsin.
- Reusable widgetlar yaratilgan bo‘lsin.
- AppColors, AppTextStyles, AppTheme alohida fayllarda bo‘lsin.
- Mock/static data ishlatilsin.
- Har bir ekran SafeArea ichida bo‘lsin.
- Bottom navigation kontentni yopib qo‘ymasin.
- UI overflow bo‘lmasin.
- Katta widgetlar mayda reusable widgetlarga ajratilsin.

## Ishlash tartibi

Har bir taskda:

1. Avval mavjud fayllarni tahlil qil.
2. Qisqa reja yoz.
3. Faqat kerakli fayllarga teg.
4. Katta refactor qilma.
5. Bitta taskda bitta ekran yoki bitta modul.
6. O‘zgarishdan keyin `flutter analyze` ishlat.
7. Natijani qisqa hisobot qil.

## Fayl o‘zgartirish qoidasi

- Keraksiz fayllarni o‘chirma.
- Ishlayotgan kodni butunlay qayta yozma.
- Yangi dependency qo‘shishdan oldin sababini yoz.
- Backend dependency qo‘shma.
- UI prototip bosqichida network yoki API kerak emas.

## Hisobot formati

Har task oxirida qisqa yoz:

- nima qilindi;
- qaysi fayllar o‘zgardi;
- qanday tekshirildi;
- qolgan muammolar;
- keyingi tavsiya.
