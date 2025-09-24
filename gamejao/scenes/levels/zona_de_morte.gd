# zona_de_morte.gd
extends Area2D

func _on_body_entered(body):
	# Verifica se o corpo que entrou tem uma função "morrer".
	# É uma forma segura de garantir que é o jogador ou um inimigo que pode morrer.
	if body.has_method("morrer"):
		body.morrer()
