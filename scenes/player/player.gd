extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

@export var speed:= 100

var facing_direction:= Direction.LEFT
var previous_direction:= Vector2.LEFT
var start_position : Vector2

func _ready():
	$PlayerSprite.play("left")
	start_position = position

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Down"):
		facing_direction = Direction.DOWN
		$PlayerSprite.play("down")
	elif event.is_action_pressed("Up"):
		facing_direction = Direction.UP
		$PlayerSprite.play("up")
	elif event.is_action_pressed("Left"):
		facing_direction = Direction.LEFT
		$PlayerSprite.play("left")
	elif event.is_action_pressed("Right"):
		facing_direction = Direction.RIGHT
		$PlayerSprite.play("right")

func _physics_process(delta):
	var direction := Vector2.ZERO

	match facing_direction:
		Direction.DOWN:
			direction.y = 1
		Direction.UP:
			direction.y = -1
		Direction.RIGHT:
			direction.x = 1
		Direction.LEFT:
			direction.x = -1

	velocity = direction

	var collision:= move_and_collide(velocity * speed * delta)
	if collision:
		if collision.get_collider() is CharacterBody2D:
			if GameManager.is_running_mode:
				collision.get_collider().kill()
				GameManager.eat_ghost()
				$EatGhostSound.play()
			else:
				_die()
				$DeathSound.play()
		else:
			move_and_collide(previous_direction * speed * delta)
	else:
		previous_direction = direction


func _restart():
	modulate = Color.WHITE
	position = start_position
	process_mode = Node.PROCESS_MODE_INHERIT
	$PlayerSprite.play("left")
	GameManager.lives -= 1
	GameManager.pacman_died.emit()


func _die():
	$PlayerSprite.pause()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate",Color.TRANSPARENT, 2)
	tween.tween_callback(_restart)
	process_mode = Node.PROCESS_MODE_DISABLED
