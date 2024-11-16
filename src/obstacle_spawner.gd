extends Sprite2D

@export var spawner_id= -1

var Obstacle = preload("res://src/obstacle.tscn")

var obstacle_direction : String # right, left, or center
var obstacle_level : String # top, middle, bottom, 

#NOTE: This is both an 

# Called when the node enters the scene tree for the first time.
func _ready():
	## NOTE: I am hardcoding this because we have one week to get this done yay!
	match spawner_id:
		1: 
			obstacle_direction = "right"
			obstacle_level = "top"
			create_obstacle("cloud")
		2: 
			obstacle_direction = "right"
			obstacle_level = "middle"
			create_obstacle("wasp")
		3:
			obstacle_direction = "right"
			obstacle_level = "bottom"
			create_obstacle("fox")
		4: 
			obstacle_direction = "center"
			obstacle_level = "top"
			create_obstacle("cloud")
		5: 
			obstacle_direction = "center"
			obstacle_level = "middle"
			create_obstacle("wasp")
		6:
			obstacle_direction = "center"
			obstacle_level = "bottom"
			create_obstacle("fox")
		7: 
			obstacle_direction = "left"
			obstacle_level = "top"
			create_obstacle("cloud")
		8: 
			obstacle_direction = "left"
			obstacle_level = "middle"
			create_obstacle("wasp")
		9:
			obstacle_direction = "left"
			obstacle_level = "bottom"
			create_obstacle("fox")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_obstacle(obstacle_type):
	var new_obstacle = Obstacle.instantiate()
	new_obstacle.set_obstacle(obstacle_type, self.obstacle_direction, self.position, Vector2(0,0))
	add_child(new_obstacle)
