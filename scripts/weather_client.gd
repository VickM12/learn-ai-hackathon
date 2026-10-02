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
