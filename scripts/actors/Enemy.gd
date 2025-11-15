extends Node2D

@export var Bullet : PackedScene
var tile_size = 32

func _ready():
	TurnManager.register_enemy(self)

func take_turn():
	# Dumb behavior: if player in same row/column, "shoot"
	if TurnManager.player:
		var p = TurnManager.player
		if int(p.position.x) == int(position.x):
			shoot_at_player(0, 1 if p.position.y > position.y else -1)
		if int(p.position.y) == int(position.y):
			shoot_at_player(1 if p.position.x > position.x else -1, 0)
	# Enemy turn ends automatically after all enemies act

func shoot_at_player(x: float, y: float):
	var dir = Vector2(x, y)
	var pos = position + dir * tile_size
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.setup(dir, pos)
	bullet.spawn_turn = false
