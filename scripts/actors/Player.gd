extends Node2D

@export var Bullet : PackedScene

var is_my_turn := true
var last_dir = Vector2.RIGHT

signal player_died

func _ready():
	TurnManager.register_player(self)

func _input(event):
	if not is_my_turn:
		return

	if event.is_action_pressed("shoot"):
		shoot()
		return

	if event.is_action_pressed("move_right"):
		try_move(Vector2.RIGHT)
	elif event.is_action_pressed("move_left"):
		try_move(Vector2.LEFT)
	elif event.is_action_pressed("move_up"):
		try_move(Vector2.UP)
	elif event.is_action_pressed("move_down"):
		try_move(Vector2.DOWN)

func try_move(dir: Vector2):
	var target_pos = position + dir * Settings.tile_size
	# TODO: check collision / walls before moving
	position = target_pos
	end_turn()
	
func shoot():
	var pos = position + last_dir * Settings.tile_size
	var bullet = Bullet.instantiate()
	owner.add_child(bullet)
	bullet.setup(last_dir, pos)
	
	#for i in range(1, 20):
		#pos += last_dir * tile_size
		## Check if there is an enemy at pos (you can use groups or an Area2D)
		#var bodies = get_tree().get_nodes_in_group("enemies")
		#for e in bodies:
			#if e.position == pos:
				#e.queue_free()
				#TurnManager.enemies.erase(e)
				#break
	end_turn()

func end_turn():
	is_my_turn = false
	TurnManager.on_player_end_turn()
	
func die():
	emit_signal("player_died")
