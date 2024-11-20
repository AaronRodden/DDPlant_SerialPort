extends Sprite2D

@export var spawner_id= -1
@export var wind_direction = ""

var WIND_BUFFER_TIME = 2

var Wind = preload("res://src/wind.tscn")


# TODO: Pretty similar to the obstacle spawner, use ID's to know which direction to shoot the wind
# Should there be a manager that is a middle man to this for controls or should world just interact directly?


# Called when the node enters the scene tree for the first time.
func _ready():
	## NOTE: I am hardcoding this because we have one week to get this done yay!
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_wind():
	if $WindTimer.time_left <= 0:
		var new_wind = Wind.instantiate()
		new_wind.set_wind(self.wind_direction)
		add_child(new_wind)
		$WindTimer.wait_time = WIND_BUFFER_TIME
		$WindTimer.one_shot = true
		$WindTimer.start()
