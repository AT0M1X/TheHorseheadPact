extends Node2D

var direction = Vector2.RIGHT
var spawn_turn = true

func setup(dir: Vector2, pos: Vector2):
	direction = dir
	position = pos
	TurnManager.register_bullet(self)
	check_collision()

func move():
	if spawn_turn:
		spawn_turn = false
		return
		
	position += direction * Settings.tile_size
	check_collision()

func check_collision():
	var bodies = get_tree().get_nodes_in_group("enemies")
	for e in bodies:
		if e.position == position:
			queue_free()
			TurnManager.bullets.erase(self)
			e.queue_free()
			TurnManager.enemies.erase(e)
			break
	
	if TurnManager.player:
		var p = TurnManager.player
		if p.position == position:
			queue_free()
			TurnManager.bullets.erase(self)
			TurnManager.player_die()
