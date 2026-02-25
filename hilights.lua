drawhilights = function()

  abilities.combust.hilight = buffs.conflagrate.active
  abilities.sonic.hilight   = buffs.runiccharge.active
  abilities.conc.hilight    = buffs.runiccharge.active
  abilities.dbreath.hilight = (buffs.runiccharge.active or buffs.combust.active)

  abilities.assault.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.flurry.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.hurricane.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.gbarge.hilight = buffs.gbarge.active
  abilities.overpower.hilight = buffs.berserk.active

  abilities.finger.hilight = buffs.necrosis.active and (buffs.necrosis.number or 0) >= 6 or false
  abilities.volley.hilight = buffs.residualsouls.active and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) >= 3
  abilities.cmdzom.hilight = buffs.putridzombie.active and (buffs.putridzombie.number or 0) <=5 or false
  abilities.cmdphant.hilight = buffs.phantomguardian.active and (buffs.phantomguardian.parensnumber or 0) >= 13 or false
  abilities.skulls.hilight = buffs.livingdeath.active

  hilightabilities()

end