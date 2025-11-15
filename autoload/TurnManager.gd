extends Node

var player
var enemies := []
var bullets := []
var state := "player" # "player" or "enemies"
var game_over := false

func reset():
	enemies.clear()
	state = "player"
	game_over = false

func register_player(p):
	player = p

func register_enemy(e):
	enemies.append(e)
	
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
	for e in enemies:
		if game_over:
			return
		if is_instance_valid(e):
			e.take_turn()
			await get_tree().physics_frame
			await get_tree().process_frame

func process_bullets():
	for b in bullets:
		if game_over:
			return
		if is_instance_valid(b):
			b.move()
			await get_tree().physics_frame
			await get_tree().process_frame

func player_die():
	if game_over:
		return
	
	game_over = true
	player.die()
