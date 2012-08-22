Ovale.defaut["PALADIN"] = [[Define(avenging_wrath 31884)
  SpellInfo(avenging_wrath duration=20 cd=180 )
  SpellAddBuff(avenging_wrath avenging_wrath=1)
Define(blessing_of_kings 20217)
  SpellInfo(blessing_of_kings duration=3600 )
  SpellAddBuff(blessing_of_kings blessing_of_kings=1)
Define(blessing_of_might 19740)
  SpellInfo(blessing_of_might duration=3600 )
  SpellAddBuff(blessing_of_might blessing_of_might=1)
Define(crusader_strike 35395)
  SpellInfo(crusader_strike holy=-1 cd=4.5 )
Define(divine_purpose 86172)
Define(execution_sentence 114157)
  SpellInfo(execution_sentence cd=60 )
Define(exorcism 879)
  SpellInfo(exorcism holy=-1 cd=15 )
Define(guardian_of_ancient_kings 86659)
  SpellInfo(guardian_of_ancient_kings duration=12 cd=180 )
  SpellAddBuff(guardian_of_ancient_kings guardian_of_ancient_kings=1)
Define(hammer_of_wrath 24275)
  SpellInfo(hammer_of_wrath holy=-0 cd=6 )
Define(inquisition 84963)
  SpellInfo(inquisition duration=10 holy=1 )
  SpellAddBuff(inquisition inquisition=1)
Define(judgment 20271)
  SpellInfo(judgment cd=6 )
Define(rebuke 96231)
  SpellInfo(rebuke duration=4 cd=15 )
Define(seal_of_insight 20165)
  SpellAddBuff(seal_of_insight seal_of_insight=1)
Define(seal_of_truth 31801)
  SpellAddBuff(seal_of_truth seal_of_truth=1)
Define(templars_verdict 55112)
AddIcon mastery=3 help=main
{
	if ManaPercent() >=90 or BuffExpires(seal) Spell(seal_of_truth)
	if ManaPercent() <=20 Spell(seal_of_insight)
	if {BuffExpires(inquisition) or BuffRemains(inquisition) <=2 } and {HolyPower() >=3 or BuffPresent(divine_purpose) } Spell(inquisition)
	if BuffPresent(inquisition) and TimeInCombat() >=15 Spell(execution_sentence)
	Spell(hammer_of_wrath)
	Spell(exorcism)
	Spell(crusader_strike)
	Spell(judgment)
}
AddIcon mastery=3 help=offgcd
{
	if target.IsInterruptible() Spell(rebuke)
	if HolyPower() ==5 or BuffPresent(divine_purpose) Spell(templars_verdict)
	if HolyPower() >=3 Spell(templars_verdict)
}
AddIcon mastery=3 help=cd
{
	if SpellCooldown(avenging_wrath) <10 and BuffPresent(inquisition) Spell(guardian_of_ancient_kings)
	if BuffPresent(inquisition) and {SpellCooldown(guardian_of_ancient_kings) >0 and SpellCooldown(guardian_of_ancient_kings) <291 } Spell(avenging_wrath)
	if BuffPresent(inquisition) and TimeInCombat() >=14  { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
}
]]