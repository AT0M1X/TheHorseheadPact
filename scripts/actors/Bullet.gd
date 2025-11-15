extends Node2D

@onready var raycast: RayCast2D = $RayCast2D

var direction = Vector2.RIGHT
var spawn_turn = true

func setup(dir: Vector2, pos: Vector2):
	direction = dir
	raycast.target_position = direction * Settings.tile_size
	position = pos
	TurnManager.register_bullet(self)
	check_collision()

func move():
	if spawn_turn:
		spawn_turn = false
		return
		
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit != TurnManager.player and !hit.is_in_group("enemies") and !hit.is_in_group("projectiles"):
			queue_free()
			TurnManager.bullets.erase(self)
		
	position += direction * Settings.tile_size
	check_collision()

func check_collision():
	var bodies = get_tree().get_nodes_in_group("enemies")
	for e in bodies:
		if e.position == position:
			queue_free()
			TurnManager.bullets.erase(self)
			TurnManager.kill_enemy(e)
			break
	
	if TurnManager.player:
		var p = TurnManager.player
		if p.position == position:
			queue_free()
			TurnManager.bullets.erase(self)
			TurnManager.player_die()
