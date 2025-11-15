extends Node2D

@onready var raycast: RayCast2D = $RayCast2D

var direction = Vector2.RIGHT
var spawn_turn = true

func setup(dir: Vector2, pos: Vector2):
	direction = dir
	rotation = direction.angle()
	position = pos
	TurnManager.register_bullet(self)
	check_collision(false)

func move():
	if spawn_turn:
		spawn_turn = false
		return
		
	check_collision(true)
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit != TurnManager.player and !hit.is_in_group("enemies") and !hit.is_in_group("projectiles"):
			remove_bullet()
		
	position += direction * Settings.tile_size
	check_collision(false)

func check_collision(pre_check: bool):
	if !get_tree(): return
	var bodies = get_tree().get_nodes_in_group("enemies")
	
	if !pre_check:
		for e in bodies:
			if e.position == position:
				remove_bullet()
				TurnManager.kill_enemy(e)
				return
			
	var p = TurnManager.player

	if p.position == position:
		if pre_check:
			if p.last_dir == -direction:
				remove_bullet()
				TurnManager.player_die()
				return
		else:
			remove_bullet()
			TurnManager.player_die()
			return

func remove_bullet():
	queue_free()
	TurnManager.bullets.erase(self)
