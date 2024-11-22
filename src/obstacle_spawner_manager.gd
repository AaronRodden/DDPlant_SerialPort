extends Sprite2D

@export var spawner_id= -1
@export var obstacle_direction = "" # right, left, or center
@export var obstacle_level = "" # top, middle, bottom

signal obstacle_spawned

var TARGET_DELTA_X = Vector2(650,0)
var TARGET_DELTA_Y = Vector2(0, 450)

var Obstacle = preload("res://src/obstacle.tscn")

#var obstacle_direction : String # right, left, or center
#var obstacle_level : String # top, middle, bottom, 

# Called when the node enters the scene tree for the first time.
func _ready():
	## NOTE: I am hardcoding this because we have one week to get this done yay!
	match obstacle_level:
		"top": 
			if obstacle_direction == "right":
				create_obstacle("cloud", TARGET_DELTA_X)
			elif obstacle_direction == "left":
				create_obstacle("cloud", TARGET_DELTA_X * -1)
			elif obstacle_direction == "up":
				create_obstacle("cloud", TARGET_DELTA_Y * -1)
			elif obstacle_direction == "down":
				create_obstacle("cloud", TARGET_DELTA_Y)
		"middle":
			if obstacle_direction == "right":
				create_obstacle("wasp", TARGET_DELTA_X)
			elif obstacle_direction == "left":
				create_obstacle("wasp", TARGET_DELTA_X * -1)
			elif obstacle_direction == "up":
				create_obstacle("wasp", TARGET_DELTA_Y * -1)
			elif obstacle_direction == "down":
				create_obstacle("wasp", TARGET_DELTA_Y)
		"bottom":
			if obstacle_direction == "right":
				create_obstacle("fox", TARGET_DELTA_X)
			elif obstacle_direction == "left":
				create_obstacle("fox", TARGET_DELTA_X * -1)
			elif obstacle_direction == "up":
				create_obstacle("fox", TARGET_DELTA_Y * -1)
			elif obstacle_direction == "down":
				create_obstacle("fox", TARGET_DELTA_Y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_obstacle(obstacle_type, target_pos):
	var new_obstacle = Obstacle.instantiate()
	new_obstacle.set_obstacle(obstacle_type, self.obstacle_direction, self.position, target_pos)
	add_child(new_obstacle)
	obstacle_spawned.emit()
