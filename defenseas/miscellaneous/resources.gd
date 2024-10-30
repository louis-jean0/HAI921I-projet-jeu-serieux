extends Node2D

var plastic = 0
var plastic_label: Label
var money = 100
var money_label: Label
var towers = 0
var towers_label: Label
var turbines = 0
var turbines_label: Label
var filets = 0
var filets_label: Label
var nb_ennemis_killed = 0
var nb_ennemis_killed_label: Label
var nb_ennemis_passed = 0
var nb_ennemis_passed_label: Label
var qqt = 0.
var qqt_label: Label
var bank = 0
var bank_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plastic_label = get_node("../ResourcesUI").get_child(0)
	money_label = get_node("../ResourcesUI").get_child(1)
	towers_label = get_node("../StatsUI").get_child(0).get_child(0)
	turbines_label = get_node("../StatsUI").get_child(1).get_child(0)
	filets_label = get_node("../StatsUI").get_child(2).get_child(0)
	nb_ennemis_killed_label = get_node("../StatsUI").get_child(3).get_child(0)
	nb_ennemis_passed_label = get_node("../StatsUI").get_child(4).get_child(0)
	qqt_label = get_node("../StatsUI").get_child(5).get_child(0)
	bank_label = get_node("../StatsUI").get_child(6).get_child(0)
	update_money_label()
	update_plastic_label()
	update_towers_label()
	update_turbines_label()
	update_filets_label()
	update_ennemis_killed_label()
	update_ennemis_passed_label()
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
	if(plastic<=100):
		money += plastic
		add_bank(plastic)
		plastic = 0	
	if(plastic>100 && plastic<=200):
		money += ceil(plastic*1.1)
		add_bank(ceil(plastic*1.1))
		plastic = 0	
	if(plastic>200 && plastic<=300):
		money += ceil(plastic*1.2)
		add_bank(ceil(plastic*1.2))
		plastic = 0	
	if(plastic>300 && plastic<=400):
		money += ceil(plastic*1.4)
		add_bank(ceil(plastic*1.4))
		plastic = 0	
	if(plastic>400):
		money += ceil(plastic*1.6)
		add_bank(ceil(plastic*1.6))
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
	

func add_turbines() -> void:
	turbines += 1
	update_turbines_label()
	
func update_turbines_label() -> void:
	turbines_label.text = str(turbines)
	
func add_filets() -> void:
	filets += 1
	update_filets_label()
	
func update_filets_label() -> void:
	filets_label.text = str(filets)
	
func add_enemy_killed() -> void:
	nb_ennemis_killed += 1
	update_ennemis_killed_label()
	
func update_ennemis_killed_label() -> void:
	nb_ennemis_killed_label.text = str(nb_ennemis_killed)
	
func add_enemy_passed() -> void:
	nb_ennemis_passed += 1
	update_ennemis_passed_label()
	
func update_ennemis_passed_label() -> void:
	nb_ennemis_passed_label.text = str(nb_ennemis_passed)
	
func add_qqt() -> void:
	qqt += 0.1
	update_qqt_label()
	
func update_qqt_label() -> void:
	qqt_label.text = str(qqt)

func add_bank(amount: int) -> void:
	bank+= amount
	update_bank_label()
	
func update_bank_label() -> void:
	bank_label.text = str(bank)
