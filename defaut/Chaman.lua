Ovale.defaut["SHAMAN"] = [[Define(ancestral_swiftness 16188)
  SpellInfo(ancestral_swiftness cd=60 )
  SpellAddBuff(ancestral_swiftness ancestral_swiftness=1)
Define(ascendance 114049)
  SpellInfo(ascendance cd=180 )
Define(berserking 26297)
  SpellInfo(berserking duration=10 cd=180 )
  SpellAddBuff(berserking berserking=1)
Define(blood_fury 20572)
  SpellInfo(blood_fury duration=15 cd=120 )
  SpellAddBuff(blood_fury blood_fury=1)
Define(bloodlust 2825)
  SpellInfo(bloodlust duration=40 cd=300 )
  SpellAddBuff(bloodlust bloodlust=1)
Define(chain_lightning 421)
  SpellInfo(chain_lightning cd=3 )
Define(earth_elemental_totem 2062)
  SpellInfo(earth_elemental_totem duration=60 cd=300 )
Define(earth_shock 8042)
  SpellInfo(earth_shock cd=6 )
Define(earthquake 61882)
  SpellInfo(earthquake duration=10 cd=10 )
  SpellAddBuff(earthquake earthquake=1)
Define(elemental_blast 117014)
  SpellInfo(elemental_blast cd=12 )
Define(elemental_mastery 16166)
  SpellInfo(elemental_mastery duration=20 cd=120 )
  SpellAddBuff(elemental_mastery elemental_mastery=1)
Define(feral_spirit 51533)
  SpellInfo(feral_spirit duration=30 cd=120 )
Define(fire_elemental_totem 2894)
  SpellInfo(fire_elemental_totem duration=60 cd=300 )
Define(fire_nova 1535)
  SpellInfo(fire_nova cd=4 )
Define(flame_shock 8050)
  SpellInfo(flame_shock duration=24 cd=6 )
  SpellAddBuff(flame_shock flame_shock=1)
Define(flametongue_weapon 8024)
Define(lava_beam 114074)
Define(lava_burst 51505)
  SpellInfo(lava_burst cd=8 )
Define(lava_lash 55560)
Define(lightning_bolt 403)
Define(lightning_shield 324)
  SpellInfo(lightning_shield duration=3600 )
  SpellAddBuff(lightning_shield lightning_shield=1)
Define(maelstrom_weapon 51530)
Define(magma_totem 8187)
Define(searing_totem 3599)
  SpellInfo(searing_totem duration=60 )
Define(spiritwalkers_grace 55559)
Define(stormblast 115356)
  SpellInfo(stormblast duration=15 cd=8 )
  SpellAddBuff(stormblast stormblast=1)
Define(stormstrike 17364)
  SpellInfo(stormstrike duration=15 cd=8 )
  SpellAddBuff(stormstrike stormstrike=1)
Define(thunderstorm 51490)
  SpellInfo(thunderstorm duration=5 cd=45 )
  SpellAddBuff(thunderstorm thunderstorm=1)
Define(unleash_elements 73680)
  SpellInfo(unleash_elements cd=15 )
Define(unleash_flame 73683)
  SpellInfo(unleash_flame duration=8 )
  SpellAddBuff(unleash_flame unleash_flame=1)
Define(unleashed_fury_ft 118470)
  SpellInfo(unleashed_fury_ft duration=10 )
  SpellAddBuff(unleashed_fury_ft unleashed_fury_ft=1)
Define(wind_shear 55546)
Define(windfury_weapon 8232)
Define(ancestral_swiftness 11)
Define(elemental_blast 18)
Define(elemental_mastery 10)
Define(unleashed_fury 16)
AddIcon mastery=1 help=main
{
	
	{
		if TalentPoints(elemental_blast) Spell(elemental_blast)
		Spell(unleash_elements)
		if TalentPoints(unleashed_fury) and not BuffPresent(ascendance) Spell(unleash_elements)
		if not BuffPresent(ascendance) and {not target.DebuffPresent(flame_shock) or target.TicksRemain(flame_shock) <2 or {{BuffPresent(bloodlust) or BuffPresent(elemental_mastery) } and target.TicksRemain(flame_shock) <3 } } Spell(flame_shock)
		if  target.DebuffRemains(flame_shock) >CastTime(lava_burst) and {BuffPresent(ascendance) or True() } Spell(lava_burst)
		if BuffPresent(lightning_shield) ==0 or target.DeadIn() <10 Spell(earth_shock)
		if not TotemPresent(fire) Spell(searing_totem)
		Spell(lightning_bolt)
	}
	if Enemies() >1 
	{
		if not TotemPresent(fire) Spell(searing_totem)
		if not target.DebuffPresent(flame_shock) Spell(flame_shock)
		if  target.DebuffRemains(flame_shock) >CastTime(lava_burst) Spell(lava_burst)
		if Enemies() >4 Spell(earthquake)
		Spell(lava_beam)
		if ManaPercent() <80 Spell(thunderstorm)
		if ManaPercent() >10 Spell(chain_lightning)
		Spell(lightning_bolt)
	}
}
AddIcon mastery=1 help=offgcd
{
	Spell(wind_shear)
	
	{
		if TalentPoints(ancestral_swiftness) and not BuffPresent(ascendance) Spell(ancestral_swiftness)
		Spell(spiritwalkers_grace)
	}
	if Enemies() >1 
	{
		if Enemies() >2 and not TotemPresent(fire) Spell(magma_totem)
	}
}
AddIcon mastery=1 help=cd
{
	if target.HealthPercent() <25 or TimeInCombat() >5 Spell(bloodlust)
	 { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
	
	{
		Spell(blood_fury)
		if TalentPoints(elemental_mastery) and TimeInCombat() >15 and {{not BuffPresent(bloodlust) and TimeInCombat() <120 } or {not BuffPresent(berserking) and not BuffPresent(bloodlust) and BuffPresent(ascendance) } or {TimeInCombat() >=200 and SpellCooldown(ascendance) >30 } } Spell(elemental_mastery)
		if not TotemPresent(fire) Spell(fire_elemental_totem)
		if  target.DebuffRemains(flame_shock) >0 and {target.DeadIn() <20 or BuffPresent(bloodlust) or TimeInCombat() >=180 } Spell(ascendance)
		if not Spell(earth_elemental_totem)
	}
}
AddIcon mastery=2 help=main
{
	
	{
		if not TotemPresent(fire) Spell(searing_totem)
		if TalentPoints(elemental_blast) Spell(elemental_blast)
		if BuffPresent(maelstrom_weapon) ==5 or {ArmorSetParts(T13 more 4) ==1 and BuffPresent(maelstrom_weapon) >=4 and False() } Spell(lightning_bolt)
		Spell(stormblast)
		Spell(stormstrike)
		if BuffPresent(maelstrom_weapon) >=3 and target.DebuffPresent(unleashed_fury_ft) and not BuffPresent(ascendance) Spell(lightning_bolt)
		if BuffPresent(ancestral_swiftness) Spell(lightning_bolt)
		Spell(unleash_elements)
		if not target.DebuffPresent(flame_shock) and BuffPresent(unleash_flame) Spell(flame_shock)
		Spell(earth_shock)
		if BuffPresent(maelstrom_weapon) >1 and not BuffPresent(ascendance) Spell(lightning_bolt)
	}
	if Enemies() >1 
	{
		if not TotemPresent(fire) Spell(searing_totem)
		Spell(stormstrike)
		Spell(unleash_elements)
		Spell(fire_nova)
		if Enemies() >2 and {BuffPresent(maelstrom_weapon) ==5 or {ArmorSetParts(T13 more 4) ==1 and BuffPresent(maelstrom_weapon) >=4 and False() } } Spell(chain_lightning)
		if BuffPresent(maelstrom_weapon) ==5 or {ArmorSetParts(T13 more 4) ==1 and BuffPresent(maelstrom_weapon) >=4 and False() } Spell(lightning_bolt)
		if not target.DebuffPresent(flame_shock) Spell(flame_shock)
		if Enemies() >2 and BuffPresent(maelstrom_weapon) >1 Spell(chain_lightning)
		if BuffPresent(maelstrom_weapon) >1 Spell(lightning_bolt)
	}
}
AddIcon mastery=2 help=offgcd
{
	Spell(wind_shear)
	
	{
		Spell(lava_lash)
		if TalentPoints(ancestral_swiftness) and BuffPresent(maelstrom_weapon) <2 Spell(ancestral_swiftness)
		Spell(spiritwalkers_grace)
	}
	if Enemies() >1 
	{
		if Enemies() >5 and not TotemPresent(fire) Spell(magma_totem)
		Spell(lava_lash)
	}
}
AddIcon mastery=2 help=cd
{
	if target.HealthPercent() <25 or TimeInCombat() >5 Spell(bloodlust)
	 { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
	
	{
		Spell(blood_fury)
		if TalentPoints(elemental_mastery) Spell(elemental_mastery)
		if not TotemPresent(fire) and {BuffPresent(bloodlust) or BuffPresent(elemental_mastery) or target.DeadIn() <=0 +10 or {TalentPoints(elemental_mastery) and {SpellCooldown(elemental_mastery) ==0 or SpellCooldown(elemental_mastery) >80 } or TimeInCombat() >=60 } } Spell(fire_elemental_totem)
		Spell(ascendance)
		Spell(feral_spirit)
		if not Spell(earth_elemental_totem)
	}
	if Enemies() >1 
	{
		Spell(feral_spirit)
	}
}
]]