local OVALE, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_hunter"
	local desc = "[6.0] Ovale: Rotations (Beast Mastery, Marksmanship, Survival)"
	local code = [[
# Hunter rotation functions based on SimulationCraft.

###
### Beast Mastery
###
# Based on SimulationCraft profile "Hunter_BM_T17M".
#	class=hunter
#	spec=beast_mastery
#	talents=0002133

AddCheckBox(opt_interrupt L(interrupt) default specialization=beast_mastery)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=beast_mastery)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=beast_mastery)

AddFunction BeastMasteryUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction BeastMasteryInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction BeastMasterySummonPet
{
	if pet.IsDead()
	{
		if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
		Spell(revive_pet)
	}
	if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
}

### actions.default

AddFunction BeastMasteryDefaultMainActions
{
	#multishot,if=active_enemies>5|(active_enemies>1&pet.cat.buff.beast_cleave.down)
	if Enemies() > 5 or Enemies() > 1 and pet.BuffExpires(pet_beast_cleave_buff any=1) Spell(multishot)
	#kill_shot,if=focus.time_to_max>gcd
	if TimeToMaxFocus() > GCD() Spell(kill_shot)
	#kill_command
	if pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() Spell(kill_command)
	#focusing_shot,if=focus<50
	if Focus() < 50 Spell(focusing_shot)
	#cobra_shot,if=buff.pre_steady_focus.up&(14+cast_regen)<=focus.deficit
	if BuffPresent(pre_steady_focus_buff) and 14 + FocusCastingRegen(cobra_shot) <= FocusDeficit() Spell(cobra_shot)
	#glaive_toss
	Spell(glaive_toss)
	#cobra_shot,if=active_enemies>5
	if Enemies() > 5 Spell(cobra_shot)
	#arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 or BuffPresent(bestial_wrath_buff) Spell(arcane_shot)
	#arcane_shot,if=focus>=64
	if Focus() >= 64 Spell(arcane_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction BeastMasteryDefaultShortCdActions
{
	#dire_beast
	Spell(dire_beast)
	#explosive_trap,if=active_enemies>1
	if Enemies() > 1 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
	#bestial_wrath,if=focus>60&!buff.bestial_wrath.up
	if Focus() > 60 and not BuffPresent(bestial_wrath_buff) Spell(bestial_wrath)
	#barrage,if=active_enemies>1
	if Enemies() > 1 Spell(barrage)

	unless { Enemies() > 5 or Enemies() > 1 and pet.BuffExpires(pet_beast_cleave_buff any=1) } and Spell(multishot)
	{
		#focus_fire,five_stacks=1
		if BuffStacks(frenzy_buff any=1) >= 5 Spell(focus_fire)
		#barrage,if=active_enemies>1
		if Enemies() > 1 Spell(barrage)
		#a_murder_of_crows
		Spell(a_murder_of_crows)

		unless TimeToMaxFocus() > GCD() and Spell(kill_shot) or pet.Present() and not pet.IsIncapacitated() and not pet.IsFeared() and not pet.IsStunned() and Spell(kill_command) or Focus() < 50 and Spell(focusing_shot) or BuffPresent(pre_steady_focus_buff) and 14 + FocusCastingRegen(cobra_shot) <= FocusDeficit() and Spell(cobra_shot) or Spell(glaive_toss)
		{
			#barrage
			Spell(barrage)
			#powershot,if=focus.time_to_max>cast_time
			if TimeToMaxFocus() > CastTime(powershot) Spell(powershot)
		}
	}
}

AddFunction BeastMasteryDefaultCdActions
{
	#auto_shot
	#counter_shot
	BeastMasteryInterruptActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#potion,name=draenic_agility,if=!talent.stampede.enabled&buff.bestial_wrath.up&target.health.pct<=20|target.time_to_die<=20
	if not Talent(stampede_talent) and BuffPresent(bestial_wrath_buff) and target.HealthPercent() <= 20 or target.TimeToDie() <= 20 BeastMasteryUsePotionAgility()
	#potion,name=draenic_agility,if=talent.stampede.enabled&cooldown.stampede.remains<1&(buff.bloodlust.up|buff.focus_fire.up)|target.time_to_die<=25
	if Talent(stampede_talent) and SpellCooldown(stampede) < 1 and { BuffPresent(burst_haste_buff any=1) or BuffPresent(focus_fire_buff) } or target.TimeToDie() <= 25 BeastMasteryUsePotionAgility()
	#stampede,if=buff.bloodlust.up|buff.focus_fire.up|target.time_to_die<=25
	if BuffPresent(burst_haste_buff any=1) or BuffPresent(focus_fire_buff) or target.TimeToDie() <= 25 Spell(stampede)
}

### actions.precombat

AddFunction BeastMasteryPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=active_enemies<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=active_enemies>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#focusing_shot,if=!talent.glaive_toss.enabled
	if not Talent(glaive_toss_talent) Spell(focusing_shot)
}

AddFunction BeastMasteryPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=calamari_crepes
	#summon_pet
	BeastMasterySummonPet()
}

AddFunction BeastMasteryPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot)
}

AddFunction BeastMasteryPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		BeastMasteryUsePotionAgility()
	}
}

AddFunction BeastMasteryPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot)
}

###
### Marksmanship
###
# Based on SimulationCraft profile "Hunter_MM_T17M".
#	class=hunter
#	spec=marksmanship
#	talents=0003113

AddCheckBox(opt_interrupt L(interrupt) default specialization=marksmanship)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=marksmanship)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=marksmanship)

AddFunction MarksmanshipUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction MarksmanshipUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction MarksmanshipInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction MarksmanshipSummonPet
{
	if not Talent(lone_wolf_talent)
	{
		if pet.IsDead()
		{
			if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
			Spell(revive_pet)
		}
		if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
	}
}

### actions.default

AddFunction MarksmanshipDefaultMainActions
{
	#chimaera_shot
	Spell(chimaera_shot)
	#kill_shot
	Spell(kill_shot)
	#call_action_list,name=careful_aim,if=buff.careful_aim.up
	if target.HealthPercent() > 80 or BuffPresent(rapid_fire_buff) MarksmanshipCarefulAimMainActions()
	#glaive_toss
	Spell(glaive_toss)
	#steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
	if FocusDeficit() * CastTime(steady_shot) / { 14 + FocusCastingRegen(steady_shot) } > SpellCooldown(rapid_fire) Spell(steady_shot)
	#focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
	if FocusDeficit() * CastTime(focusing_shot_marksmanship) / { 50 + FocusCastingRegen(focusing_shot_marksmanship) } > SpellCooldown(rapid_fire) and Focus() < 100 Spell(focusing_shot_marksmanship)
	#steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit
	if BuffPresent(pre_steady_focus_buff) and 14 + FocusCastingRegen(steady_shot) + FocusCastingRegen(aimed_shot) <= FocusDeficit() Spell(steady_shot)
	#multishot,if=active_enemies>6
	if Enemies() > 6 Spell(multishot)
	#aimed_shot,if=talent.focusing_shot.enabled
	if Talent(focusing_shot_talent) Spell(aimed_shot)
	#aimed_shot,if=focus+cast_regen>=85
	if Focus() + FocusCastingRegen(aimed_shot) >= 85 Spell(aimed_shot)
	#aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() + FocusCastingRegen(aimed_shot) >= 65 Spell(aimed_shot)
	#focusing_shot,if=50+cast_regen-10<focus.deficit
	if 50 + FocusCastingRegen(focusing_shot_marksmanship) - 10 < FocusDeficit() Spell(focusing_shot_marksmanship)
	#steady_shot
	Spell(steady_shot)
}

AddFunction MarksmanshipDefaultShortCdActions
{
	unless Spell(chimaera_shot) or Spell(kill_shot)
	{
		#call_action_list,name=careful_aim,if=buff.careful_aim.up
		if target.HealthPercent() > 80 or BuffPresent(rapid_fire_buff) MarksmanshipCarefulAimShortCdActions()

		unless { target.HealthPercent() > 80 or BuffPresent(rapid_fire_buff) } and MarksmanshipCarefulAimShortCdPostConditions()
		{
			#explosive_trap,if=active_enemies>1
			if Enemies() > 1 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
			#a_murder_of_crows
			Spell(a_murder_of_crows)
			#dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
			if FocusCastingRegen(dire_beast) + FocusCastingRegen(aimed_shot) < FocusDeficit() Spell(dire_beast)

			unless Spell(glaive_toss)
			{
				#powershot,if=cast_regen<focus.deficit
				if FocusCastingRegen(powershot) < FocusDeficit() Spell(powershot)
				#barrage
				Spell(barrage)
			}
		}
	}
}

AddFunction MarksmanshipDefaultCdActions
{
	#auto_shot
	#counter_shot
	MarksmanshipInterruptActions()
	#use_item,name=beating_heart_of_the_mountain
	MarksmanshipUseItemActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#potion,name=draenic_agility,if=((buff.rapid_fire.up|buff.bloodlust.up)&(cooldown.stampede.remains<1))|target.time_to_die<=25
	if { BuffPresent(rapid_fire_buff) or BuffPresent(burst_haste_buff any=1) } and SpellCooldown(stampede) < 1 or target.TimeToDie() <= 25 MarksmanshipUsePotionAgility()

	unless Spell(chimaera_shot) or Spell(kill_shot)
	{
		#rapid_fire
		Spell(rapid_fire)
		#stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
		if BuffPresent(rapid_fire_buff) or BuffPresent(burst_haste_buff any=1) or target.TimeToDie() <= 25 Spell(stampede)
	}
}

### actions.careful_aim

AddFunction MarksmanshipCarefulAimMainActions
{
	#glaive_toss,if=active_enemies>2
	if Enemies() > 2 Spell(glaive_toss)
	#aimed_shot
	Spell(aimed_shot)
	#focusing_shot,if=50+cast_regen<focus.deficit
	if 50 + FocusCastingRegen(focusing_shot_marksmanship) < FocusDeficit() Spell(focusing_shot_marksmanship)
	#steady_shot
	Spell(steady_shot)
}

AddFunction MarksmanshipCarefulAimShortCdActions
{
	unless Enemies() > 2 and Spell(glaive_toss)
	{
		#powershot,if=active_enemies>1&cast_regen<focus.deficit
		if Enemies() > 1 and FocusCastingRegen(powershot) < FocusDeficit() Spell(powershot)
		#barrage,if=active_enemies>1
		if Enemies() > 1 Spell(barrage)
	}
}

AddFunction MarksmanshipCarefulAimShortCdPostConditions
{
	Enemies() > 2 and Spell(glaive_toss) or Spell(aimed_shot) or 50 + FocusCastingRegen(focusing_shot_marksmanship) < FocusDeficit() and Spell(focusing_shot_marksmanship) or Spell(steady_shot)
}

### actions.precombat

AddFunction MarksmanshipPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=active_enemies<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=active_enemies>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#focusing_shot,if=!talent.glaive_toss.enabled
	if not Talent(glaive_toss_talent) Spell(focusing_shot_marksmanship)
}

AddFunction MarksmanshipPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=calamari_crepes
	#summon_pet
	MarksmanshipSummonPet()
}

AddFunction MarksmanshipPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot_marksmanship)
}

AddFunction MarksmanshipPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		MarksmanshipUsePotionAgility()
	}
}

AddFunction MarksmanshipPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot_marksmanship)
}

###
### Survival
###
# Based on SimulationCraft profile "Hunter_SV_T17M".
#	class=hunter
#	spec=survival
#	talents=0001112

AddCheckBox(opt_interrupt L(interrupt) default specialization=survival)
AddCheckBox(opt_potion_agility ItemName(draenic_agility_potion) default specialization=survival)
AddCheckBox(opt_trap_launcher SpellName(trap_launcher) default specialization=survival)

AddFunction SurvivalUsePotionAgility
{
	if CheckBoxOn(opt_potion_agility) and target.Classification(worldboss) Item(draenic_agility_potion usable=1)
}

AddFunction SurvivalUseItemActions
{
	Item(HandSlot usable=1)
	Item(Trinket0Slot usable=1)
	Item(Trinket1Slot usable=1)
}

AddFunction SurvivalInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.IsInterruptible()
	{
		Spell(counter_shot)
		if not target.Classification(worldboss)
		{
			Spell(arcane_torrent_focus)
			if target.InRange(quaking_palm) Spell(quaking_palm)
			Spell(war_stomp)
		}
	}
}

AddFunction SurvivalSummonPet
{
	if not Talent(lone_wolf_talent)
	{
		if pet.IsDead()
		{
			if not DebuffPresent(heart_of_the_phoenix_debuff) Spell(heart_of_the_phoenix)
			Spell(revive_pet)
		}
		if not pet.Present() and not pet.IsDead() and not PreviousSpell(revive_pet) Texture(ability_hunter_beastcall help=L(summon_pet))
	}
}

### actions.default

AddFunction SurvivalDefaultMainActions
{
	#call_action_list,name=aoe,if=active_enemies>1
	if Enemies() > 1 SurvivalAoeMainActions()
	#black_arrow,if=!ticking
	if not target.DebuffPresent(black_arrow_debuff) Spell(black_arrow)	
	#explosive_shot
	Spell(explosive_shot)
	#arcane_shot,if=buff.thrill_of_the_hunt.react&focus>35&cast_regen<=focus.deficit|dot.serpent_sting.remains<=3|target.time_to_die<4.5
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 and FocusCastingRegen(arcane_shot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 3 or target.TimeToDie() < 4.5 Spell(arcane_shot)
	#cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&(14+cast_regen)<=focus.deficit
	if BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and 14 + FocusCastingRegen(cobra_shot) <= FocusDeficit() Spell(cobra_shot)
	#arcane_shot,if=focus>=80|talent.focusing_shot.enabled
	if Focus() >= 80 or Talent(focusing_shot_talent) Spell(arcane_shot)
	#focusing_shot
	Spell(focusing_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction SurvivalDefaultShortCdActions
{
	#call_action_list,name=aoe,if=active_enemies>1
	if Enemies() > 1 SurvivalAoeShortCdActions()

	unless Enemies() > 1 and SurvivalAoeShortCdPostConditions()
	{
		#a_murder_of_crows
		Spell(a_murder_of_crows)
		
		unless Spell(explosive_shot)
		{
			#dire_beast
			Spell(dire_beast)

			unless { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 35 and FocusCastingRegen(arcane_shot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 3 or target.TimeToDie() < 4.5 } and Spell(arcane_shot)
			{
				#explosive_trap
				if CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
			}
		}
	}
}

AddFunction SurvivalDefaultCdActions
{
	#auto_shot
	#counter_shot
	SurvivalInterruptActions()
	#use_item,name=beating_heart_of_the_mountain
	SurvivalUseItemActions()
	#arcane_torrent,if=focus.deficit>=30
	if FocusDeficit() >= 30 Spell(arcane_torrent_focus)
	#blood_fury
	Spell(blood_fury_ap)
	#berserking
	Spell(berserking)
	#potion,name=draenic_agility,if=(((cooldown.stampede.remains<1)&(cooldown.a_murder_of_crows.remains<1))&(trinket.stat.any.up|buff.archmages_greater_incandescence_agi.up))|target.time_to_die<=25
	if SpellCooldown(stampede) < 1 and SpellCooldown(a_murder_of_crows) < 1 and { BuffPresent(trinket_stat_any_buff) or BuffPresent(archmages_greater_incandescence_agi_buff) } or target.TimeToDie() <= 25 SurvivalUsePotionAgility()
	#call_action_list,name=aoe,if=active_enemies>1
	if Enemies() > 1 SurvivalAoeCdActions()

	unless Enemies() > 1 and SurvivalAoeCdPostConditions()
	{
		#stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=25
		if BuffPresent(potion_agility_buff) or ItemCooldown(draenic_agility_potion) > 0 and { BuffPresent(archmages_greater_incandescence_agi_buff) or BuffPresent(trinket_stat_any_buff) } or target.TimeToDie() <= 25 Spell(stampede)
	}
}

### actions.aoe

AddFunction SurvivalAoeMainActions
{
	#explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
	if BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } Spell(explosive_shot)
	#explosive_shot,if=active_enemies<5
	if Enemies() < 5 Spell(explosive_shot)
	#multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
	if BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 Spell(multishot)
	#glaive_toss
	Spell(glaive_toss)
	#cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80
	if BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 Spell(cobra_shot)
	#multishot,if=focus>=70|talent.focusing_shot.enabled
	if Focus() >= 70 or Talent(focusing_shot_talent) Spell(multishot)
	#focusing_shot
	Spell(focusing_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction SurvivalAoeShortCdActions
{
	unless BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot)
	{
		#barrage
		Spell(barrage)
		#black_arrow,if=!ticking
		if not target.DebuffPresent(black_arrow_debuff) Spell(black_arrow)

		unless Enemies() < 5 and Spell(explosive_shot)
		{
			#explosive_trap,if=dot.explosive_trap.remains<=5
			if target.DebuffRemaining(explosive_trap_debuff) <= 5 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) Spell(explosive_trap)
			#a_murder_of_crows
			Spell(a_murder_of_crows)
			#dire_beast
			Spell(dire_beast)

			unless { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 } and Spell(multishot) or Spell(glaive_toss)
			{
				#powershot
				Spell(powershot)
			}
		}
	}
}

AddFunction SurvivalAoeShortCdPostConditions
{
	BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot) or Enemies() < 5 and Spell(explosive_shot) or { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 } and Spell(multishot) or Spell(glaive_toss) or BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 and Spell(cobra_shot) or { Focus() >= 70 or Talent(focusing_shot_talent) } and Spell(multishot) or Spell(focusing_shot) or Spell(cobra_shot)
}

AddFunction SurvivalAoeCdActions
{
	#stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
	if BuffPresent(potion_agility_buff) or ItemCooldown(draenic_agility_potion) > 0 and { BuffPresent(archmages_greater_incandescence_agi_buff) or BuffPresent(trinket_stat_any_buff) or BuffPresent(archmages_incandescence_agi_buff) } Spell(stampede)
}

AddFunction SurvivalAoeCdPostConditions
{
	BuffPresent(lock_and_load_buff) and { not Talent(barrage_talent) or SpellCooldown(barrage) > 0 } and Spell(explosive_shot) or Spell(barrage) or not target.DebuffPresent(black_arrow_debuff) and Spell(black_arrow) or Enemies() < 5 and Spell(explosive_shot) or target.DebuffRemaining(explosive_trap_debuff) <= 5 and CheckBoxOn(opt_trap_launcher) and not Glyph(glyph_of_explosive_trap) and Spell(explosive_trap) or Spell(a_murder_of_crows) or Spell(dire_beast) or { BuffPresent(thrill_of_the_hunt_buff) and Focus() > 50 and FocusCastingRegen(multishot) <= FocusDeficit() or target.DebuffRemaining(serpent_sting_debuff) <= 5 or target.TimeToDie() < 4.5 } and Spell(multishot) or Spell(glaive_toss) or Spell(powershot) or BuffPresent(pre_steady_focus_buff) and BuffRemaining(steady_focus_buff) < 5 and Focus() + 14 + FocusCastingRegen(cobra_shot) < 80 and Spell(cobra_shot) or { Focus() >= 70 or Talent(focusing_shot_talent) } and Spell(multishot) or Spell(focusing_shot) or Spell(cobra_shot)
}

### actions.precombat

AddFunction SurvivalPrecombatMainActions
{
	#snapshot_stats
	#exotic_munitions,ammo_type=poisoned,if=active_enemies<3
	if Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(poisoned_ammo)
	#exotic_munitions,ammo_type=incendiary,if=active_enemies>=3
	if Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 Spell(incendiary_ammo)
	#glaive_toss
	Spell(glaive_toss)
	#focusing_shot,if=!talent.glaive_toss.enabled
	if not Talent(glaive_toss_talent) Spell(focusing_shot)
}

AddFunction SurvivalPrecombatShortCdActions
{
	#flask,type=greater_draenic_agility_flask
	#food,type=calamari_crepes
	#summon_pet
	SurvivalSummonPet()
}

AddFunction SurvivalPrecombatShortCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot)
}

AddFunction SurvivalPrecombatCdActions
{
	unless Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo)
	{
		#potion,name=draenic_agility
		SurvivalUsePotionAgility()
	}
}

AddFunction SurvivalPrecombatCdPostConditions
{
	Enemies() < 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(poisoned_ammo) or Enemies() >= 3 and BuffRemaining(exotic_munitions_buff) < 1200 and Spell(incendiary_ammo) or Spell(glaive_toss) or not Talent(glaive_toss_talent) and Spell(focusing_shot)
}
]]
	OvaleScripts:RegisterScript("HUNTER", name, desc, code, "include")
end

do
	local name = "Ovale"	-- The default script.
	local desc = "[6.0] Ovale: Beast Mastery, Marksmanship, Survival"
	local code = [[
# Ovale hunter script based on SimulationCraft.

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_hunter_spells)
Include(ovale_hunter)

### BeastMastery icons.

AddCheckBox(opt_hunter_beast_mastery_aoe L(AOE) default specialization=beast_mastery)

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=shortcd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatShortCdActions()
	unless not InCombat() and BeastMasteryPrecombatShortCdPostConditions()
	{
		BeastMasteryDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=shortcd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatShortCdActions()
	unless not InCombat() and BeastMasteryPrecombatShortCdPostConditions()
	{
		BeastMasteryDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatMainActions()
	BeastMasteryDefaultMainActions()
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=aoe specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatMainActions()
	BeastMasteryDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_beast_mastery_aoe enemies=1 help=cd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatCdActions()
	unless not InCombat() and BeastMasteryPrecombatCdPostConditions()
	{
		BeastMasteryDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_beast_mastery_aoe help=cd specialization=beast_mastery
{
	if not InCombat() BeastMasteryPrecombatCdActions()
	unless not InCombat() and BeastMasteryPrecombatCdPostConditions()
	{
		BeastMasteryDefaultCdActions()
	}
}

### Marksmanship icons.

AddCheckBox(opt_hunter_marksmanship_aoe L(AOE) default specialization=marksmanship)

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=shortcd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatShortCdActions()
	unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
	{
		MarksmanshipDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=shortcd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatShortCdActions()
	unless not InCombat() and MarksmanshipPrecombatShortCdPostConditions()
	{
		MarksmanshipDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatMainActions()
	MarksmanshipDefaultMainActions()
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=aoe specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatMainActions()
	MarksmanshipDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_marksmanship_aoe enemies=1 help=cd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatCdActions()
	unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
	{
		MarksmanshipDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_marksmanship_aoe help=cd specialization=marksmanship
{
	if not InCombat() MarksmanshipPrecombatCdActions()
	unless not InCombat() and MarksmanshipPrecombatCdPostConditions()
	{
		MarksmanshipDefaultCdActions()
	}
}

### Survival icons.

AddCheckBox(opt_hunter_survival_aoe L(AOE) default specialization=survival)

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=shortcd specialization=survival
{
	if not InCombat() SurvivalPrecombatShortCdActions()
	unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
	{
		SurvivalDefaultShortCdActions()
	}
}

AddIcon checkbox=opt_hunter_survival_aoe help=shortcd specialization=survival
{
	if not InCombat() SurvivalPrecombatShortCdActions()
	unless not InCombat() and SurvivalPrecombatShortCdPostConditions()
	{
		SurvivalDefaultShortCdActions()
	}
}

AddIcon enemies=1 help=main specialization=survival
{
	if not InCombat() SurvivalPrecombatMainActions()
	SurvivalDefaultMainActions()
}

AddIcon checkbox=opt_hunter_survival_aoe help=aoe specialization=survival
{
	if not InCombat() SurvivalPrecombatMainActions()
	SurvivalDefaultMainActions()
}

AddIcon checkbox=!opt_hunter_survival_aoe enemies=1 help=cd specialization=survival
{
	if not InCombat() SurvivalPrecombatCdActions()
	unless not InCombat() and SurvivalPrecombatCdPostConditions()
	{
		SurvivalDefaultCdActions()
	}
}

AddIcon checkbox=opt_hunter_survival_aoe help=cd specialization=survival
{
	if not InCombat() SurvivalPrecombatCdActions()
	unless not InCombat() and SurvivalPrecombatCdPostConditions()
	{
		SurvivalDefaultCdActions()
	}
}
]]
	OvaleScripts:RegisterScript("HUNTER", name, desc, code, "script")
end
