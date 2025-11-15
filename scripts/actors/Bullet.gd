extends Node2D

var direction = Vector2.RIGHT
var tile_size = 32
var spawn_turn = true

func setup(dir: Vector2, pos: Vector2):
	direction = dir
	position = pos
	TurnManager.register_bullet(self)
	check_collision(false)

func move():
	if spawn_turn:
		spawn_turn = false
		return
		
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	position += direction * tile_size
	check_collision()
=======
=======
>>>>>>> Stashed changes
	check_collision(true)
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit != TurnManager.player and !hit.is_in_group("enemies") and !hit.is_in_group("projectiles"):
			queue_free()
			TurnManager.bullets.erase(self)
		
	position += direction * Settings.tile_size
	check_collision(false)
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

func check_collision(pre_check: bool):
	if !get_tree(): return
	var bodies = get_tree().get_nodes_in_group("enemies")
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	for e in bodies:
		if e.position == position:
			queue_free()
			TurnManager.bullets.erase(self)
			e.queue_free()
			TurnManager.enemies.erase(e)
			break
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
	
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
