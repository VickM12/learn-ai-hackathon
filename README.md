# Vineyard Journal

A local Tauri desktop app for a six-vine vineyard. It pairs ZIP-code weather with soil pH, sugar readings, and field notes stored only on this machine.

## Run it

Requirements: Node.js, Rust, and the Windows WebView2 runtime.

```powershell
npm install
npm run tauri dev
```

Build the local executable:

```powershell
npm run tauri build
```

The executable is generated under `src-tauri/target/release/`. TwoBit Territories LLC is recorded as the publisher metadata. Code signing remains off until a certificate exists.

The executable produced and smoke-tested in this Cursor workspace is at `build/tauri-target/release/vineyard-journal.exe`.

## Product

- Weather snapshot dashboard
- Daily readings and free-form observations
- Past journals and soil-pH trends
- 90 days of historical weather and a 7-day forecast
- Preset and native calendar date ranges
- Calendar view pairing weather with saved entries

The earlier Godot proof remains in the repository as build history; the Tauri app is the current implementation.
