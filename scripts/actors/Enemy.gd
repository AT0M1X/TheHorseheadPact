extends Node2D

const TILE_SIZE := 32.0

@onready var raycast: RayCast2D = $RayCast2D

var player: Node2D


func _ready():
	TurnManager.register_enemy(self)


func take_turn():
	player = TurnManager.player
	if player == null:
		return

	if is_axis_aligned_with_player(player) and has_line_of_sight_to(player):
		shoot_at_player()


func get_cell_pos(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(round(world_pos.x / TILE_SIZE)),
		int(round(world_pos.y / TILE_SIZE))
	)


func is_axis_aligned_with_player(player: Node2D) -> bool:
	var my_cell     := get_cell_pos(global_position)
	var player_cell := get_cell_pos(player.global_position)

	return my_cell.x == player_cell.x or my_cell.y == player_cell.y


func has_line_of_sight_to(player: Node2D) -> bool:
	#var my_cell     := get_cell_pos(global_position)
	#var player_cell := get_cell_pos(player.global_position)
	var my_cell = position
	var player_cell = player.position

	var dx_cells = player_cell.x - my_cell.x
	var dy_cells = player_cell.y - my_cell.y

	var cast_to: Vector2

	if dx_cells == 0:
		# same column → vertical cast
		cast_to = Vector2(0, float(dy_cells))
	elif dy_cells == 0:
		# same row → horizontal cast
		cast_to = Vector2(float(dx_cells), 0)
	else:
		# Not truly aligned; extra safety
		return false

	# RayCast2D target position is local to the raycast node
	raycast.target_position = cast_to
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		return hit == player
		
	return false


func shoot_at_player():
	TurnManager.player_die()
