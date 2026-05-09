extends Control


func _ready() -> void:
	$FinalScoreLabel.text = "Final Score: " + str(GameManager.score)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("launch"):
		GameManager.reset_game()
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
