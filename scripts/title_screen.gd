extends Control


func _ready() -> void:
	GameManager.reset_game()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
