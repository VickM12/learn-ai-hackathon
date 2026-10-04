import { useEffect, useMemo, useRef, useState } from "react";
import {
  Area,
  AreaChart,
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { BookOpen, CalendarDays, ChevronDown, CloudSun, Grape, LayoutDashboard, PenLine } from "lucide-react";
import {
  dateOffset,
  fetchWeather,
  yearStart,
  formatNumber,
  geocodeZip,
  inRange,
  loadJournal,
  saveJournal,
  today,
  type JournalData,
  type JournalEntry,
  type WeatherData,
  type WeatherRow,
} from "./lib";
import { allVarietals, filterVarietals, inRegion, sprayFocusFor, spraySchedule, zoneFit, type Varietal, type ZoneFit } from "./varietals";

type Tab = "dashboard" | "entry" | "journals" | "weather" | "calendar" | "varietal";
type RangeValue = { start: string; end: string };

const tabs: { id: Tab; label: string; icon: typeof LayoutDashboard }[] = [
  { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
  { id: "entry", label: "New entry", icon: PenLine },
  { id: "journals", label: "Past journals", icon: BookOpen },
  { id: "weather", label: "Weather", icon: CloudSun },
  { id: "calendar", label: "Calendar", icon: CalendarDays },
  { id: "varietal", label: "Varietal", icon: Grape },
];

export default function App() {
  const [journal, setJournal] = useState<JournalData>(loadJournal);
  const [tab, setTab] = useState<Tab>("dashboard");
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [weatherError, setWeatherError] = useState("");
  const [weatherAttempt, setWeatherAttempt] = useState(0);
  const [historyStart, setHistoryStart] = useState(yearStart);
  const [weatherLoading, setWeatherLoading] = useState(false);

  useEffect(() => {
    if (!journal.location) return;
    let current = true;
    setWeatherError("");
    setWeatherLoading(true);
    fetchWeather(journal.location, historyStart)
      .then((result) => current && setWeather(result))
      .catch((error) => current && setWeatherError(error.message))
      .finally(() => current && setWeatherLoading(false));
    return () => {
      current = false;
    };
  }, [journal.location, weatherAttempt, historyStart]);

  const ensureHistory = (start: string) => {
    if (start && start < historyStart) setHistoryStart(start);
  };

  const updateJournal = (next: JournalData) => {
    setJournal(next);
    saveJournal(next);
  };

  if (!journal.location) {
    return (
      <Setup
        onComplete={(location) => updateJournal({ ...journal, location })}
      />
    );
  }

  const currentEntry = journal.entries[today()];
  const weatherByDate = new Map(weather?.rows.map((row) => [row.date, row]) ?? []);

  return (
    <main className="app-shell">
      <nav className="folder-tabs" aria-label="Journal sections">
        {tabs.map(({ id, label, icon: Icon }) => (
          <button
            key={id}
            className={tab === id ? "folder-tab active" : "folder-tab"}
            onClick={() => setTab(id)}
          >
            <Icon size={18} />
            <span>{label}</span>
          </button>
        ))}
      </nav>

      <section className="paper">
        {tab === "dashboard" && (
          <Dashboard
            place={journal.location.name}
            entry={currentEntry}
            weather={weather}
            weatherError={weatherError}
            retry={() => setWeatherAttempt((value) => value + 1)}
          />
        )}
        {tab === "entry" && (
          <EntryForm
            key={currentEntry?.date ?? "new"}
            entry={currentEntry}
            weather={weather}
            onSave={(entry) => {
              updateJournal({
                ...journal,
                entries: { ...journal.entries, [entry.date]: entry },
              });
              setTab("dashboard");
            }}
          />
        )}
        {tab === "journals" && (
          <Journals entries={journal.entries} weatherByDate={weatherByDate} />
        )}
        {tab === "weather" && (
          <WeatherView
            weather={weather}
            error={weatherError}
            loading={weatherLoading}
            onHistoryStart={ensureHistory}
          />
        )}
        {tab === "calendar" && (
          <CalendarView entries={journal.entries} weatherByDate={weatherByDate} />
        )}
        {tab === "varietal" && <VarietalGuide zip={journal.location.zip} place={journal.location.name} />}
      </section>
    </main>
  );
}

function Setup({ onComplete }: { onComplete: (location: JournalData["location"]) => void }) {
  const [zip, setZip] = useState("");
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!zip.trim()) return setError("Enter a ZIP code.");
    setBusy(true);
    setError("");
    try {
      onComplete(await geocodeZip(zip.trim()));
    } catch (reason) {
      setError(reason instanceof Error ? reason.message : "The ZIP code could not be loaded.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <main className="setup-shell">
      <form className="setup-card" onSubmit={submit}>
        <span className="eyebrow">TwoBit Territories LLC</span>
        <h1>Vineyard Journal</h1>
        <p>Start with the location of your vineyard.</p>
        <label>
          ZIP code
          <input value={zip} onChange={(event) => setZip(event.target.value)} autoFocus />
        </label>
        {error && <p className="error">{error}</p>}
        <button className="primary" disabled={busy}>{busy ? "Finding vineyard…" : "Continue"}</button>
      </form>
    </main>
  );
}

function Dashboard({
  place,
  entry,
  weather,
  weatherError,
  retry,
}: {
  place: string;
  entry?: JournalEntry;
  weather: WeatherData | null;
  weatherError: string;
  retry: () => void;
}) {
  return (
    <div className="page dashboard">
      <header className="page-header">
        <div>
          <span className="eyebrow">{place}</span>
          <h1>Vineyard Journal</h1>
        </div>
        <time>{new Date(`${today()}T12:00:00`).toLocaleDateString(undefined, { dateStyle: "long" })}</time>
      </header>
      <div className="summary-grid">
        <article className="summary-card weather-card">
          <span className="card-label">Today's weather</span>
          <strong>{formatNumber(weather?.currentTemperature, "°F")}</strong>
          <p>{formatNumber(weather?.currentHumidity, "%")} relative humidity</p>
          {weatherError && <ErrorRetry message={weatherError} retry={retry} />}
        </article>
        <article className="summary-card">
          <span className="card-label">Today's journal</span>
          {entry ? (
            <>
              <div className="reading-row">
                <span>Soil pH <b>{formatNumber(entry.soilPh)}</b></span>
                <span>Sugar <b>{formatNumber(entry.sugar)}</b></span>
              </div>
              <p className="entry-note">{entry.notes || "No observations recorded."}</p>
            </>
          ) : (
            <p className="empty-copy">No entry yet. Open <b>New entry</b> when you have a reading or observation.</p>
          )}
        </article>
      </div>
      <p className="page-hint">Use the folder tabs to add an entry, look up a varietal, or explore your vineyard history.</p>
    </div>
  );
}

function EntryForm({
  entry,
  weather,
  onSave,
}: {
  entry?: JournalEntry;
  weather: WeatherData | null;
  onSave: (entry: JournalEntry) => void;
}) {
  const [values, setValues] = useState({
    temperature: entry?.temperature?.toString() ?? weather?.currentTemperature?.toString() ?? "",
    humidity: entry?.humidity?.toString() ?? weather?.currentHumidity?.toString() ?? "",
    soilPh: entry?.soilPh?.toString() ?? "",
    sugar: entry?.sugar?.toString() ?? "",
    notes: entry?.notes ?? "",
  });
  const field = (name: keyof typeof values) => ({
    value: values[name],
    onChange: (event: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) =>
      setValues((current) => ({ ...current, [name]: event.target.value })),
  });
  const number = (value: string) => value.trim() === "" ? null : Number(value);

  return (
    <form
      className="page entry-form"
      onSubmit={(event) => {
        event.preventDefault();
        onSave({
          date: today(),
          temperature: number(values.temperature),
          humidity: number(values.humidity),
          soilPh: number(values.soilPh),
          sugar: number(values.sugar),
          notes: values.notes,
        });
      }}
    >
      <header className="page-header">
        <div><span className="eyebrow">Daily record</span><h1>New entry</h1></div>
        <time>{today()}</time>
      </header>
      <div className="field-grid">
        <label>Temperature (°F)<input type="number" step="any" {...field("temperature")} /></label>
        <label>Humidity (%)<input type="number" step="any" {...field("humidity")} /></label>
        <label>Soil pH<input type="number" step="any" {...field("soilPh")} /></label>
        <label>Sugar content<input type="number" step="any" {...field("sugar")} /></label>
      </div>
      <label>Notes and observations<textarea rows={7} {...field("notes")} /></label>
      <div className="form-actions"><button className="primary">Save today's entry</button></div>
    </form>
  );
}

function DateRange({
  includeFuture = false,
  onChange,
}: {
  includeFuture?: boolean;
  onChange: (range: RangeValue) => void;
}) {
  const [preset, setPreset] = useState("30");
  const [custom, setCustom] = useState({ start: dateOffset(-29), end: today() });

  const applyCustom = (next: RangeValue) => {
    setCustom(next);
    if (next.start && next.end && next.start <= next.end) onChange(next);
  };

  const choose = (value: string) => {
    setPreset(value);
    if (value === "custom") {
      if (custom.start && custom.end && custom.start <= custom.end) onChange(custom);
      return;
    }
    if (value === "all") return onChange({ start: "", end: "" });
    if (value === "next") return onChange({ start: today(), end: dateOffset(6) });
    onChange({ start: dateOffset(-(Number(value) - 1)), end: today() });
  };

  return (
    <div className="range-picker">
      <label>Date range
        <select value={preset} onChange={(event) => choose(event.target.value)}>
          <option value="7">Past 7 days</option>
          <option value="30">Past 30 days</option>
          <option value="90">Past 90 days</option>
          {includeFuture && <option value="next">Next 7 days</option>}
          <option value="all">{includeFuture ? "All loaded" : "All entries"}</option>
          <option value="custom">Custom range</option>
        </select>
      </label>
      {preset === "custom" && (
        <div className="custom-range">
          <label>Start<input type="date" value={custom.start} max={custom.end} onChange={(event) => applyCustom({ ...custom, start: event.target.value })} /></label>
          <span>to</span>
          <label>End<input type="date" min={custom.start} value={custom.end} onChange={(event) => applyCustom({ ...custom, end: event.target.value })} /></label>
        </div>
      )}
    </div>
  );
}

function Journals({
  entries,
  weatherByDate,
}: {
  entries: Record<string, JournalEntry>;
  weatherByDate: Map<string, WeatherRow>;
}) {
  const [range, setRange] = useState<RangeValue>({ start: dateOffset(-29), end: today() });
  const [selected, setSelected] = useState<string>();
  const filtered = useMemo(
    () => Object.values(entries).filter((entry) => inRange(entry.date, range.start, range.end)).sort((a, b) => a.date.localeCompare(b.date)),
    [entries, range],
  );
  const chartData = filtered.filter((entry) => entry.soilPh != null);
  const detail = selected ? entries[selected] : undefined;

  return (
    <div className="page">
      <header className="page-header"><div><span className="eyebrow">History</span><h1>Past journals</h1></div></header>
      <DateRange onChange={setRange} />
      <section className="chart-card">
        <h2>Soil pH trend</h2>
        <Trend data={chartData} dataKey="soilPh" color="#527343" unit="" />
      </section>
      <div className="journal-layout">
        <div className="entry-list">
          {filtered.length === 0 && <p className="empty-copy">No entries in this range.</p>}
          {[...filtered].reverse().map((entry) => (
            <button key={entry.date} className={selected === entry.date ? "entry-row selected" : "entry-row"} onClick={() => setSelected(entry.date)}>
              <b>{entry.date}</b><span>pH {formatNumber(entry.soilPh)} · Sugar {formatNumber(entry.sugar)}</span>
            </button>
          ))}
        </div>
        <article className="entry-detail">
          {detail ? (
            <>
              <h2>{detail.date}</h2>
              <p>{weatherByDate.has(detail.date) ? `${formatNumber(weatherByDate.get(detail.date)?.temperature, "°F")} · ${formatNumber(weatherByDate.get(detail.date)?.humidity, "%")} humidity` : "Weather is outside the loaded range."}</p>
              <div className="reading-row"><span>Soil pH <b>{formatNumber(detail.soilPh)}</b></span><span>Sugar <b>{formatNumber(detail.sugar)}</b></span></div>
              <p>{detail.notes || "No observations recorded."}</p>
            </>
          ) : <p className="empty-copy">Choose an entry to read it.</p>}
        </article>
      </div>
    </div>
  );
}

function WeatherView({
  weather,
  error,
  loading,
  onHistoryStart,
}: {
  weather: WeatherData | null;
  error: string;
  loading: boolean;
  onHistoryStart: (start: string) => void;
}) {
  const [range, setRange] = useState<RangeValue>({ start: dateOffset(-29), end: today() });
  const rows = useMemo(
    () => (weather?.rows ?? []).filter((row) => inRange(row.date, range.start, range.end) && (row.temperature != null || row.humidity != null)),
    [weather, range],
  );
  const earliest = weather?.rows.find((row) => row.temperature != null)?.date ?? "";
  const waiting = Boolean(loading && range.start && earliest && range.start < earliest);
  const applyRange = (next: RangeValue) => {
    setRange(next);
    if (next.start) onHistoryStart(next.start);
  };
  return (
    <div className="page">
      <header className="page-header"><div><span className="eyebrow">Open-Meteo</span><h1>Weather</h1></div><strong>{formatNumber(weather?.currentTemperature, "°F")}</strong></header>
      <DateRange includeFuture onChange={applyRange} />
      {error && <p className="error">{error}</p>}
      {waiting && <p className="empty-copy">Loading weather for this range…</p>}
      {!loading && weather && rows.length === 0 && <p className="empty-copy">No weather in this range.</p>}
      {rows.length >= 2 && (
        <>
          <div className="weather-charts">
            <section className="chart-card"><h2>Temperature</h2><Trend data={rows} dataKey="temperature" color="#b65c32" unit="°F" area /></section>
            <section className="chart-card"><h2>Humidity</h2><Trend data={rows} dataKey="humidity" color="#3f7182" unit="%" area /></section>
          </div>
          <div className="weather-table">
            {rows.map((row) => <div key={row.date}><b>{row.date}</b><span>{formatNumber(row.temperature, "°F")}</span><span>{formatNumber(row.humidity, "%")}</span></div>)}
          </div>
        </>
      )}
      <p className="credit">Weather data by Open-Meteo.com, CC BY 4.0.</p>
    </div>
  );
}

function Trend({
  data,
  dataKey,
  color,
  unit,
  area = false,
}: {
  data: object[];
  dataKey: string;
  color: string;
  unit: string;
  area?: boolean;
}) {
  if (data.length < 2) return <div className="empty-chart">Add or select at least two readings to show a trend.</div>;
  const Chart = area ? AreaChart : LineChart;
  return (
    <div className="chart">
      <ResponsiveContainer width="100%" height="100%">
        <Chart data={data} margin={{ top: 12, right: 20, bottom: 4, left: 0 }}>
          <CartesianGrid stroke="#c8ae7d" strokeDasharray="3 5" opacity={0.55} />
          <XAxis dataKey="date" tick={{ fill: "#765737", fontSize: 12 }} minTickGap={32} />
          <YAxis tick={{ fill: "#765737", fontSize: 12 }} width={48} unit={unit} domain={["auto", "auto"]} />
          <Tooltip contentStyle={{ background: "#fffaf0", border: "1px solid #b8945c", borderRadius: 8 }} />
          {area ? (
            <Area type="monotone" dataKey={dataKey} stroke={color} fill={color} fillOpacity={0.18} strokeWidth={3} dot={{ r: 2 }} connectNulls />
          ) : (
            <Line type="monotone" dataKey={dataKey} stroke={color} strokeWidth={3} dot={{ r: 3 }} connectNulls />
          )}
        </Chart>
      </ResponsiveContainer>
    </div>
  );
}

function CalendarView({
  entries,
  weatherByDate,
}: {
  entries: Record<string, JournalEntry>;
  weatherByDate: Map<string, WeatherRow>;
}) {
  const [month, setMonth] = useState(today().slice(0, 7));
  const [selected, setSelected] = useState(today());
  const [year, monthNumber] = month.split("-").map(Number);
  const firstWeekday = new Date(year, monthNumber - 1, 1).getDay();
  const days = new Date(year, monthNumber, 0).getDate();
  const selectedEntry = entries[selected];
  const selectedWeather = weatherByDate.get(selected);
  const shift = (amount: number) => {
    const date = new Date(year, monthNumber - 1 + amount, 1);
    setMonth(`${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`);
  };
  return (
    <div className="page">
      <header className="page-header"><div><span className="eyebrow">Browse by day</span><h1>Calendar</h1></div></header>
      <div className="calendar-layout">
        <section>
          <div className="calendar-nav"><button onClick={() => shift(-1)}>←</button><h2>{new Date(year, monthNumber - 1).toLocaleDateString(undefined, { month: "long", year: "numeric" })}</h2><button onClick={() => shift(1)}>→</button></div>
          <div className="calendar-grid">
            {["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].map((day) => <span className="weekday" key={day}>{day}</span>)}
            {Array.from({ length: firstWeekday }).map((_, index) => <span key={`blank-${index}`} />)}
            {Array.from({ length: days }, (_, index) => {
              const date = `${month}-${String(index + 1).padStart(2, "0")}`;
              return <button key={date} className={`${selected === date ? "selected " : ""}${entries[date] ? "has-entry" : ""}`} onClick={() => setSelected(date)}>{index + 1}</button>;
            })}
          </div>
        </section>
        <article className="entry-detail">
          <h2>{selected}</h2>
          <p>{selectedWeather ? `${formatNumber(selectedWeather.temperature, "°F")} · ${formatNumber(selectedWeather.humidity, "%")} humidity` : "Weather is outside the loaded range."}</p>
          {selectedEntry ? <><div className="reading-row"><span>Soil pH <b>{formatNumber(selectedEntry.soilPh)}</b></span><span>Sugar <b>{formatNumber(selectedEntry.sugar)}</b></span></div><p>{selectedEntry.notes || "No observations recorded."}</p></> : <p className="empty-copy">No journal entry for this day.</p>}
        </article>
      </div>
    </div>
  );
}

function fitLabel(name: string, zoneLabel: string, zoneNumber: number): string {
  const fit: ZoneFit = zoneFit(name, zoneNumber);
  if (fit === "marginal") return `Marginal · ${zoneLabel}`;
  if (fit === "cold") return `Too tender · ${zoneLabel}`;
  if (fit === "warm") return `Prefers cooler · ${zoneLabel}`;
  return `Suited · ${zoneLabel}`;
}

function VarietalGuide({ zip, place }: { zip: string; place: string }) {
  const catalog = useMemo(() => allVarietals(), []);
  const [query, setQuery] = useState("");
  const [open, setOpen] = useState(false);
  const [highlight, setHighlight] = useState(0);
  const [selected, setSelected] = useState<Varietal | null>(null);
  const [miss, setMiss] = useState(false);
  const [limitToRegion, setLimitToRegion] = useState(true);
  const [zone, setZone] = useState<{ label: string; number: number } | null>(null);
  const [zoneStatus, setZoneStatus] = useState<"loading" | "ready" | "missing">("loading");
  const rootRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const chevronFocus = useRef(false);
  const filtering = query.trim().length > 0 && query !== selected?.name;
  const options = useMemo(() => {
    const matches = filtering ? filterVarietals(query) : catalog;
    if (!limitToRegion || !zone) return matches;
    return matches.filter((varietal) => inRegion(varietal.name, zone.number));
  }, [filtering, query, catalog, limitToRegion, zone]);

  useEffect(() => {
    let current = true;
    fetch(`https://phzmapi.org/${encodeURIComponent(zip)}.json`)
      .then((response) => (response.ok ? response.json() : Promise.reject(new Error("zone"))))
      .then((body: { zone?: string }) => {
        const label = body.zone ?? "";
        const number = Number.parseInt(label, 10);
        if (!current) return;
        if (label && Number.isFinite(number)) {
          setZone({ label, number });
          setZoneStatus("ready");
        } else setZoneStatus("missing");
      })
      .catch(() => current && setZoneStatus("missing"));
    return () => {
      current = false;
    };
  }, [zip]);

  const choose = (varietal: Varietal) => {
    setSelected(varietal);
    setQuery(varietal.name);
    setMiss(false);
    setOpen(false);
  };

  useEffect(() => {
    const close = (event: PointerEvent) => {
      if (!rootRef.current?.contains(event.target as Node)) setOpen(false);
    };
    document.addEventListener("pointerdown", close);
    return () => document.removeEventListener("pointerdown", close);
  }, []);

  useEffect(() => {
    const selectedIndex = options.findIndex((varietal) => varietal.name === selected?.name);
    setHighlight(!filtering && selectedIndex >= 0 ? selectedIndex : 0);
  }, [query, open, filtering, options, selected?.name]);

  useEffect(() => {
    if (!open) return;
    document.getElementById(`varietal-option-${highlight}`)?.scrollIntoView({ block: "nearest" });
  }, [highlight, open]);

  return (
    <div className="page">
      <header className="page-header">
        <div>
          <span className="eyebrow">{zone ? `${place} · Zone ${zone.label}` : place}</span>
          <h1>Varietal</h1>
        </div>
      </header>
      <div className="varietal-tools">
        <label>
          Show
          <select
            value={limitToRegion && zone ? "region" : "all"}
            onChange={(event) => setLimitToRegion(event.target.value === "region")}
          >
            <option value="region" disabled={!zone}>
              {zone ? `Suited to ${place} · zone ${zone.label}` : "Suited to this ZIP"}
            </option>
            <option value="all">All varietals</option>
          </select>
        </label>
      <div className="varietal-combo" ref={rootRef}>
        <label htmlFor="varietal-input">Varietal</label>
        <div className="varietal-combo-field">
          <input
            id="varietal-input"
            ref={inputRef}
            role="combobox"
            aria-expanded={open}
            aria-controls="varietal-list"
            aria-autocomplete="list"
            value={query}
            placeholder="Choose or type a varietal"
            onChange={(event) => {
              setQuery(event.target.value);
              setSelected(null);
              setMiss(false);
              setOpen(true);
            }}
            onFocus={() => {
              if (chevronFocus.current) {
                chevronFocus.current = false;
                return;
              }
              setOpen(true);
              inputRef.current?.select();
            }}
            onKeyDown={(event) => {
              if (event.key === "ArrowDown" || event.key === "ArrowUp") {
                event.preventDefault();
                if (options.length === 0) return;
                setOpen(true);
                setHighlight((current) => {
                  if (event.key === "ArrowDown") return Math.min(current + 1, options.length - 1);
                  return Math.max(current - 1, 0);
                });
              } else if (event.key === "Escape") {
                setOpen(false);
              } else if (event.key === "Enter") {
                event.preventDefault();
                if (options.length === 0) {
                  setSelected(null);
                  setMiss(true);
                  setOpen(false);
                } else if (open || filtering) {
                  choose(options[Math.min(highlight, options.length - 1)]);
                } else {
                  setOpen(true);
                }
              }
            }}
          />
          <button
            type="button"
            aria-label="Show varietals"
            onMouseDown={(event) => event.preventDefault()}
            onClick={() => {
              if (document.activeElement !== inputRef.current) chevronFocus.current = true;
              inputRef.current?.focus();
              setOpen((current) => !current);
            }}
          >
            <ChevronDown size={18} />
          </button>
        </div>
        {open && (
          <div id="varietal-list" role="listbox" className="varietal-menu">
            {options.length === 0 && <p className="empty-copy">{limitToRegion && zone ? "Nothing in this region matches. Choose All varietals to search the full list." : "No matching varietal."}</p>}
            {options.map((varietal, index) => (
              <button
                key={varietal.name}
                id={`varietal-option-${index}`}
                type="button"
                role="option"
                aria-selected={selected?.name === varietal.name}
                className={index === highlight ? "active" : ""}
                onMouseEnter={() => setHighlight(index)}
                onClick={() => choose(varietal)}
              >
                {varietal.name}
                <span>{zone ? fitLabel(varietal.name, zone.label, zone.number) : varietal.color}</span>
              </button>
            ))}
          </div>
        )}
      </div>
      </div>
      {zoneStatus === "missing" && <p className="empty-copy">This ZIP has no hardiness zone on file, so the list shows every varietal.</p>}
      {miss && <p className="empty-copy">No guide for “{query}”. Choose a name from the list.</p>}
      {selected && (
        <>
          <article className="summary-card varietal-hero">
            <span className="eyebrow">{selected.species}</span>
            <h2>{selected.name}</h2>
            <p>{selected.summary}</p>
            <div className="reading-row">
              <span>Color <b>{selected.color}</b></span>
              <span>Region <b>{zone ? fitLabel(selected.name, zone.label, zone.number) : selected.hardiness}</b></span>
            </div>
          </article>
          <div className="guide-grid">
            <section className="chart-card"><h2>Planting</h2><p>{selected.planting}</p></section>
            <section className="chart-card"><h2>Maintenance</h2><p>{selected.maintenance}</p></section>
            <section className="chart-card"><h2>Harvesting</h2><p>{selected.harvesting}</p></section>
          </div>
          {zone && (zone.number < 5 || zone.number > 6) && (
            <p className="credit">These notes describe a humid cold-winter season. In zone {zone.label}, shift the dates and check a local extension guide.</p>
          )}
        </>
      )}
      <section className="chart-card spray-card">
        <h2>Suggested spray schedule</h2>
        {selected && <p><b>{selected.name}.</b> {sprayFocusFor(selected.name)}</p>}
        <ol className="spray-list">
          {spraySchedule.map((step) => (
            <li key={step.when}>
              <b>{step.when}</b>
              <p>{step.detail}</p>
            </li>
          ))}
        </ol>
        <p className="credit">A timing outline for a humid summer. It is not a product, a rate, or a substitute for the label or your state extension guide.</p>
      </section>
    </div>
  );
}

function ErrorRetry({ message, retry }: { message: string; retry: () => void }) {
  return <div className="error-retry"><p className="error">{message}</p><button onClick={retry}>Retry</button></div>;
}
