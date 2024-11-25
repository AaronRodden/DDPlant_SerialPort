extends CharacterBody2D


# TODO: I think these should be replaced by animations at some point 
var cloud_path = "res://assets/weather_icon_set/cloudyWeather.png"
var wasp_path = "res://assets/wasp_frames/wasp1_00000.png"
var fox_path = "res://assets/isometric_snake/iso-snake-yellow 1.png"

#var bee_ = preload("res://animations/maple_leaf_animation.tscn")
var fox_animation_path = preload("res://animations/fox_animation.tscn")

var texture_path : String
var obstacle_direction : String
var starting_position : Vector2
var target_position : Vector2

# Obstacle constructor
func set_obstacle(obstacle_type, obstacle_direction, obstacle_starting_position, obstacle_target_position):
	match obstacle_type:
		"cloud":
			texture_path = cloud_path
		"wasp":
#			texture_path = wasp_path
			$BeeAnimation.visible = true
		"fox":
#			texture_path = fox_path
			$FoxAnimation.visible = true
#	self.texture = load(texture_path)
#	$ObstacleSprite.texture = load(texture_path)
	self.obstacle_direction = obstacle_direction
	self.starting_position = obstacle_starting_position
	self.target_position = obstacle_target_position
	self.z_index = 1
	self.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.obstacle_direction == "right":
		if self.position >= self.target_position:
			return 
		self.position.x += 5
	elif self.obstacle_direction == "left":
		if self.position <= self.target_position:
			return 
		self.position.x -= 5
	elif self.obstacle_direction == "up":
		if self.position <= self.target_position:
			return 
		self.position.y -= 5
	elif self.obstacle_direction == "down":
		if self.position >= self.target_position:
			return 
		self.position.y += 5
			

func _physics_process(delta):
	move_and_slide()

func _on_obstacle_hitbox_area_entered(area):
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	Global.obstacle_count -= 1
