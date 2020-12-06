#Sprite Cycling
#Code by: First

#Sprite Cycling turns all children within the parent node
#to draw sprites in forward order one frame and
#backward order the next when two sprites are
#overlapping each other.

# USE CASES:
#   There are two items with similiar image size
#   that are overlapping at the same spot, which
#   makes either item A or B can barely be seen.
#   How about if we swap both item A and B
#   cycling back and forth so some part of their
#   sprites can be seen? Wouldn't be that great
#   to not confusing player with item A is
#   being hidden by item B? This is called
#   "Faking Transparency".

# USAGE: Can be used anywhere. Place it within the parent node.
# Example:
#
# Root
# ┖╴Node2D
#   ┠╴Iterable
#   ┠╴Sprite          <- Affects by iterable.
#   ┠╴Kinematic2d     <- Affects by iterable.
#   ┠╴Label           <- No effect.
#   ┖╴Node2D          <- Affects by iterable.  
#     ┠╴Label          <- No effect, but affected to parent.
#     ┖╴Sprite         <- No effect, but affected to parent.
#
# COMPATIBILITY: Node2D

#tool #Remove this line if you do not wish this script to work in the editor.
extends Node
class_name Iterable

export(bool) var enabled = true
export(Array, int) var frames_per_iterate = [0] #Array length should be power of n. e.g. 1, 2, 4, or 8, ..
												#this will wait for n frames before iterate starts.
												#there is a pointer that will move to the next of an array
												#once iteration is done in said frame.
var z_swapping = 0 #Increment every frames. Resets on reaching frames_per_iterate[pointer]
var pointer = 0 #Pointer on array of frames_per_iterate
var swap_mode = 0 #0 = no iterate, other than 0 = iterate

const MAX_LOOPABLE = 32
var current_loop = 0

const MAX_SPRITE_DRAW_COUNT = 16
var draw_idx = 0

func _process(delta : float) -> void:
	if !GameSettings.gameplay.sprite_flicker:
		return
	if !enabled:
		return
	
	var children = get_parent().get_children()
	var drawable_children : Array = []
	var it = children.size()
	var sprite_drawn = 0
	current_loop = 0
	
	for i in children:
		if(swap_mode == 0):
			it += 1
		else:
			it -= 1
		if "z_index" in i: #Safe call
			i.z_index = it
	
#	#Omit children where it is not drawable
#	for i in children:
#		if not is_instance_valid(i):
#			continue
#		if i is Node2D or i is Control:
#			drawable_children.append(i)
#			continue
#
#	#Set hide all sprites
#	for i in drawable_children:
#		if i is Node2D or i is Control:
#			i.visible = false
#
#	for i in drawable_children.size():
#		var wraped_draw_idx = wrapi(i + draw_idx, 0, drawable_children.size())
#		
#		if not is_instance_valid(drawable_children[wraped_draw_idx]):
#			continue
#		if sprite_drawn >= MAX_SPRITE_DRAW_COUNT:
#			continue
#		
#		drawable_children[wraped_draw_idx].visible = true
#		sprite_drawn += 1
#		
#		draw_idx += sprite_drawn
	
#	if children != null:
#		if swap_mode == 0:
#			for i in children:
#				if i is Node2D or i is Control:
#					if current_loop < MAX_LOOPABLE:
#						i.visible = true
#					else:
#						i.visible = false
#					current_loop += 1
#		else:
#			for i in range(children.size() -1, -1, -1):
#				if children[i] is Node2D or children[i] is Control:
#					if current_loop < MAX_LOOPABLE:
#						children[i].visible = true
#					else:
#						children[i].visible = false
#					current_loop += 1
#	
#	if current_loop >= MAX_LOOPABLE * 1.5:
#		Engine.set_time_scale(0.6)
#	else:
#		Engine.set_time_scale(1)
	
	if(z_swapping >= frames_per_iterate[pointer]):
		z_swapping = 0
		modify_swap_mode()
		pointer = move_pointer(pointer, frames_per_iterate)
	else:
		z_swapping += 1

func modify_swap_mode():
	swap_mode = int(!bool(swap_mode))

func move_pointer(var which_pointer : int, var which_array : Array):
	if which_pointer >= which_array.size() - 1:
		which_pointer = 0
	else:
		which_pointer += 1
	
	return which_pointer
