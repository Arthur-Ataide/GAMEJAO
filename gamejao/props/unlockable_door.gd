extends StaticBody2D

signal body_entered_door(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_entered_door.emit(body) # Replace with function body.
	print(body)
	if body.has_method("stop_on_door"):
		body.stop_on_door()
	
