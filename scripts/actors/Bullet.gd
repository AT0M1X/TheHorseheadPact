extends Node

var direction = Vector2.RIGHT
var tile_size = 32

func set_direction(dir: Vector2):
	direction = dir

func move():
	print("d")
	#position += direction * tile_size
