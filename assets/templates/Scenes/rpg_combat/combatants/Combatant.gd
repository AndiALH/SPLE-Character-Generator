extends Node2D

export (int) var attack = 1
export (int) var defense = 1
export (NodePath) var special_skill
var active = false setget set_active

signal turn_end

func _ready():
	special_skill = get_child(2).get_child(0)
	#print(special_skill.get_child_count())
	#special_skill = special_skill.get_child(0)

func set_active(value):
	active = value
	set_process(value)
	set_process_input(value)
	
	if not active:
		return
	
func attack(target):
	target.take_damage(attack)
	emit_signal("turn_end")
	
func special(target):
	var result = special_skill.special()
	var damage = int (result)
	if damage > 0:
		target.take_damage(damage)
	else:
		$Health.heal(-result)
	emit_signal("turn_end")
	
func defend():
	$Health.armor = $Health.base_armor
	$Health.armor += 0.5
	emit_signal("turn_end")
	
func skill_swap():
	if special_skill.skillName == "Magic Skill":
		special_skill = get_node('/root/Game/SkillList/HealSkill')
	else:
		special_skill = get_node('/root/Game/SkillList/MagicSkill')
func take_damage(damage):
	$Health.take_damage(damage)
