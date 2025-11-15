extends Node

var player
var current_turn
var next_deal_turn
var _enemies := []
var bullets := []
var dead_bullets := []
var state := "player" # "player" or "enemies"
var game_over := false

signal reset_signal
signal start_turn(current_turn)
signal player_died
signal update_finger_counter(fingers)
signal update_turn_counter(current_turn)
signal update_honse_counter()

func reset():
	emit_signal("reset_signal")
	game_over = false
	current_turn = 0
	_enemies.clear()
	bullets.clear()

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

func do_turn():
	if game_over:
		return
	
	emit_signal("start_turn", current_turn) 
	var is_deal_event_turn = DealManager.do_deal_event_turn(current_turn)
	if is_deal_event_turn:
		await DealManager.deal_event_end
	
	var is_forced_turn = DealManager.do_forced_turn(current_turn)
	if is_forced_turn:
		await DealManager.forced_turn_end
	
	player.take_turn()
	await player.turn_done
	
	# Let player update before next entity turn
	await get_tree().physics_frame
	await get_tree().process_frame
	
	await process_bullets()
	await process_enemies()

	
	end_turn()

func end_turn():
	current_turn += 1
	emit_to_ui()
	
	if !game_over:
		call_deferred("do_turn")

func process_enemies():
	for e in _enemies:
		if game_over:
			return
		if is_instance_valid(e):
			e.take_turn()
			if e.has_signal("turn_done"):
				await e.turn_done

func process_bullets():
	for b in bullets:
		if game_over:
			return
		if is_instance_valid(b):
			b.move()
			if b.has_signal("move_done") :
				await b.move_done
				
	for b in dead_bullets:
		bullets.erase(b)
	dead_bullets.clear()

func player_die():
	if game_over:
		return
	
	game_over = true
	emit_signal("player_died")
	
func emit_to_ui():
	update_turn_counter.emit(current_turn)
	
	if DealManager.next_forced_turn:
		var turns_to_forced = DealManager.next_forced_turn - current_turn
		update_honse_counter.emit(turns_to_forced)
	
