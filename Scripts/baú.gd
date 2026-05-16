extends Node2D

var player_perto = false
var aberto = false

@export var item_scene : PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var spawn = $Marker2D

func _ready():
	sprite.play("closed")

func _process(delta):

	if player_perto and not aberto:

		if Input.is_action_just_pressed("interact"):
			abrir_bau()

func abrir_bau():

	aberto = true

	sprite.play("open")

	spawnar_item()

func spawnar_item():

	var item = item_scene.instantiate()

	get_parent().add_child(item)

	item.global_position = spawn.global_position

func _on_area_2d_body_entered(body):

	if body.name == "Player":
		player_perto = true

func _on_area_2d_body_exited(body):

	if body.name == "Player":
		player_perto = false
