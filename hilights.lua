drawhilights = function()

--if cbstyle == "magic" then
  -- combust is hilighted only when conflagrate is active and it isn't on cooldown
  abilities.combust.hilight = buffs.conflagrate.active and not abilities.combust.isoncd
  -- runic charge hilights
  abilities.sonic.hilight   = buffs.runiccharge.active
  abilities.conc.hilight    = buffs.runiccharge.active
  -- dragon breath is also hilighted when your target is combusted and it isn't on cooldown
  abilities.dbreath.hilight = (buffs.runiccharge.active) or (buffs.combust.active and not abilities.dbreath.isoncd)
  -- wild magic is hilighted when it is available, not on cooldown
  abilities.wildmagic.hilight = not abilities.wildmagic.isgrey and not abilities.wildmagic.isoncd or not buffs.blast.active
  -- magic eofs are used as filler or when adrenaline is too high with nothing to spend it on
  -- thus eof is hilighted when there is excess adrenaline (and being able to use tsunami or sunshine soon isn't a concern)
  -- or when there is an opportunity while omnipower is on cooldown
  abilities.eof.hilight = (buffs.sunshine.active or abilities.sunshine.isoncd) and (buffs.tsunami.active or abilities.tsunami.isoncd) and ( (stats.adrenaline.fraction >= 0.8) or (abilities.omnipower.isoncd and stats.adrenaline.fraction >= 0.5) )
  -- the special attack slot is hilighted when it is available, the roar of awakening is equipped, the soulfire special attack is not on cooldown, conc IS on cooldown, and adrenaline is over ~50%
  print(abilities.spec.isgrey, equipment.roar.isequipped, buffs.soulfire.active, abilities.conc.isoncd, stats.adrenaline.fraction)
  abilities.spec.hilight = not abilities.spec.isgrey and equipment.roar.isequipped and not buffs.soulfire.active and abilities.conc.isoncd and stats.adrenaline.fraction >= 0.5
  --abilities.cblast.hilight = not abilities.cblast.isgrey and abilities.combust.isoncd and abilities.wildmagic.isoncd and not abilities.sunshine.active
  abilities.smtendrils.hilight = not abilities.smtendrils.isgrey and buffs.tsunami.active and stats.adrenaline.fraction <= 0.4 and not abilities.smtendrils.isoncd
  abilities.sunshine.hilight = not abilities.sunshine.isgrey and not (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.sunshine.isoncd
  abilities.tsunami.hilight = not abilities.tsunami.isgrey and (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.tsunami.isoncd
  abilities.omnipower.hilight = not abilities.omnipower.isgrey and (buffs.sunshine.active or buffs.gsunshine.active) and buffs.tsunami.active and not abilities.omnipower.isoncd
--elseif cbstyle == "melee" then
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
--elseif cbstyle == "ranged" then
  abilities.galeshot.hilight = not abilities.galeshot.isgrey and not abilities.galeshot.isoncd and not abilities.rapidfire.isoncd and (abilities.deathsswiftness.isoncd or abilities.deathsswiftness.isoncd)
  abilities.shtendrils.hilight = buffs.shadows.active and not abilities.shtendrils.isoncd
  abilities.rapidfire.hilight = buffs.winds.active and not abilities.rapidfire.isoncd
  abilities.deathsswiftness.hilight = not abilities.deathsswiftness.isgrey and not (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.deathsswiftness.isoncd
  abilities.shadows.hilight = not abilities.shadows.isgrey and (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.shadows.isoncd
--elseif cbstyle == "necromancy" then
  abilities.finger.hilight = buffs.necrosis.active and (buffs.necrosis.number or 0) >= 6 or false
  abilities.volley.hilight = buffs.residualsouls.active and ((equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 5) or (not equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 3))
  abilities.cmdzom.hilight = buffs.putridzombie.active and (buffs.putridzombie.number or 0) <=5 or false
  abilities.cmdphant.hilight = buffs.phantomguardian.active and (buffs.phantomguardian.parensnumber or 0) >= 13 or false
  abilities.skulls.hilight = buffs.livingdeath.active and not abilities.skulls.isoncd
  abilities.necroauto.hilight = buffs.deathspark.active
  abilities.livingdeath.hilight = not abilities.livingdeath.isgrey and not buffs.livingdeath.active and not abilities.livingdeath.isoncd

  
--end
  hilightabilities()
end