extends Sprite2D

@export var spawner_id= -1
@export var wind_direction = ""

var WIND_BUFFER_TIME = 2

var Wind = preload("res://src/wind.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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
