extends SceneTree

const WeatherClient = preload("res://scripts/weather_client.gd")
const TrendChart = preload("res://scripts/trend_chart.gd")


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
	print("ROWS ", rows.size())
	print("CHART ", chart.point_count())
	chart.free()
	client.free()
	quit(0)
