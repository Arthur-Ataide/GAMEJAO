extends Control

var up_arrow: PackedScene = preload("res://props/puzzle_arrow_up.tscn")
var down_arrow: PackedScene = preload("res://props/puzzle_arrow_down.tscn")
var right_arrow: PackedScene = preload("res://props/puzzle_arrow_right.tscn")
var left_arrow: PackedScene = preload("res://props/puzzle_arrow_left.tscn")

func _ready():
	pass
	
	
func createArrowList(list):
	print(list)
	for i in list:
		if i == "u":
			var up_arrow_inst = up_arrow.instantiate()
			$SubViewportContainer/SubViewport/HBoxContainer.add_child(up_arrow_inst)
		if i == "d":
			var down_arrow_inst = down_arrow.instantiate()
			$SubViewportContainer/SubViewport/HBoxContainer.add_child(down_arrow_inst)
		if i == "r":
			var right_arrow_inst = right_arrow.instantiate()
			$SubViewportContainer/SubViewport/HBoxContainer.add_child(right_arrow_inst)
		if i == "l":
			var left_arrow_inst = left_arrow.instantiate()
			$SubViewportContainer/SubViewport/HBoxContainer.add_child(left_arrow_inst)
