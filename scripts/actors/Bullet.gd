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
	spawn_turn = true

func move() -> bool:
	if spawn_turn:
		spawn_turn = false
		return false
	
	if check_collision(true): return true
	
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit != TurnManager.player and !hit.is_in_group("enemies") and !hit.is_in_group("projectiles"):
			return true

	position += direction * Settings.tile_size
	return check_collision(false)

func check_collision(phase_check: bool) -> bool:
	# Check against player
	var p = TurnManager.player
	if p.position == position:
		if phase_check:
			if p.last_dir == -direction:
				remove_bullet()
				TurnManager.player_die()
				return true
		else:
			remove_bullet()
			TurnManager.player_die()
			return true
	
	# Check against enemies
	if get_tree() == null: return false
	var bodies = get_tree().get_nodes_in_group("enemies")
	for e in bodies:
		if e.position == position:
			if phase_check:
				if e.last_dir == -direction:
					remove_bullet()
					TurnManager.kill_enemy(e)
					return true
			else:
				remove_bullet()
				TurnManager.kill_enemy(e)
				return true
	return false
			

func remove_bullet():
	queue_free()
	TurnManager.bullets.erase(self)
