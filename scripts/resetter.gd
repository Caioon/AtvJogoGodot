extends Area2D

var initial_position: Vector2

func _ready() -> void:
	initial_position = get_tree().get_first_node_in_group("player").global_position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.global_position = initial_position
