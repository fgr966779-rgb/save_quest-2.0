# PiggyVault Retention Ideas Backlog

> Мета документа: зафіксувати всі 60 нових ідей для утримання користувача, щоб далі переносити їх у roadmap, дизайн, базу даних і реалізацію по фазах.
>
> Фокус: не просто більше екранів, а щоденні ритуали, повернення після провалу, емоційний зв'язок із цілями, контроль імпульсів і довгострокова мотивація.

---

## 1. Емоції, Саморефлексія, Поведінкові Тригери

### 1. Mood-to-Money Check-in
- **Суть:** перед депозитом або записом витрати користувач вибирає настрій.
- **Retention value:** користувач починає бачити зв'язок між емоціями та грошовими рішеннями.
- **MVP:** екран вибору настрою перед депозитом: спокій, стрес, нудьга, радість, втома.
- **Дані:** mood, actionType, amount, createdAt.

### 2. Фінансовий щоденник дня
- **Суть:** короткий щоденний запис: "що я сьогодні зробив добре з грошима".
- **Retention value:** створює м'який щоденний ритуал без тиску.
- **MVP:** одна текстова нотатка на день із історією записів.
- **Дані:** date, entryText, optionalMood.

### 3. Spending Trigger Map
- **Суть:** карта причин витрат: нудьга, стрес, компанія, знижка, голод.
- **Retention value:** користувач вчиться передбачати свої слабкі моменти.
- **MVP:** теги причин при записі витрати або "майже купив".
- **Дані:** triggerType, amount, category, createdAt.

### 4. Financial Personality Test
- **Суть:** визначає фінансовий тип: спринтер, стратег, імпульсивний, стабільний.
- **Retention value:** персоналізує досвід і робить користувача "героєм" власної системи.
- **MVP:** короткий тест із 8-10 питань.
- **Дані:** answers, personalityType, recalculatedAt.

### 5. Adaptive Coach Tone
- **Суть:** AI змінює стиль не вручну, а за поведінкою користувача.
- **Retention value:** поради відчуваються персональними, а не однаковими для всіх.
- **MVP:** якщо користувач часто пропускає депозити, тон стає м'якшим; якщо стабільний, більш амбітним.
- **Дані:** streak, missedDays, moodHistory, coachMode.

### 6. Financial Burnout Detector
- **Суть:** якщо користувач занадто часто відкладає й нервує, додаток радить зменшити темп.
- **Retention value:** зменшує ризик видалення додатка через втому або провину.
- **MVP:** сигнал burnout, якщо багато депозитів + негативний mood + часті відкати/undo.
- **Дані:** depositFrequency, moodTrend, undoCount, warningShownAt.

---

## 2. Анти-Імпульс і Усвідомлені Покупки

### 7. Anti-Impulse Timer
- **Суть:** відкладене рішення на покупку: 10 хв, 1 год або 24 год.
- **Retention value:** перетворює імпульсивну покупку на гру очікування.
- **MVP:** таймер із кнопками "все ще хочу" або "відмовився".
- **Дані:** itemName, amount, delayDuration, finalDecision.

### 8. Wish Radar
- **Суть:** список бажань із оцінкою "реально потрібно / емоційний порив".
- **Retention value:** користувач повертається, щоб переглядати бажання й очищати імпульси.
- **MVP:** wishlist із шкалою needScore 1-10 і impulseScore 1-10.
- **Дані:** title, amount, needScore, impulseScore, status.

### 9. One-Tap "I Almost Bought"
- **Суть:** швидка кнопка для запису покупки, від якої користувач відмовився.
- **Retention value:** відмова від покупки стає перемогою, а не просто нічим.
- **MVP:** кнопка на dashboard, сума, назва, причина, збережена сума.
- **Дані:** title, avoidedAmount, triggerType, createdAt.

### 10. Impulse Category Lock
- **Суть:** тимчасово блокує категорію витрат, яку користувач сам вибрав.
- **Retention value:** створює відчуття контролю і добровільного контракту.
- **MVP:** lock на 24 години / 7 днів для категорії: кафе, ігри, одяг тощо.
- **Дані:** category, lockedUntil, reason.

### 11. Temptation Budget
- **Суть:** окремий ліміт на "дурні, але дозволені" покупки.
- **Retention value:** знімає провину й робить фінансову дисципліну реалістичною.
- **MVP:** місячний ліміт для імпульсних покупок.
- **Дані:** monthlyLimit, spentAmount, resetDate.

### 12. Guilt-Free Spend Pass
- **Суть:** якщо план виконано, користувач отримує безпечний дозвіл на маленьку витрату.
- **Retention value:** баланс між дисципліною та задоволенням.
- **MVP:** pass відкривається після виконання weekly promise або savings sprint.
- **Дані:** passAmount, earnedAt, expiresAt, usedAt.

### 13. Price-per-Hour Reality Check
- **Суть:** покупка показується як "скільки годин роботи це коштує".
- **Retention value:** швидко охолоджує імпульс.
- **MVP:** користувач вводить погодинну ставку або місячний дохід.
- **Дані:** itemAmount, hourlyRate, calculatedHours.

### 14. Manual Receipt Vault
- **Суть:** фото чеків без банкінгу, щоб бачити реальні витрати.
- **Retention value:** додає відчуття контролю навіть без open banking.
- **MVP:** фото + сума + категорія + дата.
- **Дані:** imagePath, amount, category, createdAt.

---

## 3. Цілі, Сенс, Прогрес

### 15. Goal Story Mode
- **Суть:** кожна ціль має сюжетні глави, які відкриваються на 10/25/50/75%.
- **Retention value:** прогрес стає історією, а не тільки відсотком.
- **MVP:** 4 story cards на кожну ціль.
- **Дані:** goalId, milestonePercent, storyText, unlockedAt.

### 16. Goal Rival Mode
- **Суть:** дві власні цілі змагаються між собою за внески.
- **Retention value:** додає драму і вибір у звичайний split.
- **MVP:** екран порівняння goal A vs goal B за тиждень.
- **Дані:** goalIds, period, scoreA, scoreB.

### 17. Deposit Memory
- **Суть:** кожен великий внесок можна прив'язати до фото/замітки "чому це важливо".
- **Retention value:** великі депозити стають емоційними спогадами.
- **MVP:** якщо депозит більший за поріг, запропонувати memory note.
- **Дані:** depositId, note, imagePath.

### 18. Future Price Shock
- **Суть:** показує, скільки ціль може коштувати через 3/6/12 місяців.
- **Retention value:** створює терміновість без агресивного тиску.
- **MVP:** простий inflationPercent у налаштуваннях цілі.
- **Дані:** goalId, basePrice, forecast3m, forecast6m, forecast12m.

### 19. Goal Deadline Negotiator
- **Суть:** якщо темп поганий, додаток пропонує чесно змінити дедлайн або суму.
- **Retention value:** користувач не кидає ціль, а адаптує її.
- **MVP:** card на goal detail: "план відстає, обери новий темп".
- **Дані:** goalId, currentPace, suggestedDeadline, suggestedMonthlyAmount.

### 20. Progress Debt Warning
- **Суть:** показує, скільки потрібно внести, щоб повернутися на план.
- **Retention value:** робить відставання конкретним і виправним.
- **MVP:** "щоб повернутися на графік, потрібно +X грн цього тижня".
- **Дані:** goalId, expectedProgress, actualProgress, debtAmount.

### 21. Savings Forecast Timeline
- **Суть:** "якщо продовжиш так, досягнеш цілі ось коли".
- **Retention value:** дає майбутню картинку, яку хочеться перевіряти.
- **MVP:** forecast date на goal detail.
- **Дані:** goalId, averageDailySave, estimatedCompletionDate.

### 22. Goal Priority Shuffle
- **Суть:** раз на тиждень додаток пропонує переоцінити пріоритети.
- **Retention value:** цілі залишаються живими й актуальними.
- **MVP:** weekly prompt із drag reorder.
- **Дані:** goalId, priorityRank, updatedAt.

### 23. Goal Protection Mode
- **Суть:** забороняє зменшувати суму цілі без паузи на підтвердження.
- **Retention value:** захищає від саботажу власних цілей.
- **MVP:** якщо користувач зменшує targetAmount, показати 24h confirmation.
- **Дані:** goalId, requestedChange, confirmAfter.

### 24. Goal Meaning Score
- **Суть:** додаток питає, наскільки ціль досі важлива від 1 до 10.
- **Retention value:** прибирає мертві цілі й підтримує мотивацію.
- **MVP:** щомісячний meaning check.
- **Дані:** goalId, score, note, createdAt.

### 25. Goal Rename Ritual
- **Суть:** якщо ціль втратила сенс, додаток допомагає її переформулювати.
- **Retention value:** не змушує кидати прогрес, а дозволяє змінити історію.
- **MVP:** guided rename dialog із питанням "для чого це тобі зараз?".
- **Дані:** goalId, oldName, newName, reason.

### 26. Abandoned Goal Recycling
- **Суть:** залишки з покинутої цілі красиво переносяться в нову.
- **Retention value:** зменшує відчуття провалу.
- **MVP:** action "recycle goal" із transfer amount.
- **Дані:** fromGoalId, toGoalId, transferredAmount, recycledAt.

### 27. Milestone Letters
- **Суть:** лист самому собі відкривається на конкретному прогресі.
- **Retention value:** сильний емоційний hook на milestone.
- **MVP:** користувач пише лист на 50% або 100%.
- **Дані:** goalId, unlockPercent, letterText, unlockedAt.

### 28. Why I Save Wall
- **Суть:** екран із персональними причинами, фото, цитатами й цілями.
- **Retention value:** відкривається при слабкій мотивації й повертає сенс.
- **MVP:** wall cards із текстом і фото.
- **Дані:** title, body, imagePath, pinnedGoalId.

---

## 4. Щоденні Ритуали, Тижневі Обіцянки, Повернення

### 29. Debt-to-Self
- **Суть:** якщо користувач пропустив депозит, додаток записує "борг самому собі".
- **Retention value:** пропуск стає виправним завданням.
- **MVP:** soft debt after missed day, без агресивного штрафу.
- **Дані:** amount, reason, createdAt, resolvedAt.

### 30. Smart Micro-Saves
- **Суть:** пропонує маленьку суму залежно від дня тижня і минулих звичок.
- **Retention value:** зменшує бар'єр входу в депозит.
- **MVP:** suggestion: 20/50/100 грн на основі median deposit.
- **Дані:** weekday, suggestedAmount, accepted.

### 31. Payday Ritual
- **Суть:** спеціальний сценарій у день зарплати: розподіл, сейв, аналіз.
- **Retention value:** формує найцінніший регулярний ритуал місяця.
- **MVP:** payday date + checklist із 3 кроків.
- **Дані:** paydayDate, completedSteps, savedAmount.

### 32. No-Spend Calendar
- **Суть:** календар днів без зайвих витрат.
- **Retention value:** проста візуальна механіка, яку хочеться продовжувати.
- **MVP:** manual mark day as no-spend.
- **Дані:** date, isNoSpend, note.

### 33. Weekly Promise
- **Суть:** користувач сам дає одну фінансову обіцянку на тиждень.
- **Retention value:** самостійно створений контракт сильніше мотивує.
- **MVP:** promise text + target date.
- **Дані:** weekStart, promiseText, status.

### 34. Promise Review
- **Суть:** у неділю додаток питає, чи обіцянка була реалістична.
- **Retention value:** утримує без сорому, через навчання.
- **MVP:** review screen: done / partly / unrealistic.
- **Дані:** promiseId, result, reflection.

### 35. Comeback Plan
- **Суть:** якщо користувач випав, додаток генерує м'який план повернення на 3 дні.
- **Retention value:** найважливіша функція для повернення після churn-ризику.
- **MVP:** trigger after 3+ inactive days.
- **Дані:** inactiveDays, planSteps, completedSteps.

### 36. Bad Week Forgiveness
- **Суть:** система не карає, а дає recovery-місію після провалу.
- **Retention value:** зменшує сором і повертає в гру.
- **MVP:** "тиждень був складний, ось 1 легка дія".
- **Дані:** weekScore, recoveryQuestId, completedAt.

### 37. End-of-Day Pulse
- **Суть:** вечірній короткий підсумок: що збережено, що зірвалось, що завтра.
- **Retention value:** щоденна причина повернутися в додаток.
- **MVP:** card о 20:00 із 3 пунктами.
- **Дані:** date, savedAmount, avoidedAmount, tomorrowFocus.

### 38. Morning Intent
- **Суть:** зранку користувач обирає один фінансовий фокус дня.
- **Retention value:** відкриває додаток на початку дня.
- **MVP:** one-tap intent: save, no-spend, avoid category, review goal.
- **Дані:** date, intentType, completed.

### 39. Quiet Mode Rewards
- **Суть:** нагорода не за активність, а за стабільність без хаосу.
- **Retention value:** підтримує користувачів, які не хочуть постійного шуму.
- **MVP:** нагорода за 7 днів без penalty, undo або missed streak.
- **Дані:** periodStart, periodEnd, rewardClaimed.

### 40. Tiny Win Feed
- **Суть:** стрічка маленьких перемог: "+20 грн", "не купив каву", "закрив день".
- **Retention value:** створює відчуття накопичення життя, а не тільки грошей.
- **MVP:** auto-feed із deposits, avoided purchases, diary, no-spend days.
- **Дані:** type, title, amount, createdAt.

---

## 5. Бюджет, Аналіз, Прогноз

### 41. Savings Weather
- **Суть:** фінансовий стан дня: ясно, туманно, шторм, стабільно.
- **Retention value:** миттєвий емоційний статус без складної аналітики.
- **MVP:** weather based on streak, goal progress, missed days.
- **Дані:** date, weatherType, score.

### 42. Subscription Hunter
- **Суть:** ручний список підписок із нагадуванням "ти точно цим користуєшся?".
- **Retention value:** регулярна економія, яку можна легко побачити.
- **MVP:** subscription list із monthly amount і nextChargeDate.
- **Дані:** title, amount, billingCycle, nextChargeAt, active.

### 43. Budget Autopsy
- **Суть:** після поганого тижня додаток розбирає, де саме все зламалось.
- **Retention value:** провал стає уроком, а не кінцем.
- **MVP:** weekly report when score below threshold.
- **Дані:** weekStart, weakCategories, missedHabits, recommendation.

### 44. Personal Rules Engine
- **Суть:** прості правила типу "якщо витратив на X, відклади Y".
- **Retention value:** перетворює поведінку на автоматизовані ритуали.
- **MVP:** manual rules with category and saveAmount.
- **Дані:** triggerCategory, saveAmount, enabled.

### 45. Savings Heat Zones
- **Суть:** години дня, коли користувач найчастіше робить корисні дії.
- **Retention value:** допомагає планувати нагадування у найкращий момент.
- **MVP:** heatmap by hour for deposits and avoided purchases.
- **Дані:** actionType, hourOfDay, count.

### 46. Personal Inflation Tracker
- **Суть:** користувач бачить, які його цілі дорожчають швидше.
- **Retention value:** додає реальний фінансовий тиск і актуальність.
- **MVP:** manual monthly price update per goal.
- **Дані:** goalId, observedPrice, checkedAt.

### 47. Manual Cash Jar
- **Суть:** окремий режим для готівкових накопичень.
- **Retention value:** охоплює людей, які відкладають кешем.
- **MVP:** cash balance per jar without bank sync.
- **Дані:** jarName, amount, currency, updatedAt.

---

## 6. Челенджі, Соціальність, Спільні Дії

### 48. Accountability Partner Lite
- **Суть:** друг бачить тільки факт "сьогодні зроблено/не зроблено", без сум.
- **Retention value:** соціальна відповідальність без розкриття приватних фінансів.
- **MVP:** share daily status only.
- **Дані:** partnerId, date, status.

### 49. Private Challenge Link
- **Суть:** створити короткий челендж і поділитися посиланням.
- **Retention value:** органічне повернення через друзів.
- **MVP:** local challenge object + share text/link placeholder.
- **Дані:** challengeTitle, targetDays, inviteCode.

### 50. Savings Sprint
- **Суть:** режим 7 днів із фокусом на одну конкретну ціль.
- **Retention value:** короткий інтенсив краще запускає звичку.
- **MVP:** start sprint, choose goal, daily checklist.
- **Дані:** goalId, startDate, endDate, completedDays.

### 51. Monthly Boss Fight
- **Суть:** фінальний виклик місяця на основі реальної поведінки.
- **Retention value:** створює кульмінацію місячного циклу.
- **MVP:** boss challenge generated from weakest behavior.
- **Дані:** month, bossType, targetMetric, completed.

### 52. Budget Escape Room
- **Суть:** користувач "розблоковує" місяць, виконуючи фінансові умови.
- **Retention value:** gamified monthly journey.
- **MVP:** 3 locks: deposit, no-spend, diary.
- **Дані:** month, locksCompleted, rewardClaimed.

### 53. Family Goal Board
- **Суть:** спільна дошка цілей для сім'ї без складної соціальної мережі.
- **Retention value:** сімейні цілі мають сильну довгострокову мотивацію.
- **MVP:** local shared board first, Firebase later.
- **Дані:** boardId, members, goals.

---

## 7. Візуальні, Приватні, Платформні Функції

### 54. Goal Playlist
- **Суть:** до цілі можна прив'язати музику/звук, який вмикається при прогресі.
- **Retention value:** робить ціль сенсорно впізнаваною.
- **MVP:** choose built-in sound per goal.
- **Дані:** goalId, soundId.

### 55. Progress Postcards
- **Суть:** красиві картки прогресу для себе або друзів.
- **Retention value:** соціальне поширення і особиста гордість.
- **MVP:** shareable image from RepaintBoundary.
- **Дані:** goalId, templateId, generatedAt.

### 56. Financial Screenshot Mode
- **Суть:** приватний режим для скріншоту без сум і чутливих даних.
- **Retention value:** дозволяє ділитися прогресом без страху.
- **MVP:** global toggle hiding amounts in share/screenshot mode.
- **Дані:** setting only.

### 57. Progress Lock Screen Widget
- **Суть:** маленький віджет із відсотком головної цілі.
- **Retention value:** повертає користувача без відкриття застосунку.
- **MVP:** Android/iOS widget later; спочатку design spec.
- **Дані:** primaryGoalId, progressPercent.

### 58. Quick Save Widget
- **Суть:** кнопки 20/50/100 грн прямо з домашнього екрана.
- **Retention value:** зменшує friction до депозиту.
- **MVP:** platform widget після стабілізації core deposit API.
- **Дані:** presetAmounts, defaultSplit.

---

## 8. Ідентичність і Довгострокова Мотивація

### 59. Savings Identity Badges
- **Суть:** не просто досягнення, а ролі за стиль поведінки.
- **Retention value:** користувач бачить не "бейдж", а свою фінансову ідентичність.
- **MVP:** badges: Calm Saver, Comeback Maker, Anti-Impulse, Payday Strategist.
- **Дані:** identityType, earnedAt, evidence.

### 60. Streak Insurance
- **Суть:** користувач може купити захист streak за реальний попередній прогрес, не за кристали.
- **Retention value:** захищає від rage quit після одного пропуску.
- **MVP:** insurance unlocks after 14-day streak; costs one completed promise or no-spend week.
- **Дані:** insuranceCount, earnedFrom, usedAt.

---

## Рекомендовані Фази Реалізації

### Phase A: Daily Retention Core
1. Mood-to-Money Check-in
2. One-Tap "I Almost Bought"
3. Фінансовий щоденник дня
4. No-Spend Calendar
5. End-of-Day Pulse
6. Morning Intent

### Phase B: Impulse Control
1. Anti-Impulse Timer
2. Wish Radar
3. Spending Trigger Map
4. Impulse Category Lock
5. Temptation Budget
6. Price-per-Hour Reality Check

### Phase C: Goal Emotion Layer
1. Goal Story Mode
2. Milestone Letters
3. Why I Save Wall
4. Deposit Memory
5. Goal Meaning Score
6. Goal Rename Ritual

### Phase D: Recovery and Forecasting
1. Comeback Plan
2. Bad Week Forgiveness
3. Debt-to-Self
4. Savings Forecast Timeline
5. Progress Debt Warning
6. Goal Deadline Negotiator

### Phase E: Social and Platform Expansion
1. Accountability Partner Lite
2. Private Challenge Link
3. Family Goal Board
4. Progress Postcards
5. Progress Lock Screen Widget
6. Quick Save Widget

---

## Найкращий Перший MVP

Перший MVP має бути малим, але щоденним:

1. **Mood-to-Money Check-in** перед депозитом.
2. **One-Tap "I Almost Bought"** на dashboard.
3. **Фінансовий щоденник дня** як вечірній ритуал.
4. **No-Spend Calendar** як проста візуальна петля.
5. **End-of-Day Pulse** як щоденне повернення.

Цей набір не конфліктує з уже наявними XP, streak, pets, squads, leaderboard і AI coach. Він додає те, чого зараз бракує найбільше: емоційну пам'ять, саморефлексію і м'яке повернення після зриву.
