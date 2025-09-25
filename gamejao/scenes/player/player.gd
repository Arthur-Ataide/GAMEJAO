extends CharacterBody2D

var gravity = 30
var input_locked := false
var stopped_on_door := false
var quant_portas = 0
@export var jump_force = 300

@export var controls: Resource=null
var ultimo_ponto_seguro: Vector2
var destino_atual = null 

func _physics_process(_delta: float):
	if (stopped_on_door):
		input_locked = true
		
		# Verifica a ação de interação (usando seu 'controls').
		if Input.is_action_just_pressed(controls.move_up):
			# Se for uma porta com destino, teletransporta.
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
