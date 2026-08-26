extends Camera2D

var target: Node2D

func _ready() -> void:
	get_target()

func _process(_delta: float) -> void:
	if target == null:
		return
	global_position = target.global_position

func get_target() -> void:
	var nodes := get_tree().get_nodes_in_group("player")
	if nodes.is_empty():
		push_error("Nenhum no no grupo 'player'")
		return
	target = nodes[0]
