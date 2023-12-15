extends Control


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/systems/menu/main_menu.tscn")


func _on_exit_pressed():
	get_tree().quit()
