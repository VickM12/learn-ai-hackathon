---
doc: spec
status: approved
---

# Vineyard Journal — Technical Spec

## How This Works, In Plain Language

Vineyard Journal is a Godot app exported as one Windows program. TwoBit Territories LLC is the company name written into that program. It is not cryptographically signed, because there is no signing certificate yet. Windows may warn that the publisher is unknown. The program still runs locally.

The zip code and the journal live in one file on the machine, in Godot’s `user://` folder for this app. Nothing is sent to an account.

Weather comes from Open-Meteo. The app turns the zip into a place, then asks for temperature and humidity: right now, the next 7 days, and the past 90 days. That reply fills Today and the weather tab. A failed weather call leaves the journal usable.

Opening the app on a given day loads that day’s page. Saving writes that day into the file. Opening the app again the same day reads that same entry back.

## The Core Journey Through the System

PRD ref: `prd.md > The Core Journey`.

1. The executable starts and `JournalStore` reads `user://journal.json`. No file yet means no zip and no entries.
2. No zip: `ZipPrompt` is the only screen. They type a zip. `WeatherClient` asks Open-Meteo’s geocoding service. A US result whose postcodes include that exact zip is kept, and the zip, latitude, longitude, and place name are saved. Any other result is a failed lookup: the prompt stays, with a plain error and retry. The zip is not saved until a match exists, because this proof has no way to change it later.
3. Zip saved: `Today` opens for the computer’s local date. `WeatherClient` requests the forecast. Current temperature (°F) and humidity (%) fill those fields and stay editable. Soil pH, sugar, and notes load from today’s entry if one exists; otherwise they are empty.
4. No entries in the file: Today also shows “write an entry to get started.”
5. Forecast failed: Today shows a short plain error and retry. Soil pH, sugar, notes, and save still work. Temperature and humidity stay editable and empty until a later pull succeeds.
6. Save writes today’s fields into `journal.json` under that date, replacing any previous entry for the same date. Empty fields are stored as empty. The page shows the saved values.
7. They quit and open the executable again the same day. `JournalStore` finds that date and `Today` shows the saved entry.
8. `Calendar` lists days. Choosing one shows that date, Open-Meteo’s temperature and humidity when that date is inside the loaded 90-day past plus 7-day forecast, and the saved entry when one exists.
9. `Weather` shows today’s current readings, the 7-day forecast, the 90-day history, and two trend charts (temperature, humidity). Preset and custom date ranges filter both rows and charts. A credit line names Open-Meteo.
10. `Journal` lists saved entries and draws a soil-pH chart from entries that have a pH value.

## Stack

- **Godot 4.7.2 stable**, standard build, GDScript. They asked for Godot. GDScript avoids the .NET editor and export templates. Docs: https://docs.godotengine.org/en/stable/ — download: https://godotengine.org/download/archive/4.7.2-stable/
- **Windows Desktop export**, x86_64, pck embedded so the demo is one `.exe`. Docs: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html
- **Open-Meteo** for geocoding and forecast. No API key on the non-commercial endpoint. Docs: https://open-meteo.com/en/docs and https://open-meteo.com/en/docs/geocoding-api
- **No chart library.** Trends are drawn by a Godot control.
- **One OFL serif font** bundled in the project so the journal is not Godot’s default UI font. The family is an implementation choice inside the leather-and-parchment direction.

Godot 4.7.2 was the stable release listed on 18 August 2026. Confirm that download page at the start of the build if a newer stable has replaced it.

## Where It Runs and How Someone Tries It

Local Windows executable. No server and no deploy.

Requirements: Godot 4.7.2, the matching Windows export templates, and a network connection when weather is fetched. No API key.

While building, open the project in Godot and press F5 (play). For the demo recording, export a release Windows build and start that `.exe`.

Export metadata:

- Company name: `TwoBit Territories LLC`
- Product name: `Vineyard Journal`
- Code signing: off (`codesign/enable` false)

The certificate and any future password stay out of the repo and out of chat. When a certificate exists, signing is turned on in the export preset and `SignTool` is set in the editor. That step is not part of this proof.

Submission still needs a short screen recording of the running executable and a public git repository. Reviewers are not expected to run the unsigned executable themselves.

## Look and Feel

Implements `prd.md > Look and Feel`. `scope.md > Inspiration & Identity` had no references.

The window is a dark brown leather frame around a parchment page. Ink is near-black brown. Body text is a serif. Errors use the same palette, worded as a short plain sentence, not a browser alert.

Build values, derived from that direction rather than a new design choice:

- Leather: `#3b2416`
- Parchment: `#f4e4c4`
- Ink: `#2a2118`
- Rule lines and secondary text: `#8c6a45`

Godot `StyleBoxFlat` and a project theme can honor this. No web CSS and no extra UI framework.

## Components

### App shell

`Main` shows the zip prompt, then a tab bar: Dashboard, New entry, Past journals, Weather, and Calendar. The dashboard is a weather snapshot with those same actions. The entry form is only the New entry tab.

PRD ref: `prd.md > Screens and Layout`.

### Zip prompt

Shown only when `journal.json` has no saved zip. One field and a continue action. On success, saves zip, coordinates, and place name, then opens Today. On failure, stays here.

PRD ref: `prd.md > Zip code`, `prd.md > States and Boundaries`.

### Today

The dashboard snapshot: place, date, current temperature, and humidity. Today's saved soil pH, sugar, and notes appear here after a save. The editable form is the New entry tab.

PRD ref: `prd.md > Today's entry`.

### Weather view

Today’s current temperature and humidity, seven daily forecast rows, ninety daily history rows, a temperature chart, a humidity chart, preset/custom date ranges, retry, and the Open-Meteo credit.

PRD ref: `prd.md > Weather`.

### Calendar

A month grid. Selecting a day shows that date, weather for that date when it is in the loaded range, and the saved entry fields when they exist. A past day with no entry shows the date, whatever weather is available, and empty entry fields. The grid does not create an entry for a day other than the day the app was opened. Viewing a past day does not change today’s date key.

PRD ref: `prd.md > Calendar`.

### Journal view

A list of saved dates and their stored fields. A soil-pH chart uses only entries with a numeric pH. No sugar chart.

PRD ref: `prd.md > Journal list and soil trend`.

### Journal store

Reads and writes `user://journal.json`. Creates the file on first successful zip save or first entry save. Leaving the app and coming back reads this file.

PRD ref: `prd.md > States and Boundaries`.

### Weather client

Calls the Open-Meteo URLs below through Windows `curl.exe`. Godot 4.7.2 `HTTPRequest` failed the TLS handshake with mbedtls `-0x2700` (certificate verify failed); curl uses the OS certificate store and succeeds. Holds the latest successful forecast in `last_forecast` for the session so Calendar and Weather can share it. Does not write the forecast into the journal. The journal stores only what they saved.

PRD ref: `prd.md > Weather`.

### Trend chart

One control, used twice on Weather (temperature, humidity) and once on Journal (soil pH). Draws a line from dated numbers. An empty series draws an empty parchment panel, not an error.

## Data Model

File: `user://journal.json`. On Windows that directory is the app’s Godot user-data folder (`OS.get_user_data_dir()`), which survives quitting the executable.

```json
{
  "zip": "44024",
  "place_name": "Chardon",
  "latitude": 41.61422,
  "longitude": -81.14899,
  "entries": {
    "2027-05-12": {
      "temperature": 68.0,
      "humidity": 55.0,
      "soil_ph": 6.5,
      "sugar": null,
      "notes": "Buds swelling on the north end."
    }
  }
}
```

- `zip` is absent until geocoding returns a US place whose `postcodes` contain that exact zip.
- Entry keys are `YYYY-MM-DD` in the computer’s local timezone, the day the app was opened.
- Number fields are JSON numbers, or `null` when left blank.
- `notes` is a string, possibly empty.
- Updated by Save on Today, for that date key only.
- On return, the file is the source for the zip and the entries. Weather is fetched again.

Display units: Fahrenheit and percent humidity. `temperature_unit=fahrenheit` is an implementation default for a northeast Ohio reading, not a separate product decision. Change it here if Celsius is preferred before the build.

## File Structure

```
project.godot                 # name Vineyard Journal; main scene
export_presets.cfg            # Windows Desktop; company TwoBit Territories LLC; codesign off
icon.svg
scenes/
  main.tscn                   # App shell
  zip_prompt.tscn
  today.tscn
  calendar.tscn
  weather.tscn
  journal.tscn
scripts/
  main.gd
  journal_store.gd
  weather_client.gd
  zip_prompt.gd
  today.gd
  calendar_view.gd
  weather_view.gd
  journal_view.gd
  trend_chart.gd
theme/
  vineyard_theme.tres
  EBGaramond-Regular.ttf      # OFL serif; any OFL serif may be substituted
devpost/                      # planning docs; not part of the exported game
README.md                     # how to open the project and export the exe
```

## External Services and Dependencies

No keys. Non-commercial Open-Meteo use, up to 10,000 calls a day, with attribution. A shipped paid product would need their commercial key. Docs: https://open-meteo.com/

A lookup of zip `44024` on 2 October 2026 returned Chardon, Ohio first, and also Nantes, France, because French postal labels contain `44024`. The client must not take `results[0]` blindly.

**Geocoding**

`GET https://geocoding-api.open-meteo.com/v1/search?name={zip}&count=10`

Use the first result where `country_code` is `US` and `postcodes` includes the exact zip string. Store `latitude`, `longitude`, `name`, and `timezone`.

**Forecast**

`GET https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,relative_humidity_2m&hourly=relative_humidity_2m&daily=temperature_2m_mean&temperature_unit=fahrenheit&timezone=auto&past_days=90&forecast_days=7`

Humidity has no daily aggregate in the forecast docs, so the client averages `hourly.relative_humidity_2m` into one percent per local day. Daily temperature is `temperature_2m_mean`. Today’s form fields use `current`, not the daily mean.

Checked against the forecast parameter list fetched for this spec: https://open-meteo.com/en/docs — `past_days` max 92, `timezone=auto` is supported, `temperature_unit=fahrenheit` is supported. The exact URL should be requested once at the start of the build and adjusted if a parameter is rejected.

Weather credit, on the weather surface: “Weather data by Open-Meteo.com, CC BY 4.0.”

## Important Failure Modes

- **Zip matches no US postcode** → stay on the zip prompt, plain error, retry. Do not write the zip.
- **Forecast request fails or times out** → on Today, a short plain error and retry. Save still works. Temperature and humidity stay empty and editable until a pull succeeds. Implements `prd.md > Weather`.
- **A number field is not blank and not a number** → leave the page as it is, mark that field, and do not write the file. Blank is valid.
- **A calendar day is outside the loaded 37-day weather window** → show the saved entry if it exists, and a short line that weather for that day is not in the loaded range. Do not block the journal.
- **Unsigned executable** → Windows may show an unknown-publisher warning. The demo path is to run it anyway. This is expected until a certificate exists.

## What Was Simplified and Why

- **Company name in the exe, signing off** instead of a signed publisher — there is no certificate yet. Signing needs a certificate plus Windows SDK `SignTool`, then `codesign/enable` on the Windows preset. Docs: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html
- **One JSON file** instead of a database — one grower, one site, one zip.
- **One Open-Meteo forecast call with `past_days=90`** instead of the separate historical archive — enough history for common 7/30/90-day ranges. Older journal days still open, but weather outside the loaded range is labeled unavailable.
- **Charts drawn in Godot** instead of a chart plugin — three series, no extra dependency.
- **Sugar is a stored field with no chart** — implements the PRD split. Source: `prd.md > Deferred From the POC`.

## Decisions and Open Issues

- **Godot, local Windows exe** — their choice. Tradeoff: the demo is an executable on this machine, not a link.
- **Godot 4.7.2 and GDScript** — recommended and accepted. Tradeoff: not the C# / .NET editor.
- **Open-Meteo, no key, with a visible credit** — recommended and accepted. Tradeoff: non-commercial terms; a paid product needs a commercial key later.
- **`user://journal.json`** — recommended and accepted. Tradeoff: the file is on this Windows user account, not synced.
- **Signing** — they do not have a certificate. What cleared it up: Godot can write `TwoBit Territories LLC` into the executable’s company field without a certificate. The publisher signature Windows verifies is a separate step and stays off until a certificate exists. No extra tool was added to learn signing.
- **Fahrenheit** — implementation default from the northeast Ohio site. Not a learner decision. Reject it at review if the readings should be Celsius.
- **Zip is saved only after a US exact-postcode match** — implementation consequence of “ask when none is saved” and “no edit control.” A typo stays on the prompt.
- **No learner uncertainty left open.** The certificate was the one real unknown, and it is resolved by leaving signing off.
- **Carried from `prd.md > Open Questions`:** changing the saved zip is still out. It does not block the build. A wrong zip that somehow got saved cannot be edited in this proof; the geocoding gate above is what keeps a failed lookup from getting that far.
