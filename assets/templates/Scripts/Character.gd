extends Node2D

# Declare member variables here. Examples:
export (PackedScene) var combat_actor
export (int) var texture_index
var tileSize = 32
var canMove = true
var facing = 'right'
var moves = {'right': Vector2(1,0),
			 'left': Vector2(-1,0),
			 'up': Vector2(0,-1),
			 'down': Vector2(0,1)}
var raycasts = {'right': 'RayCastRight',
			    'left': 'RayCastLeft',
				'up': 'RayCastUp',
				'down': 'RayCastDown'}
				

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(dir):
	if get_node(raycasts[dir]).is_colliding():
		$Sprite/AnimationPlayer.play(dir)
		print("collide")
		return
	facing = dir
	canMove = false
	$Sprite/AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self, "position", position,
									position + moves[facing] * tileSize, 0.8,
									Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true

func _on_MoveTween_tween_completed(object, key):
	canMove = true # Replace with function body.
