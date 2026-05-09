extends Node

var score := 0
var level := 1
var lives := 3
var max_levels := 5

func add_points(points):
	score += points

func lose_life():
	lives -= 1
	return lives >= 0

func reset_game():
	score = 0
	level = 1
	lives = 3

func _process(_delta: float) -> void:
	$CanvasLayer/ScoreLabel.text = str(score)
	$CanvasLayer/LevelLabel.text = "Level: " + str(level)
	$CanvasLayer/LivesLabel.text = "Lives: " + str(lives)
