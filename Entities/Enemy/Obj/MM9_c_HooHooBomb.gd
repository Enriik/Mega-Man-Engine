extends EnemyCore

const BULLET_DAMAGE = 2
const SHADOW_BLADE = preload("res://Entities/Enemy/Obj/MM3_ShadowBladeSmall.tscn")
const BULLET = preload("res://Entities/Enemy/Obj/MM2_Bullet.tscn")

export (PackedScene) var enemy_explosion

onready var bullet_bhv := $BulletBehavior as FJ_BulletBehavior
onready var dmg_area = $DamageArea

func _process(delta: float) -> void:
	if GlobalVariables.touhou:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _physics_process(delta: float) -> void:
	var bodies = dmg_area.get_overlapping_bodies()
	
	for i in bodies:
		if i is TileMap:
			explode()
			return

func explode():
	var en = enemy_explosion.instance()
	get_parent().add_child(en)
	en.global_position = self.global_position
	en.contact_damage = self.contact_damage
	
	FJ_AudioManager.sfx_combat_large_explosion.play()
	
	if GlobalVariables.touhou:
		spread_bullets()
	else:
		split_shadow_blades()
	
	queue_free_start(false)
	return

func split_shadow_blades():
	var angles : Array = [-120, -105, -75, -60]
	
	for i in angles:
		var blt = SHADOW_BLADE.instance()
		get_parent().add_child(blt)
		blt.global_position = self.global_position
		blt.contact_damage = 3
		blt.bullet_behavior.angle_in_degrees = i
		blt.bullet_behavior.gravity = 600
		blt.bullet_behavior.max_fall_speed = 450
		blt.bullet_behavior.speed = 240
		blt.bullet_behavior.acceleration = -120

func spread_bullets():
	if not GlobalVariables.touhou:
		return
	
	var accel = [0, 180]
	var speed = [180, 30]
	var angle_add = [0, 15]
	var angles = 30
	var blt_count = 12
	
	for a in accel.size():
		for blt_c in blt_count:
			var blt = BULLET.instance()
			get_parent().add_child(blt)
			blt.global_position = self.global_position
			blt.contact_damage = 2
			blt.bullet_behavior.angle_in_degrees = blt_c * angles + angle_add[a]
			blt.bullet_behavior.acceleration = accel[a]
			blt.bullet_behavior.speed = speed[a]
