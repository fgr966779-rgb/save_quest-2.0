# NEONCRED — ПРОМПТИ ДЛЯ KIRO / ANTIGRAVITY CODEX
## Інструкція по використанню | Червень 2026

---

## ФАЙЛИ В ЦЬОМУ ПАКЕТІ

| Файл | Призначення | Фічі | schemaVersion |
|------|-------------|------|---------------|
| `PHASE_0_CONTEXT_MASTER.md` | Майстер-контекст архітектури | - | Довідник |
| `PHASE_1_CORE_GAMIFICATION.md` | Ядро геймифікації | 5 фіч | 20 → 21 |
| `PHASE_2_AI_FEATURES.md` | AI-функції | 10 фіч | 21 → 22 |
| `PHASE_3_PRICE_INTELLIGENCE.md` | Ціновий движок | 14 фіч | 22 → 23 |
| `PHASE_4_ADVANCED_ANALYTICS.md` | Аналітика і фінал | 18 фіч | 23 → 24 |
| `kiro-steering-neoncred.md` | Kiro Steering File | Постійний контекст | - |

**Всього: 47 фіч | 4 фази | schemaVersion 20 → 24**

---

## ЯК ВИКОРИСТОВУВАТИ В KIRO

### Крок 1: Налаштуй Steering (один раз)

Скопіюй `kiro-steering-neoncred.md` в свій проєкт:
```
your-project/.kiro/steering/neoncred-context.md
```
Kiro буде автоматично читати його при кожному запиті.

### Крок 2: Запусти Phase 0 спершу

В Kiro Chat або Spec Session:
```
#PHASE_0_CONTEXT_MASTER.md прочитай цей файл — це архітектура проєкту
```

### Крок 3: Запускай фази по порядку

**Для кожної фази** — новий Kiro Feature Spec (Design-First):

```
Kiro: New Feature Spec → Design-First workflow

Paste в spec session:
"#PHASE_1_CORE_GAMIFICATION.md
Реалізуй всі фічі з цього документу в моєму Flutter проєкті.
Архітектура описана в #PHASE_0_CONTEXT_MASTER.md.
Виконуй фічі послідовно, не змінюй існуючий код без потреби."
```

Потім натисни **Run all Tasks** в Kiro після генерації tasks.md.

### Крок 4: Перевір Acceptance Criteria

Кожен фазовий файл має розділ `## ACCEPTANCE CRITERIA` — перевір всі пункти перед переходом до наступної фази.

---

## ЯК ВИКОРИСТОВУВАТИ В ANTIGRAVITY CODEX

```
1. Відкрий Antigravity Codex
2. Прикріпи PHASE_0_CONTEXT_MASTER.md як контекст
3. Прикріпи потрібну фазу (наприклад PHASE_1_CORE_GAMIFICATION.md)
4. Скажи: "Реалізуй всі фічі з Phase 1 згідно архітектури в Phase 0"
5. Використовуй однослівні команди для продовження: "далі", "continue", "наступна фіча"
```

---

## ПОРЯДОК ВИКОНАННЯ

```
Phase 0 → (ознайомлення з архітектурою) → без коду
Phase 1 → 5 фіч → перевір → ✅
Phase 2 → 10 фіч → перевір → ✅
Phase 3 → 14 фіч → перевір → ✅
Phase 4 → 18 фіч → перевір → ✅ PROJECT COMPLETE
```

---

## ВАЖЛИВІ НАГАДУВАННЯ

- Завжди виконуй `flutter pub run build_runner build` після змін в database.dart
- Перевіряй що schemaVersion тільки зростає
- При конфліктах маршрутів (роут вже існує) — розширюй існуючий екран, не створюй новий
- Всі суми в копійках (int): 500 грн = 50000 копійок

---

*NEONCRED Build Pack v1.0 | 47 features | 4 phases | Kiro + Antigravity Codex*
