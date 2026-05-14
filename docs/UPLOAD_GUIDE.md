# Upload Guide — Gazgan City

## Qayerga qo‘yiladi?

Bu paketdagi fayllarni Gazgan City Flutter loyiha papkasining root qismiga qo‘ying.

Masalan:

```text
Gazgan city/
  AGENTS.md
  CLAUDE.md
  README.md
  RESTRICTIONS.md
  DESIGN_SYSTEM.md
  SCREEN_STRUCTURE.md
  FLUTTER_ARCHITECTURE.md
  CODE_STYLE.md
  TASKS.md
  prompts/
  screens/
  ui_images/
  lib/
  pubspec.yaml
```

## Codex uchun

Codex loyiha papkasini ochganda `AGENTS.md` ni asosiy instruction sifatida ishlatadi.

## Claude Code uchun

Claude Code `CLAUDE.md` va `.claude/settings.json` fayllarini ishlatadi.

## Ishni boshlash tartibi

1. `prompts/01_analyze_project.md` bilan boshlang.
2. Keyin `prompts/02_create_foundation.md`.
3. Keyin ekranlarni ketma-ket qiling:
   - Home
   - Map
   - Listings
   - News
   - Profile
4. Oxirida `prompts/08_polish_and_verify.md`.
