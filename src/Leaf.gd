class_name Leaf
extends Sprite2D

# TODO: Turn these into growing animations on initilization 
var mapleleaf_path = "res://assets/mapleleaf_papercraft.svg"
var orangeleaf_path = "res://assets/orangeleaf_papercraft.svg"
var greenleaf_path = "res://assets/greenleaf_papercraft.svg"
var bendleaf_white_path = "res://assets/bendleaf_white_papercraft.svg"

var mapleleaf_animation_path = preload("res://animations/maple_leaf_animation.tscn")
var orangeleaf_animation_path = preload("res://animations/orange_leaf_animation.tscn")
var greenleaf_animation_path = preload("res://animations/green_leaf_animation.tscn")
var bendleaf_white_animation_path = preload("res://animations/bend_leaf_animation.tscn")

var rng = RandomNumberGenerator.new()

var texture_path = ""
var velocity = Vector2(0, 0)
var fall_flag = false
var speed = 50

# Leaf constructor
func new_leaf(leaf_enum_value, leaf_position, leaf_rotation):
	var new_leaf = Leaf.new()
	match leaf_enum_value:
		1: 
#			new_leaf.texture_path = mapleleaf_path
			new_leaf = mapleleaf_animation_path.instantiate()
		2:
#			new_leaf.texture_path = orangeleaf_path
			new_leaf = orangeleaf_animation_path.instantiate()
		3:
#			new_leaf.texture_path = greenleaf_path
			new_leaf = greenleaf_animation_path.instantiate()
		4:
#			new_leaf.texture_path = bendleaf_white_path
#			new_leaf.animation = load(bendleaf_white_animation_path)
			new_leaf = bendleaf_white_animation_path.instantiate()
	var rand_scale = rng.randf_range(0.13, 0.18)
	new_leaf.scale.x = rand_scale
	new_leaf.scale.y = rand_scale
	new_leaf.position = leaf_position
	new_leaf.rotation = leaf_rotation
	new_leaf.name = "spawned_leaf"
	return new_leaf
	
#func leaf_fall():
#	var starting_position = self.position
#	var sway_value = randi_range(50, 150)
#	var gravity_delta = 15
#	var direction_constant = 1
#
#	var max_sway_negative = starting_position.x - sway_value
#	var max_sway_posative = starting_position.x + sway_value
#	fall_flag = true
#	while true:
##		self.position.x = self.position.x + sway_value 
##		self.position.y = self.position.y + gravity_delta
#		velocity.x = (self.position.x + sway_value) * direction_constant
#		velocity.y =  self.position.y + gravity_delta
#		await get_tree().create_timer(0.5).timeout
#		if self.position.x >= max_sway_posative:
#			direction_constant *= -1
#		if self.position.x <= max_sway_negative:
#			direction_constant *= -1
		

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.texture = load(texture_path)
	self.scale.x = 0.15 # TODO: Scale magic number here...
	self.scale.y = 0.15 # TODO: Scale magic number here...
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.`
func _process(delta):
	pass
	if fall_flag:
		velocity.x += velocity.x
		velocity.y += velocity.y
		velocity = velocity.normalized() * speed
		position += velocity * delta
#	self.rotation = rad_to_deg(0)
#	await get_tree().create_timer(0.5).timeout
#	self.rotation = rad_to_deg(-15) 
#	await get_tree().create_timer(0.5).timeout
#	self.rotation = rad_to_deg(0)
#	await get_tree().create_timer(0.5).timeout
#	self.rotation = rad_to_deg(15)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
