extends Sprite2D

var rng = RandomNumberGenerator.new()

var current_desire

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.obstacle_count == 0 and Global.world_health <= 70:
		if current_desire:
			pass
		else: 
			pick_desire()
	

# TODO: Make the strings into constants?
func pick_desire():
#	TODO: Add more desires
	$ThoughtBubble.visible = true
	var desire_enum_value = rng.randi_range(1,3)
	match desire_enum_value:
		1:
			$Sun.visible = true
			current_desire = "Sun"
		2:
			$Rain.visible = true
			current_desire = "Rain"
		3:
			$Frown.visible = true
			current_desire = "KindWords"

func send_desire(provided_desire):
	if provided_desire == current_desire:
			provide_desire(provided_desire)
			Global.world_health += 20

func provide_desire(given_desire):
	$ThoughtBubble.visible = true
	match given_desire:
		"Sun":
			$Sun.visible = false
		"Rain":
			$Rain.visible = false
		"KindWords":
			$Frown.visible = false
			
	$ThoughtBubble.visible = false
	$ExcitmentAnimation.visible = true
	$ExcitmentAnimation.play()
	await get_tree().create_timer(2).timeout
	$ExcitmentAnimation.visible = false
	if Global.world_health <= 70:
		pick_desire()
	else:
		current_desire = null
		$ThoughtBubble.visible = false
		$Smile.visible = true
		await get_tree().create_timer(2).timeout
		$Smile.visible = false
