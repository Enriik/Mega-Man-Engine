extends EnemyCore

var stop : bool # If true, stops as soon as this obj spawned

func _ready() -> void:
	if stop:
		stop()
	else:
		start()
	
	queue_free()

func start():
	get_tree().call_group("ChainTilemap", "start")

func stop():
	get_tree().call_group("ChainTilemap", "stop")
