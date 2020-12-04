extends EnemyCore

export (float) var attack_range = 96

onready var pf_bhv = $PlatformBehavior
onready var attack_timer = $AttackTimer
onready var turn_towards_timer = $TurnTowardsTimer
onready var sprite_ani = $SpriteMain/Ani

var is_attack_ready = true
var is_noticed : bool

func _process(delta):
	if (within_player_range(attack_range) or is_noticed) and is_attack_ready:
		pf_bhv.jump_start()
		is_attack_ready = false
		is_noticed = true
	
	if is_on_floor():
		sprite_ani.play("Idle")
		pf_bhv.simulate_walk_left = false
		pf_bhv.simulate_walk_right = false
	else:
		sprite_ani.play("Jump")
		
		if $SpriteMain.scale.x == 1:
			pf_bhv.simulate_walk_left = true
			pf_bhv.simulate_walk_right = false
		else:
			pf_bhv.simulate_walk_left = false
			pf_bhv.simulate_walk_right = true
			
	
	

func _on_PlatformBehavior_landed():
	attack_timer.start()


func _on_AttackTimer_timeout():
	is_attack_ready = true


func _on_TurnTowardsTimer_timeout():
	turn_toward_player()
