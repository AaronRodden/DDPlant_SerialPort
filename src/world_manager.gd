extends StaticBody2D

## Manager script that handles world organization

#var obstacle_count = 0
var current_desire = null

var Leaf = preload("res://src/leaf.tscn")

var rng = RandomNumberGenerator.new()
var regex = RegEx.new()
var conductive_sensor_regex = "CS\\d:(\\d+)"
var force_sensor_regex = "FS\\d:(\\d+)"
var motion_sensor_regex = "MS\\d:(\\d+)"

var CONDUCTIVE_SENSOR_COUNT = 6
var FORSE_SENSOR_COUNT = 5

# TODO: Final Stretch 11/23/24
# 2. Responsive tree / health bar
# 3. More leaves / animations for them blowing off
# 4. Animation and papercraft sprites

# Called when the node enters the scene tree for the first time.
# Set's up the game world on first startup
func _ready():
	grow_leaves()
	

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
			regex.compile(sensor_index + ":(\\d+)")
			var regex_result = regex.search(controller_poll)
			parsed_inputs[sensor_index] = int(regex_result.get_string(1))
	return parsed_inputs

func process_inputs(inputs):
	var provided_desire = ""
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
	if inputs["FS0"] > 50:
		provided_desire = "Sun"
	if inputs["FS1"] > 50:
		provided_desire = "Rain"
	if inputs["FS2"] > 50:
		provided_desire = "KindWords"
	if inputs["FS3"] > 50:
		provided_desire = "Pollenation"
	if inputs["FS4"] > 50:
		provided_desire = "Fertalizer"
	# TODO: This logic here is for MVP, mess around with where this check is / point values?
	if provided_desire.length() > 0:
		$ChatBubble.send_desire(provided_desire)
#		if provided_desire == current_desire:
#			$ChatBubble.provide_desire(provided_desire)
#			current_desire = null
#			Global.world_health += 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Debug: Faked user input
	var debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	# Capacitive sensor debug inputs
	if Input.is_action_just_pressed("CS1"):
		debug_contoller_poll = "[CS1:1, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("CS2"):
		debug_contoller_poll = "[CS1:0, CS2:1, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("CS3"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:1, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("CS4"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:1, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("CS5"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:1, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("CS6"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:1, FS0:0, FS1:0, FS2:0, FS3:0, FS4:0]"
	# Force Sensor debug inputs
	if Input.is_action_just_pressed("FS0"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:200, FS1:0, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("FS1"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:200, FS2:0, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("FS2"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:200, FS3:0, FS4:0]"
	if Input.is_action_just_pressed("FS3"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:200, FS4:0]"
	if Input.is_action_just_pressed("FS4"):
		debug_contoller_poll = "[CS1:0, CS2:0, CS3:0, CS4:0, CS5:0, CS6:0, FS0:0, FS1:0, FS2:0, FS3:0, FS4:200]"
	var inputs = parse_controller_poll(debug_contoller_poll)
	process_inputs(inputs)

	# Debug: Wizard of Oz individual inputs
#	if Input.is_action_just_pressed("spawn1"):
#		$ObstacleSpawner2.spawn_obstacle()
#	if Input.is_action_just_pressed("spawn2"):
#		$ObstacleSpawner3.spawn_obstacle()
#	if Input.is_action_just_pressed("spawn3"):
#		$ObstacleSpawner5.spawn_obstacle()
#	if Input.is_action_just_pressed("spawn4"):
#		$ObstacleSpawner6.spawn_obstacle()
#	if Input.is_action_just_pressed("spawn5"):
#		$ObstacleSpawner8.spawn_obstacle()
#	if Input.is_action_just_pressed("spawn6"):
#		$ObstacleSpawner9.spawn_obstacle()
		
	if Input.is_action_just_pressed("motion_sensor_oz"):
		motion_detected_oz()
	
	# 
#	var inputs = parse_controller_poll($SerialPortTest.last_controller_poll)
#	print(inputs)
#	process_inputs(inputs)
	
	# Debug: Global variable output
	print("World Health: " + str(Global.world_health))
	print("Obstacle Count: " + str(Global.obstacle_count))
	
func grow_leaves():
	var rng_leaf_enum_value = rng.randi_range(1, 4)
	for node in self.get_children():
		if node.name.contains("Leaf"):
			var new_leaf = node.new_leaf(rng_leaf_enum_value, node.position, node.rotation)
			add_child(new_leaf)
			
			
func motion_detected_oz():
	var concurrent_spawn_tracker = []
	var spawner_string
	for i in range(0,3):
		# TODO: This is a hack to get around a bug!
		# The bug involves two obstacles spawning at the same time and pushing each other around.
		while true:
			var spawner_id = randi_range(1,9)
			if spawner_id not in concurrent_spawn_tracker:
				concurrent_spawn_tracker.append(spawner_id)
				spawner_string = "ObstacleSpawner" + str(spawner_id)
				break
		get_node(spawner_string).spawn_obstacle()
			
