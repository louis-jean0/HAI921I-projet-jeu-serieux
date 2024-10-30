extends Node2D

var plastic = 0
var plastic_label: Label
var money = 1000
var money_label: Label
var towers = 0
var towers_label: Label
var qqt = 0.
var qqt_label: Label
var bank = 0
var bank_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plastic_label = get_node("../ResourcesUI").get_child(0)
	money_label = get_node("../ResourcesUI").get_child(1)
	towers_label = get_node("../StatsUI").get_child(0)
	qqt_label = get_node("../StatsUI").get_child(1)
	bank_label = get_node("../StatsUI").get_child(2)
	update_money_label()
	update_plastic_label()
	update_towers_label()
	update_qqt_label()
	update_bank_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_plastic(amount: int) -> void:
	plastic += amount
	update_plastic_label()
	
func remove_plastic(amount: int) -> void:
	add_plastic(-amount)
	
func update_plastic_label() -> void:
	plastic_label.text = str(plastic)
	
func recycle_plastic() -> void:
	money += plastic
	add_bank(plastic)
	plastic = 0	
	update_plastic_label()
	update_money_label()

func add_money(amount: int) -> void:
	money += amount
	update_money_label()
	
func remove_money(amount: int) -> void:
	add_money(-amount)
	
func update_money_label() -> void:
	money_label.text = str(money)
	
func add_towers() -> void:
	towers+= 1
	update_towers_label()
	
func update_towers_label() -> void:
	towers_label.text = str(towers)
	
func add_qqt() -> void:
	qqt+= 0.1
	update_qqt_label()
	
func update_qqt_label() -> void:
	qqt_label.text = str(qqt)

func add_bank(amount: int) -> void:
	bank+= amount
	update_bank_label()
	
func update_bank_label() -> void:
	bank_label.text = str(bank)
