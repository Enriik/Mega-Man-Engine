tool
extends Level

func _ready() -> void:
	for i in $Spawners.get_children():
		if (i.name as String).matchn("Spike*"):
			i.spawn_target_node = "./.."
		else:
			i.spawn_target_node = "./../../Iterable"
