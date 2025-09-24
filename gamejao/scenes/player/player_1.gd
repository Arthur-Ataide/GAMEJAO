extends CharacterBody2D


var gravity = 30
var jump_force = 300
var perto_da_porta = false
var destino_atual = null 

func set_destino_e_estado_da_porta(novo_destino, esta_perto):
	destino_atual = novo_destino
	perto_da_porta = esta_perto

func _physics_process(_delta: float):
	# Aplica gravidade constantemente, a menos que o personagem esteja no chão.
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 600:
			velocity.y = 600

	# Agora, decide entre INTERAGIR ou MOVER
	if perto_da_porta:
		# --- AÇÕES DE INTERAÇÃO ---
		# Para completamente o movimento horizontal
		velocity.x = 0
		
		if Input.is_action_just_pressed("jump_player_1"): # Recomendo usar uma tecla como "E" ou "Enter"
			print("AÇÃO: Abrir a porta!")
			if destino_atual:
				# TELETRANSPORTA O JOGADOR!
				global_position = destino_atual.global_position
			else:
				print("ERRO: Esta porta não tem um destino configurado!")
	else:
		# --- LÓGICA DE MOVIMENTO NORMAL ---
		# Pulo
		if Input.is_action_just_pressed("jump_player_1") and is_on_floor():
			velocity.y = -jump_force
		
		# Movimento Horizontal (movido para cá)
		var horizontal_direction = Input.get_axis("left_player_1", "right_player_1")
		velocity.x = 300 * horizontal_direction

	# A chamada final que aplica toda a velocidade calculada
	move_and_slide()

func _on_porta_area_body_entered(body):
	if body == self:
		perto_da_porta = true
		print("Jogador1 está perto da porta!")

func _on_porta_area_body_exited(body):
	if body == self:
		perto_da_porta = false
		print("Jogador1 se afastou da porta.")
