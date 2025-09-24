extends CharacterBody2D

var gravity = 30
var jump_force = 1000
var perto_da_porta = false

func _physics_process(delta: float):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 500:
			velocity.y = 600
		if Input.is_action_pressed("down_player_2"):
			velocity.y += 300
		
	if Input.is_action_just_pressed("jump_player_2") && is_on_floor():
		velocity.y = -jump_force
		
	
	var horizontaDirection = Input.get_axis("left_player_2", "right_player_2")
	velocity.x = 300 * horizontaDirection

	move_and_slide()

func _on_porta_area_body_entered(body):
	if body == self:
		perto_da_porta = true
		print("Jogador2 está perto da porta!")

func _on_porta_area_body_exited(body):
	if body == self:
		perto_da_porta = false
		print("Jogador2 se afastou da porta.")
