extends CharacterBody2D

var speed := 300.0
var is_active := false
var paddle_width := 199.0  # width of texture scaled down by 0.5 since the Sprite is scaled by 0.5
var speed_up_zone_width := 30.0
var speed_up_zone_check := 0.0

func _ready() -> void:
	speed = speed + (20 * GameManager.level)
	$CPUParticles2D.visible = false;
	velocity = Vector2(speed, speed)
	speed_up_zone_check = (paddle_width - (2.0 * speed_up_zone_width)) / 2.0
	
func _process(_delta: float) -> void:
	if !is_active:
		if Input.is_action_just_pressed("launch"):
			is_active = true;
			$CPUParticles2D.visible = true;
			
	
func _physics_process(delta: float) -> void:
	if is_active:
		var collision = move_and_collide(velocity * delta)
	
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			if collision.get_collider().has_method("hit"):
				collision.get_collider().hit()
			if collision.get_collider() == get_node("../paddleStatic"):
				var paddle = get_node("../paddleStatic")
				var collision_point = collision.get_position()
				var paddle_position = paddle.position
				if abs(collision_point.x - paddle_position.x) >= speed_up_zone_check:
					var new_speed = clamp(velocity.length() + (0.5 * velocity.length()), 420.0, 1000.0)
					velocity = velocity.normalized() * new_speed
				else:
					var new_speed = clamp(velocity.length() - (0.3 * velocity.length()), 420.0, 1000.0)
					velocity = velocity.normalized() * new_speed
		
		# If we're not moving much in the y direction, spike it up in the air a bit
		if (velocity.y > 0 and velocity.y < 100):
			velocity.y = -200
		
		# if we're stuck moving up and down, bump it to the side a bit
		if abs(velocity.x) < 100:
			velocity.x = -200
	else:
		position.x = get_node("../paddleStatic").position.x
	

func lose_life():
	if GameManager.lose_life():
		# Still have lives, reset ball position
		is_active = false
		$CPUParticles2D.visible = false
		position = Vector2(get_node("../paddleStatic").position.x, 906)
		velocity = Vector2(speed, speed)
	else:
		# No lives left - game over
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_death_zone_body_entered(_body: Node2D) -> void:
	call_deferred("lose_life")
