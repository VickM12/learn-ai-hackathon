export type Location = {
  zip: string;
  name: string;
  latitude: number;
  longitude: number;
};

export type JournalEntry = {
  date: string;
  temperature: number | null;
  humidity: number | null;
  soilPh: number | null;
  sugar: number | null;
  notes: string;
};

export type WeatherRow = {
  date: string;
  temperature: number | null;
  humidity: number | null;
};

export type WeatherData = {
  currentTemperature: number | null;
  currentHumidity: number | null;
  rows: WeatherRow[];
};

export type JournalData = {
  location: Location | null;
  entries: Record<string, JournalEntry>;
};

const STORAGE_KEY = "vineyard-journal";

export function today(): string {
  return localDateKey(new Date());
}

export function dateOffset(days: number): string {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return localDateKey(date);
}

function localDateKey(date: Date): string {
  return [
    date.getFullYear(),
    String(date.getMonth() + 1).padStart(2, "0"),
    String(date.getDate()).padStart(2, "0"),
  ].join("-");
}

export function loadJournal(): JournalData {
  try {
    const parsed = JSON.parse(localStorage.getItem(STORAGE_KEY) ?? "");
    if (parsed && typeof parsed === "object") {
      return {
        location: parsed.location ?? null,
        entries: parsed.entries ?? {},
      };
    }
  } catch {
    // A malformed local file starts clean instead of breaking the app.
  }
  return { location: null, entries: {} };
}

export function saveJournal(data: JournalData): void {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
}

export async function geocodeZip(zip: string): Promise<Location> {
  const response = await fetch(
    `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(zip)}&count=10`,
  );
  if (!response.ok) throw new Error("The location service did not respond.");
  const body = await response.json();
  const match = body.results?.find(
    (item: { country_code?: string; postcodes?: string[] }) =>
      item.country_code === "US" && item.postcodes?.includes(zip),
  );
  if (!match) throw new Error("That ZIP code could not be matched to a US place.");
  return {
    zip,
    name: match.name,
    latitude: match.latitude,
    longitude: match.longitude,
  };
}

export async function fetchWeather(location: Location): Promise<WeatherData> {
  const params = new URLSearchParams({
    latitude: String(location.latitude),
    longitude: String(location.longitude),
    current: "temperature_2m,relative_humidity_2m",
    hourly: "relative_humidity_2m",
    daily: "temperature_2m_mean",
    temperature_unit: "fahrenheit",
    timezone: "auto",
    past_days: "90",
    forecast_days: "7",
  });
  const response = await fetch(`https://api.open-meteo.com/v1/forecast?${params}`);
  if (!response.ok) throw new Error("Weather could not be loaded.");
  const body = await response.json();

  const humidity = new Map<string, { total: number; count: number }>();
  body.hourly?.time?.forEach((time: string, index: number) => {
    const value = body.hourly.relative_humidity_2m[index];
    if (value == null) return;
    const date = time.slice(0, 10);
    const current = humidity.get(date) ?? { total: 0, count: 0 };
    humidity.set(date, { total: current.total + value, count: current.count + 1 });
  });

  const rows: WeatherRow[] = (body.daily?.time ?? []).map((date: string, index: number) => {
    const humidityDay = humidity.get(date);
    return {
      date,
      temperature: body.daily.temperature_2m_mean[index] ?? null,
      humidity: humidityDay ? humidityDay.total / humidityDay.count : null,
    };
  });

  return {
    currentTemperature: body.current?.temperature_2m ?? null,
    currentHumidity: body.current?.relative_humidity_2m ?? null,
    rows,
  };
}

export function inRange(date: string, start: string, end: string): boolean {
  return (!start || date >= start) && (!end || date <= end);
}

export function formatNumber(value: number | null | undefined, suffix = ""): string {
  return value == null ? "—" : `${value.toFixed(1)}${suffix}`;
}
