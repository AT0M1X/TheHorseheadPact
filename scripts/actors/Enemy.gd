extends CharacterBody2D

@export var Bullet : PackedScene
@export_range(0, 1, 0.05) var MoveChance : float = 0.8

@onready var raycast: RayCast2D = $RayCast2D

var tile_size = Settings.tile_size
var move_right = true
var last_dir = Vector2()

func _ready():
	TurnManager.register_enemy(self)

func take_turn():
	var player = TurnManager.player
	if player == null:
		return

	if randf() > MoveChance:
		if try_move():
			return

	if is_axis_aligned_with_player(player) and has_line_of_sight_to(player):
		if int(player.position.x) == int(position.x):
			shoot_at_player(0, 1 if player.position.y > position.y else -1)
		if int(player.position.y) == int(position.y):
			shoot_at_player(1 if player.position.x > position.x else -1, 0)

func is_axis_aligned_with_player(player: Node2D) -> bool:
	return position.x == player.position.x or position.y == player.position.y


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

func try_move() -> bool:
	# Randomly decide direction
	var x = 0
	var y = 0
	if randi() % 2:
		y = (randi() % 2) * 2 - 1
	else:
		x = (randi() % 2) * 2 - 1
		
	var direction = Vector2(x, y)
	last_dir = direction
	var motion = direction * Settings.tile_size

	# Use move_and_collide to check BEFORE moving
	var collision = move_and_collide(motion, true)

	if collision:
		# Hit a wall or enemy — cannot move
		return false
	
	# Safe to move: use move_and_collide for actual movement
	move_and_collide(motion)
	return true
