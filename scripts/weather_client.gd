extends Node

# Godot 4.7.2's built-in TLS client rejected this host (mbedtls -0x2700).
# curl uses the Windows certificate store, which can complete the same GET.

var last_forecast: Dictionary = {}


func geocode_zip(zip_code: String) -> Dictionary:
	var trimmed := zip_code.strip_edges()
	var url := "https://geocoding-api.open-meteo.com/v1/search?name=%s&count=10" % trimmed.uri_encode()
	var body := await _get_json(url)
	var results = body.get("results", [])
	if typeof(results) != TYPE_ARRAY:
		return {}
	for item in results:
		if typeof(item) != TYPE_DICTIONARY:
			continue
		if str(item.get("country_code", "")) != "US":
			continue
		var postcodes = item.get("postcodes", [])
		if typeof(postcodes) != TYPE_ARRAY:
			continue
		for code in postcodes:
			if str(code) == trimmed:
				return item
	return {}


func fetch_forecast(latitude: float, longitude: float) -> Dictionary:
	var url := (
		"https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s"
		+ "&current=temperature_2m,relative_humidity_2m"
		+ "&hourly=relative_humidity_2m&daily=temperature_2m_mean"
		+ "&temperature_unit=fahrenheit&timezone=auto&past_days=30&forecast_days=7"
	) % [_num(latitude), _num(longitude)]
	last_forecast = await _get_json(url)
	return last_forecast


func _num(value: float) -> String:
	return String.num(value, 6)


func _get_json(url: String) -> Dictionary:
	var output: Array = []
	var code := OS.execute(
		"C:/Windows/System32/curl.exe",
		["-sS", "-L", "--fail", "-A", "VineyardJournal/0.1", url],
		output,
		true,
		false
	)
	if code != 0 or output.is_empty():
		push_error("Weather request failed (%s) %s" % [code, output])
		return {}
	var parsed = JSON.parse_string("\n".join(output))
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Weather response was not an object")
		return {}
	return parsed


func daily_rows(forecast: Dictionary) -> Array:
	var daily = forecast.get("daily", {})
	var times = daily.get("time", [])
	var temps = daily.get("temperature_2m_mean", [])
	if typeof(times) != TYPE_ARRAY or typeof(temps) != TYPE_ARRAY:
		return []
	var humidity_by_day := _humidity_by_day(forecast)
	var rows: Array = []
	for i in times.size():
		var day := str(times[i]).substr(0, 10)
		rows.append({
			"date": day,
			"temperature": temps[i] if i < temps.size() else null,
			"humidity": humidity_by_day.get(day, null),
		})
	return rows


func _humidity_by_day(forecast: Dictionary) -> Dictionary:
	var hourly = forecast.get("hourly", {})
	var times = hourly.get("time", [])
	var values = hourly.get("relative_humidity_2m", [])
	if typeof(times) != TYPE_ARRAY or typeof(values) != TYPE_ARRAY:
		return {}
	var sums := {}
	var counts := {}
	for i in mini(times.size(), values.size()):
		if values[i] == null:
			continue
		var day := str(times[i]).substr(0, 10)
		sums[day] = float(sums.get(day, 0.0)) + float(values[i])
		counts[day] = int(counts.get(day, 0)) + 1
	var averages := {}
	for day in sums.keys():
		averages[day] = float(sums[day]) / float(counts[day])
	return averages
