extends EnemyCore

const NOTICE_DISTANCE = 48

export (float) var chain_tile_fall_spd = 120

var alerted : bool

func _process(delta: float) -> void:
	_alert()

func _alert():
	if alerted:
		return
	
	if get_player_distance() < NOTICE_DISTANCE:
		alerted = true
		activate_switch_and_flee()

func activate_switch_and_flee():
	$SpriteMain/Sprite/Anim.play("Activate")
	yield($SpriteMain/Sprite/Anim, "animation_finished")
	$SpriteMain/Sprite/Anim.play("JumpOff")
	yield($SpriteMain/Sprite/Anim, "animation_finished")
	queue_free()

# Make all switches activated
func make_switches_activated():
	get_tree().call_group("MM4Switch", "activate")
	FJ_AudioManager.sfx_combat_crash_bomb.play()
	
	fasten_chain_tilemap()

func fasten_chain_tilemap():
	for i in get_tree().get_nodes_in_group("ChainTilemap"):
		i.fall_speed = chain_tile_fall_spd
