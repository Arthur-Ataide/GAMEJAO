extends CharacterBody2D

var gravity = 30
var input_locked := false
var stopped_on_door := false
@export var jump_force = 300

@export var controls: Resource=null

var right_sequence_index := 0;
var sequence_list := []

func _physics_process(_delta: float):
	input_locked = stopped_on_door
	if !is_on_floor():
		if is_on_wall():
			velocity.y += gravity * 0.5
		else:
			velocity.y += gravity
		if velocity.y >= 500:
			velocity.y = 600
		if Input.is_action_pressed(controls.move_down) && !input_locked:
			velocity.y += 300
		
	if !input_locked && (Input.is_action_just_pressed(controls.move_up) && (is_on_floor() || is_on_wall())):
		velocity.y = -jump_force
		
	
	var horizontaDirection = Input.get_axis(controls.move_left, controls.move_right)
	if (!input_locked):
		velocity.x = 300 * horizontaDirection
	else:
		velocity.x = 0
		
	move_and_slide()
	
	if stopped_on_door:
		print($"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index))
		if right_sequence_index >= sequence_list.size():
			unlock_player()
		if Input.is_action_just_pressed(controls.move_up):
			if sequence_list[right_sequence_index] == "u":
				$"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index).paint_arrow(true)
				right_sequence_index += 1
			else:
				for i in $"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_children():
					i.paint_arrow(false)
				right_sequence_index = 0
		if Input.is_action_just_pressed(controls.move_down):
			if sequence_list[right_sequence_index] == "d":
				$"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index).paint_arrow(true)
				right_sequence_index += 1
			else:
				for i in $"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_children():
					i.paint_arrow(false)
				right_sequence_index = 0
		if Input.is_action_just_pressed(controls.move_left):
			if sequence_list[right_sequence_index] == "l":
				$"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index).paint_arrow(true)
				right_sequence_index += 1
			else:
				for i in $"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_children():
					i.paint_arrow(false)
				right_sequence_index = 0
		if Input.is_action_just_pressed(controls.move_right):
			if sequence_list[right_sequence_index] == "r":
				$"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index).paint_arrow(true)
				right_sequence_index += 1
			else:
				for i in $"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_children():
					i.paint_arrow(false)
				right_sequence_index = 0
		print(right_sequence_index)
		print(sequence_list)
			
		
		
	
func stop_on_door() -> void:
	
	sequence_list = ["u","d","l","r","r"]
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
	stopped_on_door = true

func unlock_player() -> void:
	for i in $"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_children():
			i.paint_arrow(false)
	print("unlocked")
	stopped_on_door = false
	right_sequence_index = 0
