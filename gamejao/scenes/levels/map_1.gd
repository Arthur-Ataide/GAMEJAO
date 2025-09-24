extends Node2D

signal player_touched_door(body)


func _on_unlockable_door_body_entered_door(body: Variant) -> void:
	player_touched_door.emit(body)
