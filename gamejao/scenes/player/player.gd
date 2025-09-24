extends CharacterBody2D

var gravity = 30
var input_locked := false
var stopped_on_door := false
@export var jump_force = 300

@export var controls: Resource=null

func _physics_process(_delta: float):
	if (stopped_on_door):
		input_locked = true
	if !is_on_floor():
		if is_on_wall():
			velocity.y += gravity * 0.5
		else:
			velocity.y += gravity
		if velocity.y >= 500:
			velocity.y = 600
		if Input.is_action_pressed(controls.move_down) && !input_locked:
			velocity.y += 300
		
	if !input_locked && Input.is_action_just_pressed(controls.move_up) && (is_on_floor() || is_on_wall()):
		velocity.y = -jump_force
		
	
	var horizontaDirection = Input.get_axis(controls.move_left, controls.move_right)
	if (!input_locked):
		velocity.x = 300 * horizontaDirection
	else:
		velocity.x = 0
		
	move_and_slide()
	
func stop_on_door() -> void:
	stopped_on_door = true
	if controls.player_index == 0:
		if $"../../../../PuzzleModal".has_method("createArrowList"):
			$"../../../../PuzzleModal".createArrowList(["u","d","l","r","r"])
		#if $"../PuzzleModal".has_method("createArrowList"):
			#$"../PuzzleModal".createArrowList(["u","d","l","r","r"])
	else:
		if $"../../../../PuzzleModal".has_method("createArrowList"):
			$"../../../../PuzzleModal".createArrowList(["u","d","l","r","r"])
		#if $"../../../ViewPortContainerPlayer1/ViewportPlayer1/PuzzleModal".has_method("createArrowList"):
			#$"../../../ViewPortContainerPlayer1/ViewportPlayer1/PuzzleModal".createArrowList(["u","d","l","r","r"])
