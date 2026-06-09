extends Node3D

@onready var hint2 = get_tree().current_scene.get_node("UI/Dicas/HintLabel2")
@onready var hint3 = get_tree().current_scene.get_node("UI/Dicas/HintLabel3")
@onready var hint4 = get_tree().current_scene.get_node("UI/Dicas/HintLabel4")
@onready var hint5 = get_tree().current_scene.get_node("UI/Dicas/HintLabel5")
@onready var hint6 = get_tree().current_scene.get_node("UI/Dicas/HintLabel6")
@onready var warning = get_tree().current_scene.get_node("UI/Dicas/HintLabel7")
@onready var player = get_tree().current_scene.get_node("Player")
@onready var luz = get_tree().current_scene.get_node("Luz")
# Called when the node enters the scene tree for the first time.

@export var Enemy_dash : PackedScene
@export var Enemy_basic : PackedScene
@export var Enemy_true : PackedScene
@export var Saida : PackedScene

var ativo = false
var place = 0
var count = 0
var luz_morta = true

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Global.cristal_obtido == true && luz_morta:
		luz.queue_free()
		luz_morta = false
	
	if player.position.x > 400 && player.position.x < 700:
		hint2.visible = true
	else:
		hint2.visible = false

	if player.position.x > 900 && player.position.x < 1250:
		hint3.visible = true
	else:
		hint3.visible = false
		
	if player.position.x > 1500 && player.position.x < 1800:
		hint4.visible = true
	else:
		hint4.visible = false
		
	if player.position.x > 1950 && player.position.x < 2020:
		hint5.visible = true
	else:
		hint5.visible = false
	
	if player.position.x > 2050 && player.position.x < 2250:
		hint6.visible = true
	else:
		hint6.visible = false

	if player.global_position.x > 6200 \
	and player.global_position.x < 6900 && count < 10:
		$Timer.wait_time = 2
		if !ativo:
			ativo = true
			$Timer.start()
	elif count >= 10:
		$Timer.wait_time = 20
		if !ativo:
			ativo = true
			$Timer.start()

	else:
		ativo = false
		$Timer.stop()
		
	if player.position.x > 8500 && Global.cristal_obtido == true:
		player.concluir_fase()
	elif player.position.x > 8500:
		warning.visible = true
	else:
		warning.visible = false
		
func _on_timer_timeout():
	
	var exit = Saida.instantiate()
	exit.global_position = Vector2(
			6850,
			0
		)
	exit.move_horizontal = false
	exit.distance = 350
	
	if count == 10:
		get_parent().add_child(exit)
		
	count += 1
		
	var enemy = Enemy_dash.instantiate()
	var fast =  Enemy_true.instantiate()
	var basic = Enemy_basic.instantiate()

	if place == 0:
		
		fast.global_position = Vector2(
			6300,
			-200
		)
		place = 1
		get_parent().add_child(fast)
	elif place == 1:
		fast.global_position = Vector2(
			6700,
			-500
		)
		place = 2
		get_parent().add_child(fast)
	elif place == 2:
		basic.global_position = Vector2(
			6850,
			-200
		)
		get_parent().add_child(basic)
		place = 3
	elif place == 3:
		enemy.global_position = Vector2(
			6400,
			-500
		)
		place = 4
		get_parent().add_child(enemy)
	elif place == 4:
		enemy.global_position = Vector2(
			6600,
			-500
		)
		place = 0
		get_parent().add_child(enemy)
