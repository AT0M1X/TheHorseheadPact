extends Node2D

var tile_size = 32

func _ready():
	TurnManager.register_enemy(self)

func take_turn():
	# Dumb behavior: if player in same row/column, "shoot"
	if TurnManager.player:
		var p = TurnManager.player
		if int(p.position.x) == int(position.x) or int(p.position.y) == int(position.y):
			shoot_at_player()
	# Enemy turn ends automatically after all enemies act

func shoot_at_player():
	# For prototype: if aligned, player dies
	TurnManager.player_die()
