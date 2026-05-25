extends Node2D

@onready var hint2 = get_tree().current_scene.get_node("UI/Dicas/HintLabel2")
@onready var hint3 = get_tree().current_scene.get_node("UI/Dicas/HintLabel3")
@onready var hint4 = get_tree().current_scene.get_node("UI/Dicas/HintLabel4")
@onready var hint5 = get_tree().current_scene.get_node("UI/Dicas/HintLabel5")
@onready var hint6 = get_tree().current_scene.get_node("UI/Dicas/HintLabel6")


@onready var player = get_tree().current_scene.get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.x > 500 && player.position.x < 650:
		hint2.visible = true
	else:
		hint2.visible = false

	if player.position.x > 750 && player.position.x < 1000:
		hint3.visible = true
	else:
		hint3.visible = false
		
	if player.position.x > 1100 && player.position.x < 1400:
		hint4.visible = true
	else:
		hint4.visible = false
		
	if player.position.x > 1680 && player.position.x < 1750:
		hint5.visible = true
	else:
		hint5.visible = false
	
	if player.position.x > 1760 && player.position.x < 1950:
		hint6.visible = true
	else:
		hint6.visible = false
