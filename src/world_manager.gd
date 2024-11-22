extends StaticBody2D

## Manager script that handles world organization

@export var world_health = 100 # Health bar out of 100
var obstacle_count = 0
var current_desire = null

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
	
	# TODO: Get these signals connected so game can know when there are obstacles
	# Why does this not work but manual connection does???
#	$ObstacleSpawner2.connect("obstacle_spawned", self.add_obstacle, 0)
#	$ObstacleSpawner3.connect("obstacle_spawned", self.add_obstacle, 0)
#	$ObstacleSpawner5.connect("obstacle_spawned", self.add_obstacle, 0)
#	$ObstacleSpawner6.connect("obstacle_spawned", self.add_obstacle, 0)
#	$ObstacleSpawner8.connect("obstacle_spawned", self.add_obstacle, 0)
#	$ObstacleSpawner9.connect("obstacle_spawned", self.add_obstacle, 0)
#	for N in self.get_children():
#		if N.name.contains("ObstacleSpawner"):
#			print(N.name)
#			print(N.get_path())
#			get_node(N).connect("obstacle_spawned", add_obstacle())
#			N.obstacle_spawned.connect(add_obstacle)

func add_obstacle():
	obstacle_count += 1
	
func subtract_obstacle():
	if obstacle_count == 0:
		return
	obstacle_count -= 1

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
		subtract_obstacle()
	if inputs["CS2"] > 0: 
		$WindSpawner2.create_wind()
		subtract_obstacle()
	if inputs["CS3"] > 0: 
		$WindSpawner3.create_wind()
		subtract_obstacle()
	if inputs["CS4"] > 0: 
		$WindSpawner4.create_wind()
		subtract_obstacle()
	if inputs["CS5"] > 0: 
		$WindSpawner5.create_wind()
		subtract_obstacle()
	if inputs["CS6"] > 0: 
		$WindSpawner6.create_wind()
		subtract_obstacle()
	# TODO: Will some calibration need to be done here?
	if inputs["FS0"] > 0:
		provided_desire = "Sun"
	if inputs["FS1"] > 0:
		provided_desire = "Rain"
	if inputs["FS2"] > 0:
		provided_desire = "KindWords"
	if inputs["FS3"] > 0:
		provided_desire = "Pollenation"
	if inputs["FS4"] > 0:
		provided_desire = "Fertalizer"
	# TODO: This logic here is for MVP, mess around with where this check is / point values?
	if provided_desire.length() > 0:
		if provided_desire == current_desire:
			$ChatBubble.provide_desire(provided_desire)
			current_desire = null
			world_health += 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print($SerialPortTest.last_controller_poll)
#	var test = $SerialPortTest.last_controller_poll
#	pass
#	var inputs = parse_controller_poll($SerialPortTest.last_controller_poll)
#	print(inputs)
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
	
	# Debug data:
#	var inputs = parse_controller_poll("[CS1:0, CS2:1, CS3:0, CS4:1, CS5:0, CS6:1, FS0:872, FS1:959, FS2:924, FS3:916, FS4:951]")
	var inputs = parse_controller_poll(debug_contoller_poll)
	process_inputs(inputs)
	
	print("World Health: " + str(world_health))
	if world_health >= 70:
		$ChatBubble.hide_chat_bubble()
	
	# TODO: Add extra conditional for this
	if obstacle_count == 0 and world_health <= 70:
		if current_desire:
			pass
		else: 
			current_desire = $ChatBubble.pick_desire()
	
func grow_leaves():
	var rng_leaf_enum_value = rng.randi_range(1, 4)
	for node in self.get_children():
		if node.name.contains("Leaf"):
			var new_leaf = node.new_leaf(1, node.position, node.rotation)
			add_child(new_leaf)


# TODO: Hacky because normal singal connection isnt working??
func _on_obstacle_spawner_2_obstacle_spawned():
	add_obstacle()
	world_health -= 10
	
func _on_obstacle_spawner_3_obstacle_spawned():
	add_obstacle()
	world_health -= 10

func _on_obstacle_spawner_5_obstacle_spawned():
	add_obstacle()
	world_health -= 10

func _on_obstacle_spawner_6_obstacle_spawned():
	add_obstacle()
	world_health -= 10

func _on_obstacle_spawner_8_obstacle_spawned():
	add_obstacle()
	world_health -= 10

func _on_obstacle_spawner_9_obstacle_spawned():
	add_obstacle()
	world_health -= 10
