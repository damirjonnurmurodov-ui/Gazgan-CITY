# Token Saving Rules for AI Agents

## Maqsad

Codex va Claude Code kamroq token sarflab, adashmasdan ishlashi uchun qoidalar.

## Qoidalar

1. Har safar barcha hujjatlarni o‘qima.
2. Taskga tegishli 3–5 ta faylni o‘qi.
3. Katta fayllarni qayta yozma.
4. Bir taskda bitta ekran yoki bitta komponent.
5. Kodni to‘liq nusxalab qayta yaratma, faqat kerakli diff qil.
6. Uzun izoh yozma, qisqa hisobot qil.
7. Bir xil ma’lumotni bir necha faylda takrorlama.
8. Dastlab reja yoz, keyin implement qil.
9. Yangi dependency qo‘shishdan saqlan.
10. Backend, auth, payment haqida kod yozma.

## Minimal context map

- General task: `AGENTS.md`, `RESTRICTIONS.md`, `TASKS.md`
- UI task: `DESIGN_SYSTEM.md`, `UI_REFERENCE_GUIDE.md`, tegishli `screens/*.md`
- Architecture task: `FLUTTER_ARCHITECTURE.md`, `CODE_STYLE.md`
- QA task: `QA_CHECKLIST.md`, `RESTRICTIONS.md`

## Hisobot qisqa bo‘lsin

Format:

```text
Qilindi:
- ...

O‘zgargan fayllar:
- ...

Tekshiruv:
- flutter analyze: ...

Keyingi qadam:
- ...
```
