extends Node

var player
var enemies := []
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

func on_player_end_turn():
	if game_over:
		return
		
	state = "enemies"
	process_enemies()

func process_enemies():
	for e in enemies:
		if game_over:
			return
		if is_instance_valid(e):
			e.take_turn()
	
	state = "player"
	if is_instance_valid(player):
		player.is_my_turn = true

func player_die():
	if game_over:
		return
	
	game_over = true
	player.die()
