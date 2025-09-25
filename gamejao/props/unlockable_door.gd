extends StaticBody2D

@export var destino: Marker2D
signal body_entered_door(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_entered_door.emit(body) # Replace with function body.
	print(body)
	if body.has_method("set_destino_e_estado_da_porta"):
		# Se for, chama a função do jogador para avisar:
		# 1. Qual é o destino desta porta.
		# 2. Que o jogador agora está perto de uma porta.
		body.set_destino_e_estado_da_porta(destino, true)
	if body.has_method("stop_on_door"):
		body.stop_on_door()
	



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("set_destino_e_estado_da_porta"):
		# Avisa ao jogador que ele não está mais perto da porta e não tem destino.
		body.set_destino_e_estado_da_porta(null, false)
