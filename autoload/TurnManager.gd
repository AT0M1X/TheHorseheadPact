extends Node

var player
var _enemies := []
var bullets := []
var state := "player" # "player" or "enemies"
var game_over := false
var current_turn = 5

signal dealTurnHappened

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
	
	if(state == "player"):
		state = "enemies"
		
		next_turn()

		
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
	for b in bullets:
		if game_over:
			return
		if is_instance_valid(b):
			b.move()

func player_die():
	if game_over:
		return
	
	game_over = true
	player.die()

func next_turn():
	current_turn += 1
	DealManager.do_deal_event_turn(current_turn)
	DealManager.do_forced_turn(current_turn)
