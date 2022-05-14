extends "res://Scripts/Character.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	#var texture = Global.textures[texture_index]
	#$Sprite/Body.texture = load("res://art/rpgsprites1/%s" % texture)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var texture = "warrior_m.png"
	$Sprite/Body.texture = load("res://art/rpgsprites1/%s" % texture)
	if canMove:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				move(dir)
