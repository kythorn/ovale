Ovale.defaut["WARRIOR"] = [[Define(avatar 107574)
  SpellInfo(avatar duration=20 cd=180 )
  SpellAddBuff(avatar avatar=1)
Define(battle_shout 6673)
  SpellInfo(battle_shout cd=60 )
  SpellAddBuff(battle_shout battle_shout=1)
Define(battle_stance 2457)
  SpellInfo(battle_stance cd=3 )
Define(berserker_rage 18499)
  SpellInfo(berserker_rage cd=30 )
  SpellAddBuff(berserker_rage berserker_rage=1)
Define(bladestorm 46924)
  SpellInfo(bladestorm cd=90 )
Define(bloodbath 12292)
  SpellInfo(bloodbath duration=12 cd=60 )
  SpellAddBuff(bloodbath bloodbath=1)
Define(bloodsurge 46915)
Define(bloodthirst 23881)
  SpellInfo(bloodthirst rage=-10 cd=4.5 )
Define(colossus_smash 86346)
  SpellInfo(colossus_smash duration=6.5 cd=20 )
  SpellAddTargetDebuff(colossus_smash colossus_smash=1)
Define(deadly_calm 85730)
  SpellInfo(deadly_calm cd=60 )
  SpellAddBuff(deadly_calm deadly_calm=1)
Define(defensive_stance 71)
Define(dragon_roar 118000)
  SpellInfo(dragon_roar cd=60 )
Define(enrage 13046)
Define(execute 5308)
  SpellInfo(execute rage=30 )
Define(heroic_leap 6544)
  SpellInfo(heroic_leap cd=45 )
  AddCheckBox(heroic_leap_check SpellName(heroic_leap))
Define(heroic_strike 78)
  SpellInfo(heroic_strike rage=30 cd=1.5 )
Define(heroic_throw 57755)
  SpellInfo(heroic_throw cd=30 )
Define(last_stand 12975)
  SpellInfo(last_stand duration=20 cd=180 )
  SpellAddBuff(last_stand last_stand=1)
Define(mortal_strike 12294)
  SpellInfo(mortal_strike rage=-10 cd=6 )
  SpellAddTargetDebuff(mortal_strike mortal_wounds=1)
Define(overpower 7384)
  SpellAddBuff(overpower taste_for_blood=-1)
Define(raging_blow 85288)
  SpellInfo(raging_blow rage=10 )
  SpellAddTargetDebuff(raging_blow raging_blow_aura=-1)
Define(raging_blow_aura 131116)
Define(recklessness 1719)
  SpellInfo(recklessness cd=300 )
  SpellAddBuff(recklessness recklessness=1)
Define(revenge 6572)
  SpellInfo(revenge rage=-10 cd=9 )
Define(shield_block 2565)
  SpellInfo(shield_block duration=6 rage=60 cd=1.5 )
  SpellAddBuff(shield_block shield_block=1)
Define(shield_slam 23922)
  SpellInfo(shield_slam rage=-15 cd=6 )
Define(shockwave 46968)
  SpellInfo(shockwave cd=20 )
Define(slam 1464)
  SpellInfo(slam rage=30 )
Define(storm_bolt 107570)
  SpellInfo(storm_bolt cd=30 )
Define(wild_strike 100130)
  SpellInfo(wild_strike duration=10 rage=30 )
  SpellAddTargetDebuff(wild_strike wild_strike=1)
  SpellAddBuff(wild_strike bloodsurge=-1)
AddIcon mastery=1 help=main
{
    unless InCombat()
    {
        unless Stance(1) Spell(battle_stance)
    }
    if { target.DebuffRemains(colossus_smash) >=5 or SpellCooldown(colossus_smash) <=4 } and Rage() >=80 Spell(deadly_calm)
    if TalentPoints(bloodbath) and {{SpellCooldown(recklessness) >=60 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and {target.DeadIn() <=162 or {target.DeadIn() <=312 and not ArmorSetParts(T14 more 4) } } and target.DeadIn() >70 } } Spell(bloodbath)
    if not {BuffPresent(enrage) or Rage() >=100 } Spell(berserker_rage)
    if  target.DebuffPresent(colossus_smash) if CheckBoxOn(heroic_leap_check) Spell(heroic_leap)
    Spell(mortal_strike)
    Spell(colossus_smash)
    if Rage() >=90 if target.HealthPercent(less 20) Spell(execute)
    Spell(overpower usable=1)
    if TalentPoints(storm_bolt) Spell(storm_bolt)
    if not TalentPoints(storm_bolt) Spell(heroic_throw)
    if {Rage() <70 } and not  target.DebuffPresent(colossus_smash) Spell(battle_shout)
    if target.HealthPercent(less 20) Spell(execute)
    Spell(slam)
    if Rage() <70 Spell(battle_shout)
}
AddIcon mastery=1 help=offgcd
{
    if {{{ target.DebuffPresent(colossus_smash) and Rage() >=70 } or {Rage() >=100 } } and target.HealthPercent() >=20 } Spell(heroic_strike)
}
AddIcon mastery=1 help=aoe
{
    if TalentPoints(shockwave) Spell(shockwave)
    if TalentPoints(dragon_roar) Spell(dragon_roar)
    if TalentPoints(bladestorm) and {Rage() <=60 and SpellCooldown(colossus_smash) >=5 } Spell(bladestorm)
}
AddIcon mastery=1 help=cd
{
    if {SpellCooldown(recklessness) >=60 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and {target.DeadIn() <=162 or {target.DeadIn() <=312 and not ArmorSetParts(T14 more 4) } } and target.DeadIn() >70 }  { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
    if { target.DebuffRemains(colossus_smash) >=5 or SpellCooldown(colossus_smash) <=4 } and {{not TalentPoints(avatar) or not ArmorSetParts(T14 more 4) } and {{target.HealthPercent() <20 or target.DeadIn() >310 or {target.DeadIn() >160 and ArmorSetParts(T14 more 4) } } } or {TalentPoints(avatar) and ArmorSetParts(T14 more 4) and BuffPresent(avatar) } } Spell(recklessness)
    if TalentPoints(avatar) and {{SpellCooldown(recklessness) >=180 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and target.DeadIn() >195 } or {target.HealthPercent() <20 and ArmorSetParts(T14 more 4) } } Spell(avatar)
}
AddIcon mastery=2 help=main
{
    unless InCombat()
    {
        unless Stance(1) Spell(battle_stance)
    }
    if { target.DebuffRemains(colossus_smash) >=5 or SpellCooldown(colossus_smash) <=4 } and Rage() >=80 Spell(deadly_calm)
    if TalentPoints(bloodbath) and {{SpellCooldown(recklessness) >=60 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and {target.DeadIn() <=162 or {target.DeadIn() <=312 and not ArmorSetParts(T14 more 4) } } and target.DeadIn() >70 } } Spell(bloodbath)
    if not {BuffPresent(enrage) or {BuffStacks(raging_blow_aura) ==2 and target.HealthPercent() >=20 } or Rage() >=100 } Spell(berserker_rage)
    if  target.DebuffPresent(colossus_smash) if CheckBoxOn(heroic_leap_check) Spell(heroic_leap)
    Spell(bloodthirst)
    Spell(colossus_smash)
    if target.HealthPercent(less 20) Spell(execute)
    if BuffPresent(bloodsurge) and target.HealthPercent() >=20 Spell(wild_strike)
    if BuffStacks(raging_blow_aura) ==2 and target.HealthPercent() >=20 Spell(raging_blow)
    if TalentPoints(storm_bolt) Spell(storm_bolt)
    if not TalentPoints(storm_bolt) Spell(heroic_throw)
    if {Rage() <70 } and not  target.DebuffPresent(colossus_smash) Spell(battle_shout)
    if BuffPresent(raging_blow_aura) and target.HealthPercent() >=20 Spell(raging_blow)
    if target.HealthPercent() >=20 and not {SpellCooldown(colossus_smash) <=6 and {Rage() <=60 } } Spell(wild_strike)
    if Rage() <70 Spell(battle_shout)
}
AddIcon mastery=2 help=offgcd
{
    if {{{ target.DebuffPresent(colossus_smash) and Rage() >=70 } or {Rage() >=100 } } and target.HealthPercent() >=20 } Spell(heroic_strike)
}
AddIcon mastery=2 help=aoe
{
    if TalentPoints(shockwave) Spell(shockwave)
    if TalentPoints(dragon_roar) Spell(dragon_roar)
    if TalentPoints(bladestorm) and {Rage() <=60 and SpellCooldown(colossus_smash) >=5 and SpellCooldown(bloodthirst) >=2 } Spell(bladestorm)
}
AddIcon mastery=2 help=cd
{
    if {SpellCooldown(recklessness) >=60 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and {target.DeadIn() <=162 or {target.DeadIn() <=312 and not ArmorSetParts(T14 more 4) } } and target.DeadIn() >70 }  { Item(Trinket0Slot usable=1) Item(Trinket1Slot usable=1) } 
    if { target.DebuffRemains(colossus_smash) >=5 or SpellCooldown(colossus_smash) <=4 } and {{not TalentPoints(avatar) or not ArmorSetParts(T14 more 4) } and {{target.HealthPercent() <20 or target.DeadIn() >310 or {target.DeadIn() >160 and ArmorSetParts(T14 more 4) } } } or {TalentPoints(avatar) and ArmorSetParts(T14 more 4) and BuffPresent(avatar) } } Spell(recklessness)
    if TalentPoints(avatar) and {{SpellCooldown(recklessness) >=180 or BuffPresent(recklessness) } or {target.HealthPercent() >=20 and target.DeadIn() >195 } or {target.HealthPercent() <20 and ArmorSetParts(T14 more 4) } } Spell(avatar)
}
AddIcon mastery=3 help=main
{
    unless Stance(3) Spell(defensive_stance)
    Spell(berserker_rage)
    Spell(shield_block)
    Spell(shield_slam)
    Spell(revenge)
    Spell(battle_shout)
}
AddIcon mastery=3 help=offgcd
{
    if Rage() >=50 Spell(heroic_strike)
}
AddIcon mastery=3 help=aoe
{
    Spell(shockwave)
}
AddIcon mastery=3 help=cd
{
    if Health() <30000 Spell(last_stand)
}
]]