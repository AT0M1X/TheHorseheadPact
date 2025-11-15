extends Node

var player
var _enemies := []
var bullets := []
var state := "player" # "player" or "enemies"
var game_over := false
var current_turn = 0
var deal_turn_modifier = 5

var unused_deal_list := []
var used_deal_list := []

signal deal_turn_happened

func reset():
	_enemies.clear()
	bullets.clear()
	state = "player"
	game_over = false
	current_turn = 0

func register_player(p):
	player = p

func register_enemy(e):
	_enemies.append(e)
	
func kill_enemy(e):
	e.queue_free()
	_enemies.erase(e)
	# Handle victory condition - just reloading for now
	if _enemies.is_empty():
		reset()
		get_tree().reload_current_scene()
		
func register_bullet(b):
	bullets.append(b)

func on_player_end_turn():
	if game_over:
		return
	
	# Let player update before next entity turn
	await get_tree().physics_frame
	await get_tree().process_frame
	
	state = "enemies"
	process_bullets()
	if game_over:
		return
	process_enemies()
	
	state = "player"
	if is_instance_valid(player):
		player.is_my_turn = true

func process_enemies():
	for e in _enemies:
		if game_over:
			return
		if is_instance_valid(e):
			e.take_turn()

func process_bullets():
	var dead_bullets := []
	for b in bullets:
		if game_over:
			return
		if is_instance_valid(b) and b.move():
			dead_bullets.append(b)
				
	for b in dead_bullets:
		b.remove_bullet()

func player_die():
	if game_over:
		return
	
	game_over = true
	player.die()

func process_deal_turn():
	state = "deal"
	print("horse")
	emit_signal("deal_turn_happened")
	state = "enemy"

func next_turn():
	current_turn += 1
	if (current_turn % (deal_turn_modifier + randi_range(-2,2)) == 0):
		process_deal_turn()
		
func pick_deal ():
	return

func reset_deals ():
	return
