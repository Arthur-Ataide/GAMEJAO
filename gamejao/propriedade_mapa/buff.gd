extends Area2D

# Referências para os nós que vamos esconder/mostrar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var respawn_timer = $TimeBuff

# Conectado ao sinal body_entered da Area2D
func _on_body_entered(body):
	# Verifica se quem entrou é o jogador e se o item está visível
	if animated_sprite_2d.visible and body.has_method("receber_buff_aleatorio"):
		# Sorteia o tipo de buff
		var sorteio = randi() % 2 
		if sorteio == 0:
			body.receber_buff_aleatorio("velocidade")
		else:
			body.receber_buff_aleatorio("pulo")
		
		# Esconde o item, desativa a colisão e inicia o timer
		esconder_item()
		respawn_timer.start()

func _on_time_buff_timeout() -> void:
	mostrar_item()

# Função para esconder o item
func esconder_item():
	animated_sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled", true)

# Função para mostrar o item novamente
func mostrar_item():
	animated_sprite_2d.visible = true
	collision_shape_2d.set_deferred("disabled", false)
