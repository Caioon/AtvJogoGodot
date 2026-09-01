extends Area2D

@export var new_limit_bottom: int = 2000
@export var normal_limit_bottom: int = 209

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var camera = body.get_node("Camera2D")
		camera.limit_bottom = new_limit_bottom

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		var camera = body.get_node("Camera2D")
		camera.limit_bottom = normal_limit_bottom
