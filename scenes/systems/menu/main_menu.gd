extends Control


func _ready():
	$AnimatedSprite2D.play("default")
	$AudioStreamPlayer.play()


func _on_level_1_pressed():
	GameManager.level_selec = 1
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")


func _on_level_2_pressed():
	GameManager.level_selec = 2
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")


func _on_level_3_pressed():
	GameManager.level_selec = 3
	get_tree().change_scene_to_file("res://scenes/levels/levels.tscn")


func _on_exit_pressed():
	get_tree().quit()
