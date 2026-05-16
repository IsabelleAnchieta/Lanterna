extends Control


var itens = []
var aberto = false
var slot_selecionado = -1
@onready var nome_item = $VBoxContainer/NomeItem
@onready var descricao_item = $VBoxContainer/DescricaoItem

@onready var slots = [
	 %Slot1,
	%Slot2,
	%Slot3,
	%Slot4,
	%Slot5,
	%Slot6,
	%Slot7,
	%Slot8,
	%Slot9,
	%Slot10,
	%Slot11,
	%Slot12,
	%Slot13,
	%Slot14,
	%Slot15,
	%Slot16
]

func _ready():
	$VBoxContainer.visible = false
	
	for i in range(slots.size()):
		slots[i].gui_input.connect(_on_slot_input.bind(i))
	

func _on_slot_input(event, i):
	if event is InputEventMouseButton and event.pressed:
		verificar_clique_slot(i)
		
			
func adicionar_item(textura, nome, descricao):
	itens.append({
		"textura": textura,
		"nome": nome,
		"descricao": descricao
	})
	atualizar_ui()

func atualizar_ui():

	for i in range(slots.size()):

		if i < itens.size():

			slots[i].texture = itens[i]["textura"]

		else:

			slots[i].texture = null
	
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		aberto = !aberto
		visible = aberto
		
	if Input.is_action_just_pressed("use_item"):
		usar_item()
				
func mostrar_descricao(index):

	$VBoxContainer.visible = true

	nome_item.text = itens[index]["nome"]

	descricao_item.text = itens[index]["descricao"]

	limpar_highlights()

	slots[index].get_node("Highlight").visible = true

func esconder_descricao():

	$VBoxContainer.visible = false
	limpar_highlights()
	
func limpar_highlights():

	for slot in slots:
		slot.get_node("Highlight").visible = false

	
func verificar_clique_slot(i):
	# se clicou no mesmo slot
	if slot_selecionado == i:

		slot_selecionado = -1
		esconder_descricao()
		return

	# seleciona novo slot
	slot_selecionado = i

	if i < itens.size():
		mostrar_descricao(i)
	else:
		esconder_descricao()

func usar_item():

	if slot_selecionado == -1:
		return

	if slot_selecionado >= itens.size():
		return

	var item = itens[slot_selecionado]

	if item["nome"] == "Cura":

		var player = get_tree().get_first_node_in_group("player")

		if player:

			player.vida += 20
			player.vida = clamp(player.vida, 0, 100)

			itens.remove_at(slot_selecionado)

			slot_selecionado = -1

			esconder_descricao()

			atualizar_ui()	
