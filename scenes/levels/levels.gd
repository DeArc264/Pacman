extends Node

var layer

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.running_mode_entered.connect(_on_running_mode_entered)
	GameManager.running_mode_ended.connect(_on_runnning_mode_ended)

	if GameManager.level_selec == 1:
		$TileMap.set_layer_enabled(0, true)
		layer = 0
	elif GameManager.level_selec == 2:
		$TileMap.set_layer_enabled(1, true)
		layer = 1
	else:
		$TileMap.set_layer_enabled(2, true)
		layer = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	var local_position : Vector2 = $TileMap.to_local($Player.global_position)
	var tile : Vector2 = $TileMap.local_to_map(local_position)
	var data :TileData = $TileMap.get_cell_tile_data(layer, tile)
	
	if not data:
		return
	
	if data.get_custom_data("small_pellet"):
		GameManager.eat_small_pellet()
		$TileMap.erase_cell(layer, tile)
		if not $EatSound.playing:
			$EatSound.play()
	elif data.get_custom_data("large_pellet"):
		GameManager.eat_large_pellet()
		$TileMap.erase_cell(layer, tile)

	if GameManager.lives == 0:
		get_tree().change_scene_to_file("res://scenes/systems/game_over/game_over.tscn")

	if GameManager.score >= 1000:
		if GameManager.lives < 3:
			GameManager.lives + 1
			GameManager.score = 0


func _on_running_mode_entered():
	$RunningSound.stop()
	$SirenSound.play()


func _on_runnning_mode_ended():
	$RunningSound.play()
	$SirenSound.stop()
	await get_tree().create_timer(2.1).timeout
	$RunningSound.stop()
