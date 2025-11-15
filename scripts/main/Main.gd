extends Node2D

var current_level_scene: PackedScene
var current_level_instance
var player
@export var levels : Array[PackedScene]
var _current_level = -1

func _ready():
	TurnManager.reset()
	TurnManager.player_died.connect(_on_player_died)
	TurnManager.level_cleared.connect(next_level)
	
	player = $Player
	next_level()
	TurnManager.do_turn()
	#load_level("res://scenes/levels/Level_01.tscn")
	#load_level("res://scenes/levels/OpenTesting.tscn")

func next_level():
	_current_level += 1
	if _current_level < levels.size():
		load_level(levels[_current_level])
	else:
		_current_level = -1
		next_level()
	
func load_level(level):
	if current_level_instance:
		current_level_instance.queue_free()

	TurnManager.first_turn = true
	current_level_instance = level.instantiate()
	$LevelContainer.add_child(current_level_instance)

	# Optionally move player to the level's designated PlayerStart
	var start = current_level_instance.get_node("PlayerStart")
	player.position = start.position

func restart_level():
	TurnManager.reset()
	load_level(levels[_current_level])
	
func _on_player_died():
	restart_level()
