extends Node2D

var current_level_scene: PackedScene
var current_level_instance
var player

func _ready():
	TurnManager.reset()
	
	player = $Player
	player.player_died.connect(_on_player_died)
	load_level("res://scenes/levels/Level_01.tscn")
	#load_level("res://scenes/levels/OpenTesting.tscn")

func load_level(path):
	if current_level_instance:
		current_level_instance.queue_free()

	current_level_scene = load(path)
	current_level_instance = current_level_scene.instantiate()
	$LevelContainer.add_child(current_level_instance)

	# Optionally move player to the level's designated PlayerStart
	var start = current_level_instance.get_node("PlayerStart")
	player.position = start.position

func restart_level():
	TurnManager.reset()
	#load_level(current_level_scene.resource_path)
	get_tree().reload_current_scene()
	
func _on_player_died():
	restart_level()
