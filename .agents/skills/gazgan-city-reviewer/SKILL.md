---
name: gazgan-city-reviewer
description: Use when reviewing or auditing the Gazgan City Flutter UI prototype for PNG fidelity, restrictions, SafeArea, overflow, bottom navigation, folder structure, code style, or daily/weekly project health.
---

# Gazgan City Reviewer

Review the Gazgan City Flutter UI prototype against the project rules and approved PNG references.

## Read First

Read only the documents needed for the review:

- Core rules: `AGENTS.md`, `CLAUDE.md`, `RESTRICTIONS.md`
- UI review: `DESIGN_SYSTEM.md`, `UI_REFERENCE_GUIDE.md`, `QA_CHECKLIST.md`
- Project state: `TASKS.md`, `PROJECT_MEMORY.md`, `TOKEN_SAVING_RULES.md`
- Review prompts when relevant: `prompts/08_polish_and_verify.md`, `prompts/09_daily_automation_prompt.md`, `prompts/10_weekly_automation_prompt.md`
- Approved visual references in `ui_images/`

## Review Checklist

- Compare implemented UI with the approved PNG prototypes.
- Check SafeArea usage on every screen.
- Check for overflow, clipped text, cramped layout, and element overlap.
- Check bottom navigation spacing so content is not covered.
- Check Uzbek Latin UI text and readable typography.
- Check feature-based folder structure and reusable widget usage.
- Check theme usage: `AppColors`, `AppTextStyles`, `AppTheme`.
- Check mock/static data only.
- Check that forbidden modules, copy, routes, mock data, and dependencies are absent.
- Run `flutter analyze` when a Flutter project exists and the task allows command verification.

## Do Not Do

- Do not modify files for review-only tasks.
- Do not create Flutter files unless explicitly asked to fix or build.
- Do not auto-fix issues during daily or weekly audit prompts.
- Do not recommend backend, real API, Supabase, Firebase, auth, payment, or real Google Maps for the UI prototype phase.
- Do not use unapproved visual references or external app comparisons.

## Report Format

Keep the report concise and technical:

```text
Qilindi:
- ...

O'zgargan fayllar:
- ...

Tekshiruv:
- ...

Qolgan muammolar:
- ...

Keyingi tavsiya:
- ...
```

For code review, lead with findings ordered by severity and include file paths and line numbers when available.
