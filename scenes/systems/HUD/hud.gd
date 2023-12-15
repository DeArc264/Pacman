extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HBoxContainer/Life.visible = GameManager.lives > 0
	$HBoxContainer/Life2.visible =GameManager.lives > 1
	$HBoxContainer/Life3.visible = GameManager.lives > 2
	$HBoxContainer/Score.text = str(GameManager.score)
