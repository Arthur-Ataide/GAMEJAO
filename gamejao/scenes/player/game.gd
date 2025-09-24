extends Node2D

func _ready():
	var world = $VBoxContainer/SubViewportContainer/SubViewport.find_world_2d()
	$VBoxContainer/SubViewportContainer2/SubViewport.world_2d = world
