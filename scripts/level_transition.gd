extends Area2D

@export var destination_scene: PackedScene
@export var spawn_point_name: String = "SpawnPoint"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Transition.go_to(destination_scene, spawn_point_name)
