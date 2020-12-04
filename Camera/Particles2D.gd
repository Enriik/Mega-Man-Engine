extends CPUParticles2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta):
	if get_tree().paused:
		speed_scale = 0
	else:
		speed_scale = 1
