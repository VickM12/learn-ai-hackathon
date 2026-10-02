---
doc: scope
status: approved
---

# Vineyard Journal

A weather and journal dashboard for planning and running a six-vine vineyard in northeast Ohio.

## The Unique Kernel

One place that puts the weather for this vineyard next to the readings and notes the grower actually took. The point is not a generic forecast, and not advice yet. It is being able to open a date and see what the weather was doing alongside the soil readings and notes from those six vines.

## Who It's For

The grower of a six-vine vineyard in northeast Ohio. They know how wine is made — culinary business management degree, distillery work, wine tasting and food-and-beverage classes — and next to nothing about planting and maintaining vines. The varietal is already picked. They have a small soil reader. This is the tool they open to track the site and keep a record.

## The Core Loop

They open a dashboard and see the current weather and the date. They log a journal entry with soil readings and whatever notes they need. Once it is submitted, the dashboard updates with those readings. They use a calendar to open an earlier date and see that day's weather and journal entry. They come back to log the next reading and look at how the weather and the soil record line up over time.

## Inspiration & Identity

Not established. No reference apps, visual style, or tone were chosen. The shape they described is a dashboard, a calendar, a weather tab, and a journal tab. Look and feel belongs in the PRD.

## Why This Matters to the Learner

They are trying to plan and run this small vineyard without a background in vine care. "I'd like something that can help me plan and run my small 6 vine vineyard in northeast ohio."

## What "Working" Looks Like

They open the app and see a dashboard with the current weather overview, the date, and the latest readings. They log a new entry — soil readings and notes — submit it, and the dashboard updates. A calendar shows earlier dates, each with that day's weather and journal entry. A weather tab shows today's forecast, the weekly forecast, historical weather, and a graph of trends. A journal tab shows past entries and soil-health trends.

The demo beat: log a soil reading, see it on the dashboard, then open a past date and see the weather beside that journal entry, plus a trend over time.

## The POC Boundary

In, and only this:

- Dashboard with current weather, the date, and the latest logged readings
- A journal entry for soil readings and notes, which updates the dashboard on submit
- A calendar of previous dates with that day's weather and journal entry
- A weather tab: today's forecast, the weekly forecast, historical weather, and a trend graph
- A journal tab: past entries and soil-health trends

## Later

- Daily, weekly, and monthly maintenance advice. They want recommendations, and they expect that to need an API hookup to something cheap, such as ChatGPT, to analyze the data. Out of this proof so the weather-and-journal loop can get working first.
- Grape sugar, once they have a spectrometer. The journal can gain that reading then; it is not required to prove the loop.
- Per-vine health. They called this the super-granular version. The proof treats the six vines as one site.
- An on-site weather station with sunlight sensors, once they build the hardware. This proof shows weather for the site without that station.
- A vegetable-garden version: planting plans, crop rotations, and seasonal forecasts. Same kind of tool, not this proof.

## Explicitly Cut

Nothing was rejected outright. Work that is out of this proof is deferred under Later, with a reason, not dropped silently.
