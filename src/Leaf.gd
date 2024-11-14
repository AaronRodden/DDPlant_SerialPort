class_name Leaf
extends Sprite2D

# TODO: Turn these into growing animations on initilization 
var mapleleaf_path = "res://assets/mapleleaf_papercraft.png"
var orangeleaf_path = "res://assets/orangeleaf_papercraft.png"
var greenleaf_path = "res://assets/greenleaf_papercraft.png"
var bendleaf_white_path = "res://assets/bendleaf_white_papercraft.png"

var texture_path = "";

#func new_spell_input_ui(spell_input: String):
#	var new_spell_input_ui = SpellInputUI.new()
#	new_spell_input_ui.spell_texture = spell_input
#	new_spell_input_ui.h_offset = h_offset
#	h_offset += 75
#	return new_spell_input_ui

# Leaf constructor
func new_leaf(leaf_enum_value, leaf_position, leaf_rotation):
	var new_leaf = Leaf.new()
	match leaf_enum_value:
		1: 
			new_leaf.texture_path = mapleleaf_path
		2:
			new_leaf.texture_path = orangeleaf_path
		3:
			new_leaf.texture_path = greenleaf_path
		4:
			new_leaf.texture_path = bendleaf_white_path
	new_leaf.position = leaf_position
	new_leaf.rotation = leaf_rotation
	return new_leaf

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = load(texture_path)
	self.scale.x = 0.08 # TODO: Scale magic number here...
	self.scale.y = 0.08 # TODO: Scale magic number here...
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
