extends Node

var next_spawn_name := ""

func go_to(scene: PackedScene, spawn_name: String) -> void:
	next_spawn_name = spawn_name
	get_tree().change_scene_to_packed(scene)
