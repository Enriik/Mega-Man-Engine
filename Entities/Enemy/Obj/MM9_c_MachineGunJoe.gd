extends EnemyCore

export(PackedScene) var shoot_projectile
export(float) var attack_range = 130

#Child nodes
onready var joe_animation = $SpriteMain/Sprite/JoeAnimation
onready var platformer_behavior = $PlatformBehavior
onready var fire_bullet = $SpriteMain/FireBullet
onready var attack_cooldown_timer = $AttackCooldownTimer
onready var projectile_reflector = $SpriteMain/ShieldArea2D/ProjectileReflector

#Temp
var is_attack_ready : bool = false
var is_attacking : bool = false

func _ready() -> void:
	if player == null:
		push_warning(str(self.name, ": Player was not found. Stopping AI."))

func _process(delta: float) -> void:
	if player != null:
		var actual_player = player as Player
		
		if within_player_range(attack_range) && is_attack_ready:
			if randi() % 10 < 4:
				joe_animation.play("Jump")
				platformer_behavior.jump_start()
			else:
				joe_animation.play("Shoot")
			is_attack_ready = false
			is_attacking = true

func fire():
	if GlobalVariables.touhou:
		var angles = [75, 70, 65, 60, 55, 50, 45, 40, 35, 30, 25, -75, -70, -65, -60, -55, -50, -45, -40, -35, -30, -25]
		var speeds = [240, 300]
		
		for s in speeds:
			for a in angles:
				var bullet = shoot_projectile.instance()
				get_parent().add_child(bullet)
				bullet.global_position = fire_bullet.global_position
				if bullet.has_node("BulletBehavior"):
					bullet.bullet_behavior.angle_in_degrees = 0 if sprite_main.scale.x == -1 else 180
				
				bullet.bullet_behavior.angle_in_degrees += a
				bullet.bullet_behavior.speed = s
		
		FJ_AudioManager.sfx_combat_blues_shot.play()
	else:
		var bullet = shoot_projectile.instance()
		get_parent().add_child(bullet)
		bullet.global_position = fire_bullet.global_position
		if bullet.has_node("BulletBehavior"):
			bullet.bullet_behavior.angle_in_degrees = 0 if sprite_main.scale.x == -1 else 180
		
		FJ_AudioManager.sfx_combat_shot.play()

func _on_AttackedCooldownTimer_timeout() -> void:
	is_attack_ready = true

func attack_done():
	standby()

func standby():
	attack_cooldown_timer.start()
	joe_animation.play("Idle")
	is_attacking = false
	projectile_reflector.enabled = true

#Turn towards player while not shooting.
func _on_PointTowardPlayerInterval_timeout() -> void:
	turn_toward_player()

func _on_PlatformerBehavior_landed() -> void:
	if joe_animation.current_animation == "Jump":
		standby()
