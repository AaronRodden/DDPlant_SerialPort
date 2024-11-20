extends StaticBody2D

## Manager script that handles world organization

@export var world_health = 100 # Health bar out of 100

var Leaf = preload("res://src/leaf.tscn")

var rng = RandomNumberGenerator.new()
var regex = RegEx.new()
var conductive_sensor_regex = "CS\\d:(\\d+)"
var force_sensor_regex = "FS\\d:(\\d+)"
var motion_sensor_regex = "MS\\d:(\\d+)"

var CONDUCTIVE_SENSOR_COUNT = 6
var FORSE_SENSOR_COUNT = 5

# Called when the node enters the scene tree for the first time.
# Set's up the game world on first startup
func _ready():
	grow_leaves()

# [CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:1, FS0:872, FS1:959, FS2:924, FS3:916, FS4:951]
func parse_controller_poll(controller_poll):
	var parsed_inputs = {}
	if controller_poll:
		for i in range(1, CONDUCTIVE_SENSOR_COUNT + 1):
			var sensor_index = "CS" + str(i)
			regex.compile(sensor_index + ":(\\d+)")
			var regex_result = regex.search(controller_poll)
			parsed_inputs[sensor_index] = int(regex_result.get_string(1))
		for i in range(0, FORSE_SENSOR_COUNT):
			var sensor_index = "FS" + str(i)
			regex.compile(force_sensor_regex)
			var regex_result = regex.search(controller_poll)
			parsed_inputs[sensor_index] = int(regex_result.get_string(1))
	return parsed_inputs

func process_inputs(inputs):
	if inputs.keys().size() == 0:
		return
	if inputs["CS1"] > 0: 
		$WindSpawner1.create_wind()
	if inputs["CS2"] > 0: 
		$WindSpawner2.create_wind()
	if inputs["CS3"] > 0: 
		$WindSpawner3.create_wind()
	if inputs["CS4"] > 0: 
		$WindSpawner4.create_wind()
	if inputs["CS5"] > 0: 
		$WindSpawner5.create_wind()
	if inputs["CS6"] > 0: 
		$WindSpawner6.create_wind()
	# TODO: Will some calibration need to be done here?
	if inputs["FS0"] > 0:
		pass
	if inputs["FS1"] > 0:
		pass
	if inputs["FS2"] > 0:
		pass
	if inputs["FS3"] > 0:
		pass
	if inputs["FS4"] > 0:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print($SerialPortTest.last_controller_poll)
#	var test = $SerialPortTest.last_controller_poll
#	pass
	var inputs = parse_controller_poll($SerialPortTest.last_controller_poll)
	print(inputs)
	# Debug data:
#	var inputs = parse_controller_poll("[CS1:0, CS2:1, CS3:0, CS4:1, CS5:0, CS6:1, FS0:872, FS1:959, FS2:924, FS3:916, FS4:951]")
	process_inputs(inputs)
	
	
func grow_leaves():
	var rng_leaf_enum_value = rng.randi_range(1, 4)
	for node in self.get_children():
		if node.name.contains("Leaf"):
			var new_leaf = node.new_leaf(1, node.position, node.rotation)
			add_child(new_leaf)
