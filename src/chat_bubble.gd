extends Sprite2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func hide_chat_bubble():
	self.visible = false
	
func show_chat_bubble():
	$ChatBubble.visible = true
	
func hide_desire():
	pass

# TODO: Make the strings into constants?
func pick_desire():
#	TODO: Add more desires
	self.visible = true
	var desire_enum_value = rng.randi_range(1,3)
	match desire_enum_value:
		1:
			$Sun.visible = true
			return "Sun"
		2:
			$Rain.visible = true
			return "Rain"
		3:
			$KindWords.visible = true
			return "KindWords"
			
func provide_desire(given_desire):
	match given_desire:
		"Sun":
			$Sun.visible = false
		"Rain":
			$Rain.visible = false
		"KindWords":
			$KindWords.visible = false
