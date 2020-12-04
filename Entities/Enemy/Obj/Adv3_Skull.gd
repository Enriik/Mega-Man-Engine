extends EnemyCore

const bullet = preload("res://Entities/Enemy/Obj/Adv3_Bullet.tscn")

export (int) var number_of_fireball = 2

var flameburst_fireball = preload("res://Entities/Enemy/Obj/MM6_FlameBurstFireball.tscn")

func _on_Skull_taken_damage(value, target, player_proj_source) -> void:
	return
	
	for i in number_of_fireball:
		var fireball
		
		fireball = flameburst_fireball.instance()
		get_parent().add_child(fireball)
		fireball.global_position = global_position
		fireball.bullet_behavior.angle_in_degrees = rand_range(-200, -90)
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").primary_sprite.modulate = NESColorPalette.LIGHTSALMON4
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").second_sprite.modulate = NESColorPalette.TOMATO3
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").outline_sprite.modulate = NESColorPalette.BLACK1
		
		fireball = flameburst_fireball.instance()
		get_parent().add_child(fireball)
		fireball.global_position = global_position
		fireball.bullet_behavior.angle_in_degrees = rand_range(-90, 20)
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").primary_sprite.modulate = NESColorPalette.LIGHTSALMON4
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").second_sprite.modulate = NESColorPalette.TOMATO3
		fireball.get_node("SpriteMain/Sprite/PaletteSprite").outline_sprite.modulate = NESColorPalette.BLACK1
		


func _on_ShootTimer_timeout() -> void:
	var blt = bullet.instance()
	get_parent().add_child(blt)
	blt.global_position = global_position
	var ag = global_position.angle_to_point(player.global_position)
	blt.bullet_behavior.angle_in_degrees = rad2deg(ag)
	blt.bullet_behavior.speed = 120
	
	FJ_AudioManager.sfx_combat_shot.play()
