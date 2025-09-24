# porta.gd
extends Area2D

# Esta variável vai guardar o destino específico desta porta.
# O @export faz ela aparecer no editor.
@export var destino: Marker2D

# Sinal emitido quando um corpo (como o jogador) entra na área.
func _on_body_entered(body):
	# Verifica se o corpo que entrou é o nosso jogador.
	if body.has_method("set_destino_e_estado_da_porta"):
		# Se for, chama a função do jogador para avisar:
		# 1. Qual é o destino desta porta.
		# 2. Que o jogador agora está perto de uma porta.
		body.set_destino_e_estado_da_porta(destino, true)

# Sinal emitido quando o corpo sai da área.
func _on_body_exited(body):
	if body.has_method("set_destino_e_estado_da_porta"):
		# Avisa ao jogador que ele não está mais perto da porta e não tem destino.
		body.set_destino_e_estado_da_porta(null, false)
