extends Node

var player
var enemies := []
var bullets := []
var state := "player" # "player" or "enemies"
var game_over := false
var currentTurn = 0
var dealTurnModifier = 5

var unusedDealList := []
var usedDealList := []

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
	
	if(state == "player"):
		state = "enemies"
		
		next_turn()
		process_bullets()
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

func process_deal_turn():
	state = "deal"
	print("horse")
	emit_signal("dealTurnHappened")
	state = "enemy"

func next_turn():
	currentTurn += 1
	if (currentTurn % (dealTurnModifier + randi_range(-2,2)) == 0):
		process_deal_turn()
		
func pick_deal ():
	return

func reset_deals ():
	return
