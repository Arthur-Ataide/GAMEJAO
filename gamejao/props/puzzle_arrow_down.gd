extends SubViewportContainer

func paint_arrow(right):
	if right:
		$SubViewport/Sprite2D.modulate = Color(0.47, 0.71, 0.14, 1)
	else:
		$SubViewport/Sprite2D.modulate = Color(1, 1, 1, 1)
