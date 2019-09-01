extends Node
class_name Gun

export (float) var reload_speed setget set_reload_speed, get_reload_speed
export (int) var total_ammo setget set_total_ammo, get_total_ammo
var current_ammo

# Constructor
func _init():
	reload_speed = 1.0
	total_ammo = 6
	current_ammo = total_ammo

# Getters / Setters

func set_reload_speed(reload_speed : float) -> void:
	self.reload_speed = reload_speed
	
func get_reload_speed() -> float:
	return self.reload_speed

func set_total_ammo(total_ammo : int) -> void:
	self.total_ammo = total_ammo

func get_total_ammo() -> int:
	return self.total_ammo