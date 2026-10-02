---
doc: prd
status: approved
---

# Vineyard Journal — Product Requirements

A leather-bound journal for one six-vine vineyard in northeast Ohio. The grower opens the day, sees that day's weather beside their own readings and notes, and can open an earlier day and see what they saved. Source: `scope.md > The Unique Kernel`, `scope.md > Who It's For`.

## The Core Journey

1. They open Vineyard Journal. If no zip code is saved, it asks for one before anything else. The zip is saved, and later opens skip the prompt.
2. They land on today. The date is the day they opened it. Temperature and humidity for that zip are filled in and can be edited. Soil pH, sugar content, and a notes box are there and empty. If the journal has no entries yet, it says "write an entry to get started."
3. If the weather cannot be pulled, they see a short, plain error and a retry control. They can still save.
4. They type whatever they have. Nothing is required. They save. The entry is stored as that day's date, and the page shows what they saved.
5. They leave and open the journal again that same day. They see that saved entry, not a blank page.
6. They open the calendar and choose an earlier date. They see that day's weather and that day's journal entry.
7. They open the weather tab for today's forecast, the weekly forecast, past weather, and a trend. They open the journal tab for past entries and the soil trend.

Success is the demo beat from `scope.md > What "Working" Looks Like`: save a reading, see it on today's page, then open a past day and see the weather beside that entry, plus a trend over time.

## Screens and Layout

Five surfaces, and no others.

- **Zip prompt.** Shown only when no zip is saved. One zip code field and a way to continue. After it is saved, this prompt does not appear again in this proof.
- **Today.** The dashboard and the entry are the same page. The date, temperature, humidity, soil pH, sugar content, notes, and save. The empty-journal line sits on this page when the journal has no entries.
- **Calendar.** Earlier dates. Choosing one opens that day: its weather and its journal entry.
- **Weather.** Today's forecast, the weekly forecast, historical weather, and a trend graph.
- **Journal.** Past entries, and a soil-health trend.

They move among Today, Calendar, Weather, and Journal directly. No extra home screen.

## Look and Feel

A leather-bound journal with parchment paper. Source: their direction during the PRD interview. No other visual references were chosen. Type, exact colors, and decoration stay inside that metaphor. `4-spec` turns this into styling and does not ask again.

## Features and Behavior

### Today's entry

Source: `scope.md > The Core Loop`, `scope.md > The POC Boundary`.

The page is the day the app was opened. Opening it on May 12, 2027, dates the entry May 12, 2027. They do not pick a different date.

Fields, all editable:

- Temperature, filled from the local weather for the saved zip when the pull succeeds
- Humidity, filled the same way
- Soil pH
- Sugar content
- Notes and observations, free text

Nothing is required. Saving an empty page still saves that day. Saving again on that day updates the entry they are looking at. Opening the journal again that day shows the previously saved entry in those fields.

- [ ] The date on the page is the day the app was opened.
- [ ] Temperature and humidity are filled from the saved zip when weather loads, and both can be changed before saving.
- [ ] Soil pH, sugar content, and notes are present, editable, and allowed to be empty.
- [ ] Save works with every field empty.
- [ ] After save, the page shows the values that were saved.
- [ ] Opening the app again that same day shows that saved entry.

### Zip code

The first open with no saved zip asks for a zip code. Saving it is what unlocks Today. Later opens use the saved zip and do not ask again.

- [ ] With no zip saved, the first thing on screen is a zip prompt.
- [ ] After a zip is saved, reopening the app does not show the prompt.
- [ ] Weather on Today uses that zip.

### Weather

Source: `scope.md > The POC Boundary`.

The only weather measures in this proof are temperature and humidity.

Today's forecast and the weekly forecast show temperature and humidity. Historical weather is temperature and humidity for past days. The trend graph plots those over time. This is the weather tab, separate from the fields stored on the journal entry.

- [ ] The weather tab shows today's forecast, a weekly forecast, past days, and a trend graph.
- [ ] Those views show temperature and humidity.
- [ ] If the weather cannot be pulled, Today shows a short plain error and a retry control.
- [ ] Retry requests the weather again.
- [ ] The error does not block saving the day's entry.

### Calendar

Source: `scope.md > The Core Loop`.

Choosing an earlier date shows that day's weather and that day's journal entry. A past day with no entry shows the day and its weather, and an empty entry.

- [ ] A past date can be opened from the calendar.
- [ ] That view shows the date, that day's temperature and humidity, and that day's saved fields when an entry exists.

### Journal list and soil trend

Source: `scope.md > The POC Boundary`.

The journal tab lists past entries. Each entry shows its date and whatever was saved: temperature, humidity, soil pH, sugar content, and notes. The soil trend plots soil pH across entries that have a pH value.

- [ ] Past entries appear as a list with date and saved fields.
- [ ] The soil trend uses saved soil pH values.
- [ ] With no entries in the journal, Today says "write an entry to get started."

## States and Boundaries

- **No zip saved** — the zip prompt is the whole screen. No weather, no entry form.
- **Zip saved, journal empty** — Today shows the date, weather fields when the pull succeeds, empty soil pH, sugar, and notes, and the line "write an entry to get started."
- **Zip saved, this day already has an entry** — Today shows that saved entry. The empty-journal line is gone.
- **Zip saved, earlier days have entries, today does not** — Today is a blank entry for today, with weather filled when the pull succeeds. The empty-journal line stays off, because the journal is not empty.
- **Weather failed** — a short plain error and retry. Soil pH, sugar, notes, and save still work. Temperature and humidity stay editable and empty until a pull succeeds.
- **Saved** — the day's entry and the zip remain the next time the app is opened.
- **One site** — the six vines are one journal. There is no per-vine page in this proof. Source: `scope.md > Later`.

## Product Decisions

- **Vineyard Journal** — the name they confirmed.
- **One entry per day, dated the day the app is opened** — "If i open the journal on May 12, 2027, it should save as May 12, 2027."
- **Reopening that day shows the previously saved entry** — their answer when asked what a second open the same day should show.
- **Nothing is required to save** — partial notes are normal. They often will not have every reading.
- **Sugar content is a field in this proof** — they pulled it in after scope had parked sugar until a spectrometer existed. The field can sit empty.
- **Zip is asked once, then saved** — "prompt for a zipcode if none is saved."
- **Weather failure is an error plus retry, and save still works** — their error behavior, plus the rule that nothing is required to save.
- **Empty journal copy** — "write an entry to get started."
- **Leather and parchment** — the look they chose.
- **Assumption:** this proof does not include a way to change the zip after it is saved. They only described the first prompt.

## What We're Building

- Zip prompt when none is saved, then a saved zip
- Today's page: date, editable temperature and humidity, soil pH, sugar content, notes, save with nothing required
- Same-day reopen shows that day's saved entry
- Weather failure: plain error and retry, save still available
- Empty journal: "write an entry to get started"
- Calendar of earlier days, each with that day's weather and entry
- Weather tab: today's forecast, weekly forecast, historical temperature and humidity, trend graph
- Journal tab: past entries and a soil pH trend
- Leather-bound journal, parchment pages

## Deferred From the POC

- **Sugar trend.** The sugar field is in. A graph of sugar is not. Scope had parked sugar until a spectrometer existed; they added the field and did not pull the graph into this proof. Source: `scope.md > Later`.
- **Changing the saved zip.** Not described. Assumed out. See Open Questions.
- **Daily, weekly, and monthly maintenance advice.** Needs a model API later. Source: `scope.md > Later`.
- **Per-vine health.** The proof is one site. Source: `scope.md > Later`.
- **On-site weather station and sunlight sensors.** This proof uses zip-code weather. Source: `scope.md > Later`.
- **Vegetable garden:** planting plans, rotations, seasonal forecasts. Source: `scope.md > Later`.

## Possible Later Enhancements

Advice over the saved journal once there is enough to analyze. A sugar trend once readings exist. A page per vine. A weather station on the site, including sunlight. The same journal shape for the vegetable garden.

## Non-Goals

- Accounts, more than one vineyard, or more than one zip in this proof. The grower is the only user, and the site is this six-vine plot.
- Choosing an entry date other than the day the app is opened. The calendar reads past days. It does not backdate a new entry.
- Recommendations, chat, or analysis of the journal in this proof.
- Live sensors. Readings are typed.

## Open Questions

- **Changing the saved zip.** Assumed out of this proof. Does not block `4-spec` if that assumption holds. Say so if the zip needs an edit control before the build.
