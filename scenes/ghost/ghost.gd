extends CharacterBody2D


const DIRECTIONS := [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]

enum GhostType {RED, YELLOW, PINK, ORANGE}
enum GhostMode {NORMAL, RUNNING, RUNNING_ENDING}

@export var type = GhostType.RED
@export var speed = 70
@export var release_time = 1
@export var eaten_time = 3

var ghost_color := "red"
var inside_cage := true
var mode := GhostMode.NORMAL
var direction := Vector2.UP
var start_position: Vector2


func _ready():
	GameManager.pacman_died.connect(restart)
	GameManager.running_mode_entered.connect(_on_running_mode_entered)
	GameManager.running_mode_ending.connect(_on_running_mode_ending)
	GameManager.running_mode_ended.connect(_on_running_mode_ended)

	ghost_color = _get_color()
	await get_tree().create_timer(release_time).timeout
	_release_ghosts()
	start_position = global_position

func _process(_delta):
	match mode:
		GhostMode.NORMAL:
			ghost_color = _get_color()
		GhostMode.RUNNING:
			ghost_color = "blue"
		GhostMode.RUNNING_ENDING:
			ghost_color = "flash"

	var animation_name :String = ghost_color + "_" + _get_direction_name()
	$Ghost_sprites.play(animation_name)


func _physics_process(delta):
	var collision = move_and_collide(direction * speed * delta)

	if collision:
		direction = _get_next_direction()


func _get_color():
	match type:
		GhostType.RED:
			return "red"
		GhostType.YELLOW:
			return "yellow"
		GhostType.PINK:
			return "pink"
		_:
			return "orange"


func _get_direction_name():
	if direction == Vector2.UP:
		return "up"
	elif direction == Vector2.DOWN:
		return "down"
	elif direction == Vector2.RIGHT:
		return "right"
	else:
		return "left"


func _release_ghosts():
	set_collision_mask_value(5, false)
	$"Gate Detector".monitoring = true


func _get_next_direction():
	if inside_cage:
		if direction == Vector2.DOWN:
			return Vector2.UP
		else:
			return Vector2.DOWN
	else:
		return DIRECTIONS.pick_random()


func _on_gate_detector_body_exited(_body):
	inside_cage = false


func _on_running_mode_entered():
	mode = GhostMode.RUNNING


func _on_running_mode_ending():
	mode = GhostMode.RUNNING_ENDING


func _on_running_mode_ended():
	mode = GhostMode.NORMAL


func kill():
	global_position = start_position
	direction = Vector2.UP
	inside_cage = true
	set_collision_mask_value(5, true)
	await get_tree().create_timer(eaten_time).timeout
	_release_ghosts()


func restart():
	global_position = start_position
	direction = Vector2.UP
	inside_cage = true
	set_collision_mask_value(5, true)
	await get_tree().create_timer(release_time).timeout
	_release_ghosts()
