extends Control


func _input(event):
	if event is InputEventKey and event.is_pressed():
		mudar_para_proxima_cena()

func mudar_para_proxima_cena():
	get_tree().change_scene_to_file("res://game.tscn")
