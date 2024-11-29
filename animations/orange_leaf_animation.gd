extends AnimatedSprite2D

var velocity = Vector2(0, 0)
var fall_flag = false
var speed = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func leaf_fall():
	var starting_position = self.position
	var sway_value = randi_range(50, 150)
	var gravity_delta = 15
	var direction_constant = 1

	var max_sway_negative = starting_position.x - sway_value
	var max_sway_posative = starting_position.x + sway_value
	fall_flag = true
	while true:
		velocity.x = (self.position.x + sway_value) * direction_constant
		velocity.y =  self.position.y + gravity_delta
		await get_tree().create_timer(0.5).timeout
		if self.position.x >= max_sway_posative:
			direction_constant *= -1
		if self.position.x <= max_sway_negative:
			direction_constant *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fall_flag:
		velocity.x += velocity.x
		velocity.y += velocity.y
		velocity = velocity.normalized() * speed
		position += velocity * delta
