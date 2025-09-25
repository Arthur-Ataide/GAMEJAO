extends CharacterBody2D

var gravity = 30
var input_locked := false
var stopped_on_door := false
var quant_portas = 0
@export var jump_force = 300
var puzzle_modal_packed: PackedScene = preload("res://props/puzzle_modal.tscn")
var puzzleModalP1
var puzzleModalP2

@export var controls: Resource=null
var ultimo_ponto_seguro: Vector2
var destino_atual = null 

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
		# print($"../../../../PuzzleModal/SubViewportContainer/SubViewport/HBoxContainer".get_child(right_sequence_index))
		if right_sequence_index >= sequence_list.size():
			unlock_player()
		if controls.player_index == 0:
			if Input.is_action_just_pressed(controls.move_up):
				if sequence_list[right_sequence_index] == "u":
					print(puzzleModalP1.get_child(right_sequence_index))
					puzzleModalP1.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP1.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_down):
				if sequence_list[right_sequence_index] == "d":
					puzzleModalP1.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP1.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_left):
				if sequence_list[right_sequence_index] == "l":
					puzzleModalP1.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP1.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_right):
				if sequence_list[right_sequence_index] == "r":
					puzzleModalP1.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP1.paintAllArrowsWhite()
					right_sequence_index = 0
		else:
			if Input.is_action_just_pressed(controls.move_up):
				if sequence_list[right_sequence_index] == "u":
					print(puzzleModalP2.get_child(right_sequence_index))
					puzzleModalP2.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP2.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_down):
				if sequence_list[right_sequence_index] == "d":
					puzzleModalP2.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP2.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_left):
				if sequence_list[right_sequence_index] == "l":
					puzzleModalP2.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP2.paintAllArrowsWhite()
					right_sequence_index = 0
			if Input.is_action_just_pressed(controls.move_right):
				if sequence_list[right_sequence_index] == "r":
					puzzleModalP2.paintArrow(right_sequence_index, true)
					right_sequence_index += 1
				else:
					puzzleModalP2.paintAllArrowsWhite()
					right_sequence_index = 0
		#print(right_sequence_index)
		#print(sequence_list)
			
		
		
	
func stop_on_door() -> void:
	sequence_list = ["u","d","l","r","r"]
	if controls.player_index == 0:
		var puzzlemodal1 = puzzle_modal_packed.instantiate()
		$"../../../..".add_child(puzzlemodal1)
		puzzleModalP1 = $"../../../..".get_child(-1)
		puzzleModalP1.position = Vector2(200, 20)
		
		if puzzleModalP1.has_method("createArrowList"):
			puzzleModalP1.createArrowList(["u","d","l","r","r"])
		#if $"../PuzzleModal".has_method("createArrowList"):
			#$"../PuzzleModal".createArrowList(["u","d","l","r","r"])
	else:
		var puzzlemodal2 = puzzle_modal_packed.instantiate()
		$"../../../..".add_child(puzzlemodal2)
		puzzleModalP2 = $"../../../..".get_child(-1)
		if puzzleModalP2.has_method("createArrowList"):
			puzzleModalP2.createArrowList(["u","d","l","r","r"])
			puzzleModalP2.position = Vector2(200, 155)
		#if $"../../../ViewPortContainerPlayer1/ViewportPlayer1/PuzzleModal".has_method("createArrowList"):
			#$"../../../ViewPortContainerPlayer1/ViewportPlayer1/PuzzleModal".createArrowList(["u","d","l","r","r"])

	stopped_on_door = true

func unlock_player() -> void:
	if controls.player_index == 0:
		puzzleModalP1.paintAllArrowsWhite()
		$"../../../..".remove_child(puzzleModalP1)
	else:
		puzzleModalP2.paintAllArrowsWhite()
		$"../../../..".remove_child(puzzleModalP2)
	print("unlocked")
	stopped_on_door = false
	right_sequence_index = 0
	print("Tentando teleportar")
	if destino_atual:
		print("AÇÃO: Teletransportando!")
		input_locked = false
		stopped_on_door = false
		global_position = destino_atual.global_position
		ultimo_ponto_seguro = destino_atual.global_position
		quant_portas+=1
		if quant_portas % 4 == 0: print(quant_portas/4, " VOLTAS COMPLETAS")
			
	else:
		print("Interagindo com porta sem destino (possivelmente um puzzle).")


# checkpoint
func set_destino_e_estado_da_porta(novo_destino, esta_perto):
	destino_atual = novo_destino
	stopped_on_door = esta_perto

# morte
func morrer():
	print("O personagem morreu! Aguardando...")
	set_physics_process(false) # Pausa a física para o personagem não se mover.
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.5).timeout # A pausa de 0.5 segundos.
	
	print("Voltando para o último checkpoint.")
	global_position = ultimo_ponto_seguro
	set_physics_process(true) # Reativa a física.

func _on_time_checkpoint_timeout() -> void:
	if is_on_floor():
		ultimo_ponto_seguro = global_position
		print("Checkpoint salvo em: ", ultimo_ponto_seguro)
