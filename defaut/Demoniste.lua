Ovale.defaut["WARLOCK"] = [[Define(agony 980)
  SpellInfo(agony duration=24 tick=2 )
  SpellAddTargetDebuff(agony agony=1)
Define(backdraft 117896)
Define(blood_fury 20572)
  SpellInfo(blood_fury duration=15 cd=120 )
  SpellAddBuff(blood_fury blood_fury=1)
Define(chaos_bolt 116858)
  SpellInfo(chaos_bolt burningembers=10 )
Define(conflagrate 56270)
Define(corruption 172)
  SpellInfo(corruption duration=18 tick=2 )
  SpellAddTargetDebuff(corruption corruption=1)
Define(curse_of_the_elements 1490)
  SpellInfo(curse_of_the_elements duration=300 )
  SpellAddBuff(curse_of_the_elements curse_of_the_elements=1)
Define(dark_intent 109773)
  SpellInfo(dark_intent duration=3600 )
  SpellAddBuff(dark_intent dark_intent=1)
Define(dark_soul 77801)
  SpellInfo(dark_soul cd=120 )
Define(doom 603)
  SpellInfo(doom duration=60 demonicfury=60 tick=15 )
  SpellAddTargetDebuff(doom doom=1)
Define(drain_soul 1120)
  SpellInfo(drain_soul duration=12 tick=2 )
  SpellAddTargetDebuff(drain_soul drain_soul=1)
Define(fel_flame 77799)
Define(felguard_felstorm 103134)
Define(fire_and_brimstone 108683)
  SpellInfo(fire_and_brimstone burningembers=10 cd=1 )
  SpellAddBuff(fire_and_brimstone fire_and_brimstone=1)
Define(grimoire_of_sacrifice 108503)
  SpellInfo(grimoire_of_sacrifice duration=1200 cd=120 )
  SpellAddBuff(grimoire_of_sacrifice grimoire_of_sacrifice=1)
Define(hand_of_guldan 56268)
Define(harvest_life 108371)
  SpellInfo(harvest_life duration=6 demonicfury=30 tick=1 )
  SpellAddTargetDebuff(harvest_life harvest_life=1)
Define(haunt 48181)
  SpellInfo(haunt duration=8 shards=1 )
  SpellAddBuff(haunt haunt=1)
Define(havoc 80240)
  SpellInfo(havoc duration=15 cd=45 )
  SpellAddBuff(havoc havoc=1)
Define(hellfire 1949)
  SpellInfo(hellfire duration=14 tick=1 )
  SpellAddTargetDebuff(hellfire hellfire=1)
Define(immolate 348)
  SpellInfo(immolate duration=15 tick=3 )
  SpellAddTargetDebuff(immolate immolate=1)
Define(immolation_aura 104025)
  SpellInfo(immolation_aura duration=10 demonicfury=0 )
  SpellAddBuff(immolation_aura immolation_aura=1)
Define(imp_swarm 104316)
  SpellInfo(imp_swarm cd=120 )
Define(incinerate 29722)
Define(life_tap 63941)
Define(malefic_grasp 103103)
  SpellInfo(malefic_grasp duration=4 tick=1 )
  SpellAddTargetDebuff(malefic_grasp malefic_grasp=1)
Define(melee 103988)
Define(metamorphosis 103958)
  SpellInfo(metamorphosis demonicfury=0 cd=10 )
  SpellAddBuff(metamorphosis metamorphosis=1)
Define(molten_core 122351)
Define(rain_of_fire 5740)
  SpellInfo(rain_of_fire duration=6 )
  SpellAddBuff(rain_of_fire rain_of_fire=1)
Define(seed_of_corruption 27243)
  SpellInfo(seed_of_corruption duration=18 tick=3 )
  SpellAddTargetDebuff(seed_of_corruption seed_of_corruption=1)
Define(service_felguard 111898)
  SpellInfo(service_felguard cd=120 )
Define(service_felhunter 111897)
  SpellInfo(service_felhunter cd=120 )
Define(shadow_bolt 14122)
Define(shadowburn 29341)
  SpellInfo(shadowburn duration=5 )
  SpellAddBuff(shadowburn shadowburn=1)
Define(shadowflame 63938)
Define(soul_fire 6353)
Define(soul_swap 86211)
  SpellInfo(soul_swap duration=20 )
  SpellAddBuff(soul_swap soul_swap=1)
Define(soulburn 74434)
  SpellInfo(soulburn duration=30 shards=1 cd=1 )
  SpellAddBuff(soulburn soulburn=1)
Define(soulburn_seed_of_corruption 86664)
Define(summon_doomguard 18540)
  SpellInfo(summon_doomguard cd=600 )
Define(summon_felguard 30146)
  SpellInfo(summon_felguard demonicfury=0 )
Define(summon_felhunter 691)
  SpellInfo(summon_felhunter demonicfury=0 )
Define(summon_infernal 1122)
  SpellInfo(summon_infernal cd=600 )
Define(touch_of_chaos 103964)
  SpellInfo(touch_of_chaos demonicfury=40 )
Define(unstable_affliction 31117)
  SpellInfo(unstable_affliction duration=4 )
  SpellAddBuff(unstable_affliction unstable_affliction=1)
Define(void_ray 115422)
  SpellInfo(void_ray demonicfury=40 )
Define(grimoire_of_sacrifice_talent 15)
Define(grimoire_of_service_talent 14)
Define(harvest_life_talent 3)
AddIcon mastery=1 help=main
{
	if target.DebuffExpires(magic_vulnerability) Spell(curse_of_the_elements)
	if TalentPoints(grimoire_of_service_talent) Spell(service_felhunter)
	if TalentPoints(grimoire_of_sacrifice_talent) and BuffExpires(grimoire_of_sacrifice) Spell(summon_felhunter)
	if Enemies() >3 
	{
		if {BuffExpires(soulburn) and not InFlightToTarget(seed_of_corruption) and not target.DebuffPresent(seed_of_corruption) } or {BuffPresent(soulburn) and not target.DebuffPresent(soulburn_seed_of_corruption) and not InFlightToTarget(soulburn_seed_of_corruption) } Spell(seed_of_corruption)
		if not InFlightToTarget(haunt) and target.DebuffRemains(haunt) <CastTime(haunt) +1 Spell(haunt)
		if not InFlightToTarget(fel_flame) Spell(fel_flame)
	}
	if BuffPresent(soulburn) Spell(soul_swap)
	if not InFlightToTarget(haunt) and target.DebuffRemains(haunt) <target.NextTick(haunt) +1 +CastTime(haunt) Spell(haunt)
	if Enemies() >1 and TimeInCombat() <10 Spell(soul_swap)
	if not InFlightToTarget(haunt) and target.DebuffRemains(haunt) <target.NextTick(haunt) +1 +CastTime(haunt) and SoulShards() >1 Spell(haunt)
	if {not target.DebuffPresent(agony) or target.DebuffRemains(agony) <=TickTime(drain_soul) *2 } and target.DeadIn() >=8 Spell(agony)
	if {not target.DebuffPresent(corruption) or target.DebuffRemains(corruption) <target.NextTick(corruption) } and target.DeadIn() >=6 Spell(corruption)
	if {not target.DebuffPresent(unstable_affliction) or target.DebuffRemains(unstable_affliction) <{CastTime(unstable_affliction) +target.NextTick(unstable_affliction) } } and target.DeadIn() >=5 Spell(unstable_affliction)
	if TicksRemain(agony) <Ticks(agony) /2 and target.DeadIn() >=8 Spell(agony)
	if TicksRemain(corruption) <Ticks(corruption) /2 and target.DeadIn() >=6 Spell(corruption)
	if TicksRemain(unstable_affliction) <Ticks(unstable_affliction) /2 +1 and target.DeadIn() >=5 Spell(unstable_affliction)
	if target.HealthPercent() <=20 Spell(drain_soul)
	Spell(malefic_grasp)
	Spell(fel_flame)
}
AddIcon mastery=1 help=offgcd
{
	if Enemies() >3 
	{
		if BuffExpires(soulburn) and not target.DebuffPresent(soulburn_seed_of_corruption) and not InFlightToTarget(soulburn_seed_of_corruption) Spell(soulburn)
		if ManaPercent() <70 Spell(life_tap)
	}
	if BuffPresent(dark_soul) and {BuffRemains(dark_soul) >=18.5 or BuffRemains(dark_soul) <=1.5 } Spell(soulburn)
	if ManaPercent() <35 Spell(life_tap)
	if ManaPercent() <80 and ManaPercent() <target.HealthPercent() Spell(life_tap)
	Spell(life_tap)
}
AddIcon mastery=1 help=cd
{
	 { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
	Spell(blood_fury)
	Spell(dark_soul)
	if TalentPoints(grimoire_of_sacrifice_talent) Spell(grimoire_of_sacrifice)
	if Enemies() >3 
	{
		Spell(summon_doomguard)
		if Enemies() >=7 Spell(summon_infernal)
	}
	Spell(summon_doomguard)
}
AddIcon mastery=2 help=main
{
	if target.DebuffExpires(magic_vulnerability) Spell(curse_of_the_elements)
	if TalentPoints(grimoire_of_service_talent) Spell(service_felguard)
	if TalentPoints(grimoire_of_sacrifice_talent) and BuffExpires(grimoire_of_sacrifice) Spell(summon_felguard)
	if Enemies() >5 
	{
		if {not target.DebuffPresent(corruption) or target.DebuffRemains(corruption) <target.NextTick(corruption) } and target.DeadIn() >=6 Spell(corruption)
		Spell(immolation_aura)
		if target.DebuffRemains(corruption) <10 Spell(void_ray)
		if {not target.DebuffPresent(doom) or target.DebuffRemains(doom) <40 } and target.DeadIn() >30 Spell(doom)
		Spell(void_ray)
		if TalentPoints(harvest_life_talent) Spell(harvest_life)
		if not TalentPoints(harvest_life_talent) Spell(hellfire)
	}
	if {not target.DebuffPresent(corruption) or target.DebuffRemains(corruption) <target.NextTick(corruption) } and target.DeadIn() >=6 Spell(corruption)
	if {not target.DebuffPresent(doom) or target.DebuffRemains(doom) <target.NextTick(doom) or {TicksRemain(doom) +1 <{target.TicksRemain(doom) + Ticks(doom) } and BuffPresent(dark_soul) } } and target.DeadIn() >=30 Spell(doom)
	if target.DebuffRemains(corruption) >15 and BuffExpires(dark_soul) and DemonicFury() <=750 and target.DeadIn() >30 cancel.Texture(Spell_shadow_demonform)
	if BuffPresent(molten_core) and {BuffExpires(metamorphosis) or target.HealthPercent() <25 } Spell(soul_fire)
	Spell(touch_of_chaos)
	Spell(shadow_bolt)
	Spell(fel_flame)
}
AddIcon mastery=2 help=offgcd
{
	Spell(melee)
	Spell(felguard_felstorm)
	if Enemies() >5 
	{
		Spell(hand_of_guldan)
		if DemonicFury() >=1000 or DemonicFury() >=31 *target.DeadIn() Spell(metamorphosis)
		Spell(life_tap)
	}
	if BuffPresent(dark_soul) or target.DebuffRemains(corruption) <5 or DemonicFury() >=900 or DemonicFury() >=target.DeadIn() *30 Spell(metamorphosis)
	if not InFlightToTarget(hand_of_guldan) and target.DebuffRemains(shadowflame) <1 +CastTime(shadow_bolt) Spell(hand_of_guldan)
	if ManaPercent() <50 Spell(life_tap)
	Spell(life_tap)
}
AddIcon mastery=2 help=cd
{
	 { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
	Spell(blood_fury)
	Spell(dark_soul)
	if TalentPoints(grimoire_of_sacrifice_talent) Spell(grimoire_of_sacrifice)
	if Enemies() >5 
	{
		Spell(summon_doomguard)
		if Enemies() >=7 Spell(summon_infernal)
		if BuffExpires(metamorphosis) Spell(imp_swarm)
	}
	Spell(summon_doomguard)
	Spell(imp_swarm)
}
AddIcon mastery=3 help=main
{
	if target.DebuffExpires(magic_vulnerability) Spell(curse_of_the_elements)
	if TalentPoints(grimoire_of_service_talent) Spell(service_felhunter)
	if TalentPoints(grimoire_of_sacrifice_talent) and BuffExpires(grimoire_of_sacrifice) Spell(summon_felhunter)
	if Enemies() >2 
	{
		if not target.DebuffPresent(rain_of_fire) and not InFlightToTarget(rain_of_fire) Spell(rain_of_fire)
		if BuffPresent(fire_and_brimstone) and not target.DebuffPresent(immolate) Spell(immolate)
		if BuffPresent(fire_and_brimstone) Spell(incinerate)
		if not target.DebuffPresent(immolate) Spell(immolate)
	}
	if Enemies() >1 Spell(havoc)
	if BurningEmbers() and BuffStacks(backdraft) <3 Spell(chaos_bolt)
	if TicksRemain(immolate) <Ticks(immolate) /2 and target.DeadIn() >=5 Spell(immolate)
	Spell(incinerate)
}
AddIcon mastery=3 help=offgcd
{
	if Enemies() >2 
	{
		if BurningEmbers() and BuffExpires(fire_and_brimstone) Spell(fire_and_brimstone)
		if BurningEmbers() and BuffPresent(fire_and_brimstone) Spell(conflagrate)
	}
	if BurningEmbers() Spell(shadowburn)
	if BuffExpires(backdraft) Spell(conflagrate)
}
AddIcon mastery=3 help=cd
{
	 { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
	Spell(blood_fury)
	Spell(dark_soul)
	if TalentPoints(grimoire_of_sacrifice_talent) Spell(grimoire_of_sacrifice)
	if Enemies() >2 
	{
		Spell(summon_doomguard)
		if Enemies() >=7 Spell(summon_infernal)
	}
	Spell(summon_doomguard)
}
]]