extends Node2D

@export var gravity = 30

func _ready():
	var world = $VBoxContainer/ViewPortContainerPlayer1/ViewportPlayer1.find_world_2d()
	$VBoxContainer/ViewPortContainerPlayer2/ViewportPlayer1.world_2d = world
