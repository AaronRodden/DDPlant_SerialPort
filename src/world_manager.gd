extends StaticBody2D

## Manager script that handles world organization

var Leaf = preload("res://src/leaf.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
# Set's up the game world on first startup
func _ready():
	grow_leaves()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func grow_leaves():
	var rng_leaf_enum_value = rng.randi_range(1, 4)
	for node in self.get_children():
		if node.name.contains("Leaf"):
			var new_leaf = node.new_leaf(rng_leaf_enum_value, node.position, node.rotation)
			add_child(new_leaf)
