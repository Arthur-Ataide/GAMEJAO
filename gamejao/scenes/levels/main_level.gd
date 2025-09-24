extends Node2D

#@export var destino: Marker2D
#
#func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Alguem na porta ", body)
	#if body.has_method("set_destino_e_estado_da_porta"):
		## Se for, chama a função do jogador para avisar:
		## 1. Qual é o destino desta porta.
		## 2. Que o jogador agora está perto de uma porta.
		#body.set_destino_e_estado_da_porta(destino, true)
#
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.has_method("set_destino_e_estado_da_porta"):
		## Avisa ao jogador que ele não está mais perto da porta e não tem destino.
		#body.set_destino_e_estado_da_porta(null, false)
