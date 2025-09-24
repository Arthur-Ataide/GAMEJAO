extends CharacterBody2D

var gravity = 30
@export var jump_force = 300

func _physics_process(_delta: float):
	if !is_on_floor():
		if is_on_wall():
			velocity.y += gravity * 0.5
		else:
			velocity.y += gravity
		if velocity.y >= 500:
			velocity.y = 600
		if Input.is_action_pressed("player2_down"):
			velocity.y += 300
		
	if Input.is_action_just_pressed("player2_up") && (is_on_floor() || is_on_wall()):
		velocity.y = -jump_force
		
	
	var horizontaDirection = Input.get_axis("player2_left", "player2_right")
	velocity.x = 300 * horizontaDirection

	move_and_slide()
