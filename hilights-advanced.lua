drawhilights = function()

--if cbstyle == "magic" then
  local function critablesused()
    return (
        --checks if any of these abilities have a cooldown elapsed time of 2 or under; basically, if they've been used in the last global cooldown
        (abilities.wildmagic.isoncd and abilities.wildmagic.cdmax and abilities.wildmagic.cdmax - abilities.wildmagic.cdnumber <= 2) or 
        (abilities.omnipower.isoncd and abilities.omnipower.cdmax and abilities.omnipower.cdmax - abilities.omnipower.cdnumber <= 2) or 
        (abilities.dbreath.isoncd and abilities.dbreath.cdmax and abilities.dbreath.cdmax - abilities.dbreath.cdnumber <= 2) or
        (abilities.asphyxiate.isoncd and abilities.asphyxiate.cdmax and abilities.asphyxiate.cdmax - abilities.asphyxiate.cdnumber <= 2) or
        (abilities.conc.isoncd and abilities.conc.cdmax and abilities.conc.cdmax - abilities.conc.cdnumber >= 3)
    )
  end
  local function concused()
    return (abilities.conc.isoncd and abilities.conc.cdmax and abilities.conc.cdmax - abilities.conc.cdnumber <= 2)
  end
  if critablesused() then
    abilities.conc.buff = false
  end
  if concused() then
    abilities.conc.buff = true
  end
  -- hilight critable abilities as high priority right after concentrated blast is used
  abilities.sunshine.highprio = true
  abilities.tsunami.highprio = true
  -- combust is hilighted only when conflagrate is active and it isn't on cooldown
  abilities.combust.hilight = (buffs.conflagrate.active or (equipment.roar.isequipped and abilities.wildmagic.isoncd)) and not abilities.combust.isoncd

  -- runic charge hilights
  abilities.sonic.hilight   = buffs.runiccharge.active
  abilities.conc.hilight    = buffs.runiccharge.active

  -- dragon breath is also hilighted when your target is combusted and it isn't on cooldown
  abilities.dbreath.hilight = (buffs.runiccharge.active) or (buffs.combust.active and not abilities.dbreath.isoncd)

  -- wild magic is hilighted when it is available and not on cooldown, unless adrenaline is filling up and sunshine hasn't been used
  abilities.wildmagic.hilight = (not abilities.wildmagic.isgrey and not abilities.wildmagic.isoncd and abilities.conc.buff) and not (stats.adrenaline.fraction >= 1 and not ((((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd)) or (buffs.tsunami.active or abilities.tsunami.isoncd)))

  -- magic eofs are used as filler or when adrenaline is too high with nothing to spend it on
  -- thus eof is hilighted when there is excess adrenaline (and being able to use tsunami or sunshine soon isn't a concern)
  -- or when there is an opportunity while omnipower is on cooldown
  abilities.eof.hilight = ((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd) and (buffs.tsunami.active or abilities.tsunami.isoncd) and ( (stats.adrenaline.fraction >= 0.8) or (abilities.omnipower.isoncd and stats.adrenaline.fraction >= 0.5) )

  -- this pertains to soulfire, it is hilighted when it is available, the roar of awakening is equipped, the soulfire special attack is not on cooldown, and adrenaline is over ~50%
  abilities.spec.hilight = not abilities.spec.isgrey and equipment.roar.isequipped and not buffs.soulfire.active and stats.adrenaline.fraction >= 0.5
  if not abilities.spec.hilight then
  abilities.spec.hilight = not abilities.spec.isgrey and not equipment.roar.isequipped and not equipment.fsoa.isequipped and abilities.conc.isoncd and abilities.conc.buff
  end
  -- smoke tendrils is hilighted when under the tsunami buff and adrenaline is low
  abilities.smtendrils.hilight = not abilities.smtendrils.isgrey and buffs.tsunami.active and stats.adrenaline.fraction <= 0.4 and not abilities.smtendrils.isoncd

  -- sunshine is hilighted when it is available to be used, not currently active, and not on cooldown
  abilities.sunshine.hilight = not (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.sunshine.isoncd

  -- tsunami is hilighted when it is available, sunshine is active, and it is not on cooldown
  abilities.tsunami.hilight = (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.tsunami.isoncd

  -- omnipower is hilighted when it is available, sunshine and tsunami are active, and it is not on cooldown
  abilities.omnipower.hilight = not abilities.omnipower.isgrey and abilities.conc.buff and (((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd) or (buffs.tsunami.active or abilities.tsunami.isoncd)) and not abilities.omnipower.isoncd

  -- high priority hilights for good critable abilities
  if abilities.conc.buff then
    abilities.wildmagic.highprio, abilities.omnipower.highprio, abilities.eof.highprio = true, true, true
    --abilities.wildmagic.hilight, abilities.omnipower.hilight, abilities.eof.hilight = true, true, true
  end




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
  abilities.livingdeath.highprio = true
  abilities.finger.hilight = buffs.necrosis.active and (buffs.necrosis.number or 0) >= 6 or false
  abilities.volley.hilight = buffs.residualsouls.active and ((equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 5) or (not equipment.t95lantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 3))
  abilities.cmdzom.hilight = buffs.putridzombie.active and (buffs.putridzombie.number or 0) <=5 or false
  abilities.cmdphant.hilight = buffs.phantomguardian.active and (buffs.phantomguardian.parensnumber or 0) >= 13 or false
  abilities.skulls.hilight = buffs.livingdeath.active and not abilities.skulls.isoncd
  abilities.necroauto.hilight = buffs.deathspark.active
  abilities.livingdeath.hilight = not abilities.livingdeath.isgrey and not buffs.livingdeath.active and not abilities.livingdeath.isoncd

  
--end
  --hilightabilities()
  hilightabilities2()
end