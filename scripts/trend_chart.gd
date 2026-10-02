extends Control

var points: Array = []
var line_color := Color("9a4f2f")
var fill_color := Color(0.60, 0.31, 0.18, 0.16)


func set_series(values: Array, color := Color("9a4f2f")) -> void:
	points = values.duplicate()
	line_color = color
	fill_color = Color(color.r, color.g, color.b, 0.16)
	custom_minimum_size = Vector2(0, 190)
	queue_redraw()


func point_count() -> int:
	return points.size()


func _draw() -> void:
	var background := Rect2(Vector2.ZERO, size)
	draw_rect(background, Color("fbf6ea"))
	draw_rect(background, Color("c3a675"), false, 1.0)

	var left := 38.0
	var right := size.x - 14.0
	var top := 18.0
	var bottom := size.y - 26.0
	for step in range(4):
		var y := lerpf(top, bottom, float(step) / 3.0)
		draw_line(Vector2(left, y), Vector2(right, y), Color(0.55, 0.42, 0.27, 0.20), 1.0)

	if points.size() < 2 or size.x < 2.0 or size.y < 2.0:
		return
	var low: float = float(points[0])
	var high: float = float(points[0])
	for value in points:
		low = minf(low, float(value))
		high = maxf(high, float(value))
	if is_equal_approx(low, high):
		high += 1.0

	var plotted := PackedVector2Array()
	for index in points.size():
		var x := lerpf(left, right, float(index) / float(points.size() - 1))
		var y := lerpf(bottom, top, (float(points[index]) - low) / (high - low))
		plotted.append(Vector2(x, y))

	var area := PackedVector2Array()
	area.append(Vector2(left, bottom))
	for point in plotted:
		area.append(point)
	area.append(Vector2(right, bottom))
	draw_colored_polygon(area, fill_color)
	draw_polyline(plotted, line_color, 3.0, true)

	for index in plotted.size():
		if index == 0 or index == plotted.size() - 1 or index % maxi(1, plotted.size() / 8) == 0:
			draw_circle(plotted[index], 3.5, Color("fbf6ea"))
			draw_circle(plotted[index], 3.5, line_color, false, 2.0, true)

	var font := get_theme_default_font()
	draw_string(font, Vector2(7, top + 5), String.num(high, 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("765737"))
	draw_string(font, Vector2(7, bottom + 5), String.num(low, 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("765737"))
