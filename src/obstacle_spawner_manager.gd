extends Sprite2D

@export var spawner_id= -1
@export var obstacle_direction = "" # right, left, or center
@export var obstacle_level = "" # top, middle, bottom

var TARGET_DELTA = Vector2(650,0)

var Obstacle = preload("res://src/obstacle.tscn")

#var obstacle_direction : String # right, left, or center
#var obstacle_level : String # top, middle, bottom, 

# Called when the node enters the scene tree for the first time.
func _ready():
	## NOTE: I am hardcoding this because we have one week to get this done yay!
	match obstacle_level:
		"top": 
			if obstacle_direction == "right":
				create_obstacle("cloud", TARGET_DELTA)
			elif obstacle_direction == "left":
				create_obstacle("cloud", TARGET_DELTA * -1)
			else: 
				create_obstacle("cloud", self.position)
		"middle":
			if obstacle_direction == "right":
				create_obstacle("wasp", TARGET_DELTA)
			elif obstacle_direction == "left":
				create_obstacle("wasp", TARGET_DELTA * -1)
			else: 
				create_obstacle("wasp", self.position)
		"bottom":
			if obstacle_direction == "right":
				create_obstacle("fox", TARGET_DELTA)
			elif obstacle_direction == "left":
				create_obstacle("fox", TARGET_DELTA * -1)
			else: 
				create_obstacle("fox", self.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_obstacle(obstacle_type, target_pos):
	var new_obstacle = Obstacle.instantiate()
	new_obstacle.set_obstacle(obstacle_type, self.obstacle_direction, self.position, target_pos)
	add_child(new_obstacle)
