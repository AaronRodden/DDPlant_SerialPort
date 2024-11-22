extends CharacterBody2D

var obstacle_direction : String
# TODO: Pretty simple, have a hurtbox that interacts with obstacles, dissapear when off screen

func set_wind(obstacle_direction):
	self.obstacle_direction = obstacle_direction
	self.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.obstacle_direction == "right":
		self.position.x += 5
	elif self.obstacle_direction == "left":
		self.position.x -= 5
	elif self.obstacle_direction == "up":
		self.position.y -= 5
	elif self.obstacle_direction == "down":
		self.position.y += 5

func _physics_process(delta):
	pass
#	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # If off screne, destroy object


func _on_wind_hitbox_area_entered(area):
	pass # Replace with function body.
