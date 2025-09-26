extends CharacterBody2D

var gravity = 30
var input_locked := false
var stopped_on_door := false
var quant_portas = 0
@export var jump_force = 300
@export var buff_duracao := 5.0

# Lista para guardar todos os buffs ativos
var active_buffs: Array = []

# Guardaremos as velocidades base para não perdê-las
var base_run_speed: float
var base_jump_force: float
var base_walk_speed: float 

@export var aumento_velocidade = 300
@export var aumento_pulo = 150
@export var walk_speed = 300
@export var run_speed = 300
@export var ice_speed = 600

@export var slow_walk_speed = 0.4
@export var slow_jump_force = 100

var on_ice := false     
var on_goo := false   

var puzzle_modal_packed: PackedScene = preload("res://props/puzzle_modal.tscn")
var puzzleModalP1
var puzzleModalP2

@export var controls: Resource=null
var ultimo_ponto_seguro: Vector2
var destino_atual = null 

var right_sequence_index := 0;
var sequence_list := []
var doubleJump = true
var desencostouDaParede= true
var encostouNaParede = false
@export var wall_slide_speed: float = 50.0
@export var wall_jump_force: Vector2 = Vector2(250, -300)
var is_wall_sliding : bool = false
var wall_direction : int = 0

@onready var animacion := $AnimatedSprite2D as AnimatedSprite2D
@onready var double_tap_timer = $TimeDoubleTap
var is_running := false
var last_tap_direction := 0

@export var ponto_inicial: Marker2D

func _ready():
	base_run_speed = run_speed
	base_jump_force = jump_force
	base_walk_speed = walk_speed
	if ponto_inicial:
		global_position = ponto_inicial.global_position
		ultimo_ponto_seguro = ponto_inicial.global_position

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft

func start_wall_slide(left, right):
	is_wall_sliding = true
	velocity.y = min(velocity.y, wall_slide_speed)
	wall_direction = 1 if left else -1

func stop_wall_slide():
	is_wall_sliding = false
	wall_direction = 0

func _physics_process(_delta: float):
	atualizar_buffs(_delta)
	
	if is_on_wall_only():
		encostouNaParede = true
	var is_touching_left_wall = ray_left.is_colliding()
	var is_touching_right_wall = ray_right.is_colliding()
	
	if (is_touching_left_wall or is_touching_right_wall) and not is_on_floor() and velocity.y > 0:
		start_wall_slide(is_touching_left_wall, is_touching_right_wall)
	elif is_wall_sliding and not (is_touching_left_wall or is_touching_right_wall):
		stop_wall_slide()
		
	input_locked = stopped_on_door
	
	if is_on_floor():
		doubleJump= true
		
	if desencostouDaParede && encostouNaParede:
		doubleJump = true

	if !is_on_floor():
		velocity.y += gravity
		if velocity.y >= 500:
			velocity.y = 600
		if Input.is_action_pressed(controls.move_down) && !input_locked:
			velocity.y += 300
		if Input.is_action_just_pressed(controls.move_up) && doubleJump:
			doubleJump = false
			encostouNaParede = false
			desencostouDaParede = false
			velocity.y = -jump_force
		
		
		
	if !input_locked && (Input.is_action_just_pressed(controls.move_up) && (is_on_floor())):
		velocity.y = -jump_force
		
	
	var horizontalDirection = Input.get_axis(controls.move_left, controls.move_right)
	
	if horizontalDirection > 0:
		animacion.flip_h = false
	elif horizontalDirection < 0:
		animacion.flip_h = true 

	if !input_locked:
		var target_speed = walk_speed
			
		if Input.is_action_just_pressed(controls.move_right):
			if last_tap_direction == 1 and not double_tap_timer.is_stopped():
				is_running = true
				double_tap_timer.stop()
			else:
				last_tap_direction = 1
				double_tap_timer.start()
		
		if Input.is_action_just_pressed(controls.move_left):
			if last_tap_direction == -1 and not double_tap_timer.is_stopped():
				is_running = true
				double_tap_timer.stop()
			else:
				last_tap_direction = -1
				double_tap_timer.start()
			
		if is_running:
			target_speed += run_speed
		
		if horizontalDirection == 0:
			is_running = false
			
		if on_goo:
			target_speed = target_speed*0.4
			gravity = slow_jump_force
		else:
			gravity = 30
			
		if on_ice:
			target_speed += ice_speed

		if on_ice:
			target_speed = ice_speed

		velocity.x = target_speed * horizontalDirection
			
		if horizontalDirection != 0:
			if abs(velocity.x) > base_walk_speed:
				animacion.play("correr")
			else:
				animacion.play("andando")
		else:
			animacion.play("parado")
			
	else:
		animacion.play("parado")
		velocity.x = 0
		
	if is_wall_sliding and Input.is_action_just_pressed(controls.move_up):
		if (desencostouDaParede):
			velocity = Vector2(wall_jump_force.x * wall_direction, wall_jump_force.y)
			desencostouDaParede = false
			stop_wall_slide()
	if !is_on_wall() && encostouNaParede:
		desencostouDaParede = true
		
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
		puzzleModalP1.position = Vector2(460, 40)
		
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
			puzzleModalP2.position = Vector2(460, 310)
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

func entrou_na_gosma():
	on_goo = true
	print("Entrou na Gosma!")

func saiu_da_gosma():
	on_goo = false
	print("Saiu da Gosma!")

# Chamada pelo PisoDeGelo quando o jogador entra
func entrou_no_gelo():
	on_ice = true
	print("Boost de gelo ATIVO (enquanto estiver no gelo)")

# Chamada pelo PisoDeGelo quando o jogador sai
func saiu_do_gelo():
	on_ice = false
	print("Boost de gelo DESATIVADO")

func receber_buff_aleatorio(tipo_buff):
	# Cria um novo dicionário para representar o buff
	var novo_buff = {
		"tipo": tipo_buff,
		"tempo_restante": buff_duracao # Começa com 5 segundos
	}
	
	# Adiciona o novo buff à lista de buffs ativos
	active_buffs.append(novo_buff)
	
	# Recalcula os status do jogador imediatamente
	recalcular_status()
	
	if tipo_buff == "velocidade":
		print("BUFF DE VELOCIDADE ACUMULADO!")
		print()
	elif tipo_buff == "pulo":
		print("BUFF DE PULO ACUMULADO!")

# Esta função deve ser chamada a cada frame no _physics_process
func atualizar_buffs(delta: float):
	# Se não há buffs, não há o que fazer
	if active_buffs.is_empty():
		return

	var buff_expirou = false
	# Usamos um loop reverso para poder remover itens sem problemas
	for i in range(active_buffs.size() - 1, -1, -1):
		var buff = active_buffs[i]
		buff.tempo_restante -= delta # Diminui o tempo restante

		# Se o tempo acabou, remove o buff
		if buff.tempo_restante <= 0:
			active_buffs.remove_at(i)
			buff_expirou = true
			print("Um buff de %s acabou!" % buff.tipo)
	
	# Se algum buff expirou, precisamos recalcular os status
	if buff_expirou:
		recalcular_status()

# Esta função centraliza o cálculo dos status
func recalcular_status():
	# Zera os bônus para recalcular
	var speed_bonus = 0
	var jump_bonus = 0
	
	# Itera por todos os buffs ativos e soma seus efeitos
	for buff in active_buffs:
		if buff.tipo == "velocidade":
			speed_bonus += aumento_velocidade
		elif buff.tipo == "pulo":
			jump_bonus += aumento_pulo
			
	# Aplica os bônus calculados aos status base do personagem
	walk_speed = base_walk_speed + speed_bonus
	run_speed = base_run_speed + speed_bonus
	jump_force = base_jump_force + jump_bonus
	
	print("Status atualizados: Caminhada=%s, Corrida=%s, Pulo=%s" % [walk_speed, run_speed, jump_force])

func _on_time_checkpoint_timeout() -> void:
	if is_on_floor():
		ultimo_ponto_seguro = global_position
		print("Checkpoint salvo em: ", ultimo_ponto_seguro)


func _on_time_double_tap_timeout() -> void:
	last_tap_direction = 0 
