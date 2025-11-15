extends Node2D

@export var Bullet : PackedScene

@onready var raycast: RayCast2D = $RayCast2D

func _ready():
	TurnManager.register_enemy(self)

func take_turn():
	var player = TurnManager.player
	if player == null:
		return

	if is_axis_aligned_with_player(player) and has_line_of_sight_to(player):
		if int(player.position.x) == int(position.x):
			shoot_at_player(0, 1 if player.position.y > position.y else -1)
		if int(player.position.y) == int(position.y):
			shoot_at_player(1 if player.position.x > position.x else -1, 0)

func get_cell_pos(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(round(world_pos.x / Settings.tile_size)),
		int(round(world_pos.y / Settings.tile_size))
	)


func is_axis_aligned_with_player(player: Node2D) -> bool:
	var my_cell     := get_cell_pos(global_position)
	var player_cell := get_cell_pos(player.global_position)

	return my_cell.x == player_cell.x or my_cell.y == player_cell.y


func has_line_of_sight_to(player: Node2D) -> bool:
	var dx = player.position.x - position.x
	var dy = player.position.y - position.y

	var cast_to: Vector2

	if dx == 0:
		# same column → vertical cast
		cast_to = Vector2(0, dy)
	elif dy == 0:
		# same row → horizontal cast
		cast_to = Vector2(dx, 0)
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


func shoot_at_player(x: float, y: float):
	var dir = Vector2(x, y)
	var pos = position + dir * Settings.tile_size
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.setup(dir, pos)
	bullet.spawn_turn = false
