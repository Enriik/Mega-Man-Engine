extends PlayerProjectile

var state : int
var projectile_owner : Node2D
var destroy_distance_owner = 4
var pickups_grab_range = 16

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if state == 1:
		if not Input.is_action_pressed("game_action"):
			bullet_behavior.active = true
			state = 2
	elif state == 2:
		var ag = self.global_position.angle_to_point(projectile_owner.global_position)
		bullet_behavior.angle_in_degrees = rad2deg(ag) - 180
		
		if self.global_position.distance_to(projectile_owner.global_position) < destroy_distance_owner:
			queue_free()
	
	grab_pickups()

func _on_FireDurationTimer_timeout() -> void:
	bullet_behavior.active = false
	state = 1
	$HoldAmmoConsumeInterval.start()

func _on_HoldAmmoConsumeInterval_timeout() -> void:
	if state != 1:
		return
	
	if GameHUD.player_weapon_bar.frame > 0:
		GameHUD.player_weapon_bar.frame -= 1
	else:
		bullet_behavior.active = true
		state = 2

func grab_pickups():
	for i in get_tree().get_nodes_in_group("Pickups"):
		i = i as Node2D
		
		if global_position.distance_to(i.global_position) < pickups_grab_range:
			i.global_position = global_position
