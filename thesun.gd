extends AnimatedSprite2D

@export var speed = 500
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("debug_test_fsr_1"):
		get_node("asdf").play("change")
	pass
