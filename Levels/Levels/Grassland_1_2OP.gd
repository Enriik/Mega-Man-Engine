tool
extends Level

func _ready() -> void:
	for i in $Spawners.get_children():
		if i.name == "SpriteCycling":
			return
		if i.name == "Player":
			return
		
		i.spawn_target_node = "../../Iterable"
