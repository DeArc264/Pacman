extends Area2D

@export var destination : Node2D


func _on_area_entered(area):
	area.global_position = destination.global_position


func _on_body_entered(body):
	body.global_position = destination.global_position
