drawhilights = function()

  abilities.combust.hilight = buffs.conflagrate.active and not abilities.combust.isoncd
  abilities.sonic.hilight   = buffs.runiccharge.active
  abilities.conc.hilight    = buffs.runiccharge.active
  abilities.dbreath.hilight = (buffs.runiccharge.active or buffs.combust.active) and not abilities.dbreath.isoncd
  abilities.sunshine.hilight = not abilities.sunshine.isgrey and not (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.sunshine.isoncd
  abilities.tsunami.hilight = not abilities.tsunami.isgrey and (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.tsunami.isoncd
  abilities.omnipower.hilight = not abilities.omnipower.isgrey and (buffs.sunshine.active or buffs.gsunshine.active) and buffs.tsunami.active and not abilities.omnipower.isoncd

  abilities.assault.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.flurry.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.hurricane.hilight = buffs.bloodlust.active and (buffs.bloodlust.number or 0) >= 4 or false
  abilities.gbarge.hilight = buffs.gbarge.active
  abilities.overpower.hilight = buffs.berserk.active and not abilities.overpower.isoncd
  abilities.meteor.hilight = not abilities.meteor.isgrey and not abilities.meteor.isoncd
  if abilities.meteor.active then
    abilities.berserk.hilight = not abilities.berserk.isgrey and buffs.meteor.active and not abilities.berserk.isoncd
  else
    abilities.berserk.hilight = not abilities.berserk.isgrey and not abilities.berserk.isoncd
  end

  abilities.shtendrils.hilight = buffs.shadows.active and not abilities.shtendrils.isoncd
  abilities.rapidfire.hilight = buffs.winds.active and not abilities.rapidfire.isoncd
  abilities.deathsswiftness.hilight = not abilities.deathsswiftness.isgrey and not (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.deathsswiftness.isoncd
  abilities.shadows.hilight = not abilities.shadows.isgrey and (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.shadows.isoncd

  abilities.finger.hilight = buffs.necrosis.active and (buffs.necrosis.number or 0) >= 6 or false
  abilities.volley.hilight = buffs.residualsouls.active and ((equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 5) or (not equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 3))
  abilities.cmdzom.hilight = buffs.putridzombie.active and (buffs.putridzombie.number or 0) <=5 or false
  abilities.cmdphant.hilight = buffs.phantomguardian.active and (buffs.phantomguardian.parensnumber or 0) >= 13 or false
  abilities.skulls.hilight = buffs.livingdeath.active and not abilities.skulls.isoncd
  abilities.necroauto.hilight = buffs.deathspark.active
  abilities.livingdeath.hilight = not abilities.livingdeath.isgrey and not buffs.livingdeath.active and not abilities.livingdeath.isoncd

  hilightabilities()

end