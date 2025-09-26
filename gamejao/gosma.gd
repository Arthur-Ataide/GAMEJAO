extends Area2D

func _on_body_entered(body):
	# Se o corpo que entrou tiver a função, chame-a
	if body.has_method("entrou_na_gosma"):
		body.entrou_na_gosma()

func _on_body_exited(body):
	# Se o corpo que saiu tiver a função, chame-a
	if body.has_method("saiu_da_gosma"):
		body.saiu_da_gosma()
