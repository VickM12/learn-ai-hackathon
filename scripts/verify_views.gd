extends SceneTree

const WeatherClient = preload("res://scripts/weather_client.gd")
const TrendChart = preload("res://scripts/trend_chart.gd")
const DateRangePicker = preload("res://scripts/date_range_picker.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var client := WeatherClient.new()
	var forecast := {
		"daily": {
			"time": ["2026-10-01", "2026-10-02", "2026-10-03"],
			"temperature_2m_mean": [55.0, 60.0, 62.0],
		},
		"hourly": {
			"time": ["2026-10-01T00:00", "2026-10-01T01:00", "2026-10-02T00:00", "2026-10-02T01:00"],
			"relative_humidity_2m": [40.0, 60.0, 70.0, 90.0],
		},
	}
	var rows: Array = client.daily_rows(forecast)
	if rows.size() != 3:
		push_error("expected 3 weather rows")
		quit(1)
		return
	if not is_equal_approx(float(rows[0]["humidity"]), 50.0):
		push_error("humidity average mismatch")
		quit(1)
		return
	var chart: Control = TrendChart.new()
	chart.set_series([6.2, 6.4, 6.8])
	if chart.point_count() != 3:
		push_error("soil series missing")
		quit(1)
		return

	var weather_view: Control = load("res://scenes/weather.tscn").instantiate()
	root.add_child(weather_view)
	await process_frame
	weather_view.show_weather("2026-10-02", 60.0, 80.0, rows)
	weather_view._render_range("2026-10-02", "2026-10-03")
	if weather_view.temp_chart.point_count() != 2:
		push_error("weather range did not update chart")
		quit(1)
		return

	var journal_view: Control = load("res://scenes/journal.tscn").instantiate()
	root.add_child(journal_view)
	await process_frame
	journal_view.show_entries({
		"2026-09-01": {"soil_ph": 6.1},
		"2026-10-02": {"soil_ph": 6.4},
		"2026-10-03": {"soil_ph": 6.6},
	}, {})
	journal_view._render_range("2026-10-02", "2026-10-03")
	if journal_view.chart.point_count() != 2:
		push_error("journal range did not update chart")
		quit(1)
		return

	var picker: VBoxContainer = DateRangePicker.new()
	root.add_child(picker)
	await process_frame
	picker._on_preset_selected(picker.preset.item_count - 1)
	if not picker.calendar_panel.visible:
		push_error("custom calendar did not open")
		quit(1)
		return
	picker._pick_date("2026-09-01")
	picker._pick_date("2026-10-01")
	picker._apply_custom()
	if picker.start_date != "2026-09-01" or picker.end_date != "2026-10-01":
		push_error("calendar did not retain the selected range")
		quit(1)
		return
	print("ROWS ", rows.size())
	print("CHART ", chart.point_count())
	print("RANGE_CHARTS 2 2")
	print("CALENDAR_RANGE ", picker.start_date, " ", picker.end_date)
	picker.free()
	weather_view.free()
	journal_view.free()
	chart.free()
	client.free()
	quit(0)
