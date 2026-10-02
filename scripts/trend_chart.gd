extends Control

var points: Array = []


func set_series(values: Array) -> void:
	points = values.duplicate()
	custom_minimum_size = Vector2(0, 160)
	queue_redraw()


func point_count() -> int:
	return points.size()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("fbf6ea"))
	if points.size() < 2 or size.x < 2.0 or size.y < 2.0:
		return
	var low: float = float(points[0])
	var high: float = float(points[0])
	for value in points:
		low = minf(low, float(value))
		high = maxf(high, float(value))
	if is_equal_approx(low, high):
		high += 1.0
	var previous := Vector2.ZERO
	for index in points.size():
		var x := size.x * float(index) / float(points.size() - 1)
		var y := size.y - ((float(points[index]) - low) / (high - low)) * (size.y - 12.0) - 6.0
		var point := Vector2(x, y)
		if index > 0:
			draw_line(previous, point, Color("3b2416"), 2.0)
		previous = point
