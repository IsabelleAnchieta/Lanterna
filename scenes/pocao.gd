extends Node2D

var player_perto = false

@export var textura_inventario : Texture2D
@export var nome_item = "Cura"

@export_multiline var descricao_item = "Recupera um pouco de vida."
func _ready():

	$AnimatedSprite2D.play("pocao")

func _process(delta):

	if player_perto:

		if Input.is_action_just_pressed("interact"):

			coletar()

func coletar():

	var inventario = get_tree().get_first_node_in_group("inventario")
	print(inventario)
	inventario.adicionar_item(textura_inventario,nome_item,descricao_item)

	queue_free()

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":

		player_perto = true


func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Player":

		player_perto = false
