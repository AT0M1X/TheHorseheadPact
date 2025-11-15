extends CharacterBody2D

@export var Bullet : PackedScene

var tile_size = 32
var can_act := false
var last_dir = Vector2.RIGHT

signal turn_done

func _ready():
	TurnManager.register_player(self)

func take_turn():
	can_act = true

func _unhandled_input(event):
	if !can_act:
		return

	if event.is_action_pressed("shoot"):
		shoot(Vector2.ZERO)
		return
		
	if event.is_action_pressed("shoot_up"):
		shoot(Vector2.UP)
	elif event.is_action_pressed("shoot_right"):
		shoot(Vector2.RIGHT)
	elif event.is_action_pressed("shoot_left"):
		shoot(Vector2.LEFT)
	elif event.is_action_pressed("shoot_down"):
		shoot(Vector2.DOWN)

	if event.is_action_pressed("move_right"):
		try_move(Vector2.RIGHT)
	elif event.is_action_pressed("move_left"):
		try_move(Vector2.LEFT)
	elif event.is_action_pressed("move_up"):
		try_move(Vector2.UP)
	elif event.is_action_pressed("move_down"):
		try_move(Vector2.DOWN)

func try_move(dir: Vector2):
	if dir == Vector2.ZERO:
		return
		
	last_dir = dir
	var motion = dir * Settings.tile_size

	# Use move_and_collide to check BEFORE moving
	var collision = move_and_collide(motion, true)

	if collision:
		# Hit a wall or enemy — cannot move
		return
	
	# Safe to move: use move_and_collide for actual movement
	move_and_collide(motion)
	end_turn()
	
func shoot(dir: Vector2):
	if dir != Vector2.ZERO:
		last_dir = dir
	var pos = position + last_dir * Settings.tile_size
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.setup(last_dir, pos)
	
	end_turn()

func end_turn():
	can_act = false
	emit_signal("turn_done")
