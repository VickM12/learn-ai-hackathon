---
doc: checklist
status: approved
---

# Build Checklist

Build mode: fast

## Slices

- [x] **1. Log today against live weather**
  Becomes usable: Open the app, enter a zip, see today's temperature and humidity on a parchment page, save soil pH, sugar, and notes, quit, and reopen the same day to the saved entry.
  Why now: This is the kernel — weather for the site beside the readings — and it is where Open-Meteo can fail. The Godot project is created inside this slice, not before it.
  PRD ref: `prd.md > Today's entry`, `prd.md > Zip code`, `prd.md > States and Boundaries`
  Spec ref: `spec.md > App shell`, `spec.md > Zip prompt`, `spec.md > Today`, `spec.md > Journal store`, `spec.md > Weather client`, `spec.md > Data Model`, `spec.md > Look and Feel`, `spec.md > External Services and Dependencies`, `spec.md > Important Failure Modes`
  Build: Create the Godot 4.7.2 project, leather-and-parchment theme, zip prompt, Today page, `user://journal.json` load and save, and the Open-Meteo geocoding plus forecast calls. A bad zip stays on the prompt. A failed forecast shows a plain error and retry, and save still works. Empty journal shows "write an entry to get started." Company name on the Windows export preset is TwoBit Territories LLC, with code signing off.
  Verify (mechanical): Run a headless Godot script that geocodes zip 44024 to a US place whose postcodes include 44024, writes an entry for the local date, reloads the file, and prints the place name plus the saved fields. Then load the project headless and confirm it quits without a script error.
  Learner check: Press F5, enter your vineyard zip, save a soil reading and a note, close the app, press F5 again, and confirm today's entry is still there.
  Commit: `Log today's vineyard readings against live weather`

- [x] **2. Open an earlier day**
  Becomes usable: Pick a past date and see that day's weather beside that day's journal entry.
  Why now: The kernel is opening a date, not only logging today. Today has to save first so a past day has something to show.
  PRD ref: `prd.md > Calendar`, `prd.md > The Core Journey`
  Spec ref: `spec.md > Calendar`, `spec.md > Weather client`, `spec.md > Data Model`
  Build: Add the calendar tab. Selecting a day shows its date, Open-Meteo temperature and humidity when that day is in the loaded range, and the saved entry when one exists. Selecting a day does not create or redate an entry. A day outside the loaded weather range still shows a saved entry and a short line that weather for that day is not loaded.
  Verify (mechanical): Headless script seeds two dates in `journal.json`, loads the forecast fixture or live range check, and prints the past date's saved notes plus whether weather for that date was found.
  Learner check: Save today, open the calendar, choose another day, and confirm you see that day rather than a second copy of today.
  Commit: `Show weather and the journal entry for an earlier day`

- [x] **3. Forecast, history, and the soil trend**
  Becomes usable: A weather tab with today's forecast, the week, 90 days of history, range-filtered temperature and humidity charts, and the Open-Meteo credit. A journal tab with range-filtered past entries and a soil pH chart.
  Why now: These are the look-across-time views. They sit on the file and the forecast slice 1 already proved.
  PRD ref: `prd.md > Weather`, `prd.md > Journal list and soil trend`
  Spec ref: `spec.md > Weather view`, `spec.md > Journal view`, `spec.md > Trend chart`, `spec.md > External Services and Dependencies`
  Build: Add the weather and journal tabs. Charts are drawn in Godot. Soil chart skips entries with no pH. Sugar stays a field with no chart. Credit line: "Weather data by Open-Meteo.com, CC BY 4.0."
  Verify (mechanical): Headless script feeds a known series of temperatures, humidities, and soil pH values into the chart data helpers and prints the point counts. Load the project headless and confirm it quits without a script error.
  Learner check: Open the weather tab and the journal tab and confirm the forecast, the trends, the credit, and your saved entries are on screen.
  Commit: `Add weather history, trends, and the soil chart`

## Hands-on Checkpoints

- [x] Early usable behavior explored — learner ran the Godot proof, supplied screenshots, and used the feedback to reshape the dashboard, tabs, spacing, charts, and date-range interaction before the Tauri rewrite
- [ ] Final kick-the-tires exploration and feedback completed

## Final Review

- [ ] Final review complete — feedback resolved and learner confirms ready to ship

## Code Tour and App Map

- [ ] Learning activity complete — guided route, focused alternative, prior practice connected, or brief recap
- [ ] Optional edit and transfer reflection addressed — offered/declined/already covered/not applicable as appropriate
- [ ] `devpost/app-map.html` generated from finished code, checked, and shown, including a project-grounded practice to reuse

Activity and evidence: not started
Route and stops: not started
Edit outcome: not started
Reflection: not started
Activity mode: not started

## Revisions

- Weather requests go through Windows `curl.exe` instead of Godot `HTTPRequest` — Godot 4.7.2 failed the TLS handshake to Open-Meteo with mbedtls error `-0x2700`, and the same GET succeeded with the OS certificate store. The URLs and the on-screen behavior are unchanged.
- Today's page scrolls — the Save button was below the window because the form was taller than the parchment page and nothing could scroll.
- The dashboard is a weather snapshot, and the entry form is a separate tab — the first build put the whole form on the opening screen. The learner's picture was a snapshot plus tabs for a new entry, past journals, and weather.
- The navigation now looks like folder tabs attached to a padded parchment page, and the dashboard uses summary cards — the first tabbed pass repeated navigation as large dashboard buttons and cramped text against the page edge.
- The New entry form now has inner page margins, and trend charts use labeled scales, grid lines, tinted fills, colored lines, and data markers — the first charts were unlabeled black polylines and the form still touched its inner border.
- Weather and Past journals now have common date-range presets plus a custom from/to range; applying one filters the visible rows and recomputes each chart. Weather history increased from 30 to 90 days so all common presets have data.
- Custom ranges now use an inline month calendar with previous/next navigation and separate Start/End selection buttons — typing `YYYY-MM-DD` was too cumbersome for the intended app.
- The implementation moved from Godot to Tauri 2 + React 19 while preserving the local Windows-executable boundary and approved product behavior — the Godot proof made ordinary desktop forms, native date inputs, tables, and charts disproportionately custom. The Tauri version uses native calendar controls, Recharts, WebView local storage, and browser `fetch`; the earlier Godot proof remains preserved.
