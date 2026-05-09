extends Node2D

@onready var brick_object = preload("res://scenes/brick.tscn")

var columns = 25 # brick is 73 pixels wide and tall
var margin = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_level()
	show_level_banner()


func show_level_banner():
	var banner = $LevelBanner
	banner.visible = true
	banner.text = "Level " + str(GameManager.level)
	await get_tree().create_timer(2.0).timeout
	banner.visible = false


func setup_level():
	var level = GameManager.level
	var layout = get_level_layout(level)
	var colors = get_level_colors(level)
	
	for r in layout.size():
		for c in layout[r].size():
			if layout[r][c] == 1:
				var new_brick = brick_object.instantiate()
				add_child(new_brick)
				new_brick.position = Vector2(margin + (75 * c), margin + (75 * r))
				
				var sprite = new_brick.get_node('Sprite2D')
				var color_index = (r + c) % colors.size()
				sprite.modulate = colors[color_index]


func get_level_layout(level: int) -> Array:
	match level:
		1:
			return _level_1()
		2:
			return _level_2()
		3:
			return _level_3()
		4:
			return _level_4()
		5:
			return _level_5()
		_:
			return _level_1()


# Level 1: Simple 3 rows, alternating bricks
func _level_1() -> Array:
	var layout = []
	for r in 3:
		var row = []
		for c in columns:
			if c % 2 == r % 2:
				row.append(1)
			else:
				row.append(0)
		layout.append(row)
	return layout


# Level 2: Pyramid shape
func _level_2() -> Array:
	var layout = []
	for r in 5:
		var row = []
		var start = r * 2
		var end_col = columns - r * 2
		for c in columns:
			if c >= start and c < end_col:
				row.append(1)
			else:
				row.append(0)
		layout.append(row)
	return layout


# Level 3: Diamond pattern
func _level_3() -> Array:
	var layout = []
	var center = columns / 2
	for r in 7:
		var row = []
		var half_width: int
		if r <= 3:
			half_width = r * 3 + 1
		else:
			half_width = (6 - r) * 3 + 1
		for c in columns:
			if abs(c - center) < half_width:
				row.append(1)
			else:
				row.append(0)
		layout.append(row)
	return layout


# Level 4: Checkerboard with border
func _level_4() -> Array:
	var layout = []
	for r in 6:
		var row = []
		for c in columns:
			if r == 0 or r == 5 or c == 0 or c == columns - 1:
				row.append(1)
			elif (r + c) % 2 == 0:
				row.append(1)
			else:
				row.append(0)
		layout.append(row)
	return layout


# Level 5: Full dense grid
func _level_5() -> Array:
	var layout = []
	for r in 7:
		var row = []
		for c in columns:
			row.append(1)
		layout.append(row)
	return layout


func get_level_colors(level: int) -> Array:
	match level:
		1:
			return [
				Color(0, 1, 1, 1),       # Cyan
				Color(0.68, 1, 0.18, 1),  # Green
			]
		2:
			return [
				Color(1, 0.93, 0.15, 1),  # Yellow
				Color(1, 0.5, 0, 1),      # Orange
				Color(1, 0.2, 0.2, 1),    # Red
			]
		3:
			return [
				Color(0.5, 0.2, 1, 1),    # Purple
				Color(0.2, 0.6, 1, 1),    # Blue
				Color(0, 1, 1, 1),        # Cyan
			]
		4:
			return [
				Color(1, 0.2, 0.6, 1),    # Pink
				Color(1, 1, 1, 1),        # White
				Color(1, 0.93, 0.15, 1),  # Yellow
				Color(0.2, 1, 0.4, 1),    # Green
			]
		5:
			return [
				Color(1, 0, 0, 1),        # Red
				Color(1, 0.5, 0, 1),      # Orange
				Color(1, 1, 0, 1),        # Yellow
				Color(0, 1, 0, 1),        # Green
				Color(0, 0.5, 1, 1),      # Blue
				Color(0.5, 0, 1, 1),      # Purple
				Color(1, 0, 0.5, 1),      # Magenta
			]
		_:
			return [Color(1, 1, 1, 1)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
