# Tool Properties Modifier (Tool Script)
# Written by: First

tool
extends Node

"""
	Tool Properties Modifier เป็นเครื่องมือตัวช่วยในการเปลี่ยนค่า
	properties ในกลุ่ม children จาก root node
	ใช้ในกรณีเคสที่บางครั้งเราอาจไม่สามารถแก้ property ทั้งกลุ่มได้
	เช่น ทำ multinode set NodePath แต่กลายเป็นว่ามันไม่ได้ Assign ให้
	และเนื่องด้วยมันเป็นบัคของ Godot ที่หลีกเลี่ยงไม่ได้
	
	วิธีใช้คือ เรากำหนด root node (default path เป็น ../) เพื่อที่
	จะเรียก children ทั้งหมดมาประมวลผล จากนั้น เราจะต้องกำหนดทั้งสอง
	property ด้วยกัน คือ 'property_name' และ 'property_value'
	
	ความพิเศษของเครื่องมือนี้ คือ ในการเปลี่ยนแปลง property
	ของแต่ละโหนด เราสามารถกำหนดเงื่อนไขเพิ่มเติมได้ เช่น
	query ชื่อตาม simple expression match ที่เรากำหนด หรือเป็นแบบ
	wildcard patterns.
	
	เมื่อพร้อมที่จะ process แล้วให้เลือก property 'Run'
	
	- ข้อจำกัด -
	การใช้เครื่องมือนี้รัน เพื่อเปลี่ยนแปลง property บนโหนดต่างๆ
	จะไม่สามารถยกเลิกการกระทำได้ (one time use, can't undo)
	ข้อแนะนำคือให้เซฟ (save) ก่อนทำ
"""

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const _ERR_PROPERTY_NAME_NULL = "Property name is null!"
const _ERR_PROPERTY_VALUE_NULL = "Property value is null!"
const _ERR_PROPERTY_VALUE_EMPTY = "Property value is empty!"
const _ERR_ROOT_NODE_NULL = "Root node is not defined!"


#-------------------------------------------------
#      Properties
#-------------------------------------------------

#Path to begin executing property changes.
export (NodePath) var root_node = "../"

#Target property name
export (String) var property_name

#Property value to be set on property name.
#Note that only the first index is used. Size doesn't matter.
export (Array) var property_value : Array

#Condition: Does a simple expression match by node's name.
#Leave empty for no condition.
export (String) var cond_node_name_expr : String

#Used by node name's condition.
#When true, it ignores lowercase-uppercase.
export (bool) var use_insensitive_expr

#Run command. Will begin execute change to all of the children
#properties. Printing result when execution is completed.
export (bool) var run setget _set_run



#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func set_all_children_properties():
	if property_name == null:
		push_error(self.name + ": " + _ERR_PROPERTY_NAME_NULL)
		return
	if property_value == null:
		push_error(self.name + ": " + _ERR_PROPERTY_VALUE_NULL)
		return
	if property_value.empty():
		push_error(self.name + ": " + _ERR_PROPERTY_VALUE_EMPTY)
		return
	if root_node == null:
		push_error(self.name + ": " + _ERR_ROOT_NODE_NULL)
		return
	
	#This is kept for sending the results to stdout.
	var _processed_data : PoolStringArray
	
	#Children from the target root node you set.
	var children = get_node(root_node).get_children()
	
	#Iterate through children (not including self).
	for i in children:
		if not i is Node:
			continue
		if i == self:
			continue
		
		#If the condition of node name expression is specified,
		#we will select only the node with a matching name.
		if not cond_node_name_expr.empty():
			#Insensitive simple expression match.
			if use_insensitive_expr:
				if not i.name.matchn(cond_node_name_expr):
					continue
			#Or, sensitive simple expression match.
			if not use_insensitive_expr:
				if not i.name.match(cond_node_name_expr):
					continue
		
		#Get previous property value. Used in result sent to stdout.
		var _previous_property_value = i.get(property_name)
		i.set(property_name, property_value[0])
		_processed_data.append(
			str(
				i.name,
				": Modified ",
				property_name,
				"   ",
				_previous_property_value,
				" -> ",
				property_value[0]
			)
		)
	
	#Size - 1 means this object won't be included.
	_os_alert_query_result(_processed_data, children.size() - 1)




#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _os_alert_query_result(data_string_array : PoolStringArray, total : int) -> void:
	print(str(
		"Query result: ",
		data_string_array.size(),
		" out of ",
		total,
		"node(s) updated.\n",
		data_string_array.join("\n")
	))
	
	OS.alert(str(
	data_string_array.size(),
	" out of ",
	total,
	" node(s) has been updated. The data has been sent to stdout."
	), "Query Result")


#-------------------------------------------------
#      Setters & Getters
#-------------------------------------------------

func _set_run(val):
	if val == true:
		set_all_children_properties()
