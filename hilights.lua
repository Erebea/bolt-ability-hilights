drawhilights = function()

--if cbstyle == "magic" then                                     MAGIC HILIGHTS HERE

--[[ STANDARD HILIGHTS                -- FEATURING CRITS
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
    --checks if conc has been used
    return (abilities.conc.isoncd and abilities.conc.cdmax and abilities.conc.cdmax - abilities.conc.cdnumber <= 2)
  end
  -- based on these two functions, checks if the conc buff is active or not since there is no indicator
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
  abilities.conc.highprio = buffs.tsunami.active
  abilities.sonic.hilight   = buffs.runiccharge.active
  abilities.conc.hilight    = buffs.runiccharge.active or (buffs.tsunami.active and not abilities.conc.isoncd)

  -- dragon breath is also hilighted when your target is combusted and it isn't on cooldown
  abilities.dbreath.hilight = (buffs.runiccharge.active) or (buffs.combust.active and not abilities.dbreath.isoncd)

  -- wild magic is hilighted when it is available and not on cooldown, unless adrenaline is filling up and sunshine hasn't been used
  abilities.wildmagic.hilight = (not abilities.wildmagic.isgrey and not abilities.wildmagic.isoncd and abilities.conc.buff) and not (stats.adrenaline.fraction >= 1 and not ((((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd)) or (buffs.tsunami.active or abilities.tsunami.isoncd)))

  -- magic eofs are used as filler or when adrenaline is too high with nothing to spend it on
  -- thus eof is hilighted when there is excess adrenaline (and being able to use tsunami or sunshine soon isn't a concern)
  -- or when there is an opportunity while omnipower is on cooldown
  if not abilities.eof.hilight then
  abilities.eof.hilight = ((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd) and (buffs.tsunami.active or abilities.tsunami.isoncd) and ( (stats.adrenaline.fraction >= 0.7) or (abilities.omnipower.isoncd and stats.adrenaline.fraction >= 0.5) )
  end

  -- this pertains to soulfire, it is hilighted when it is available, the roar of awakening is equipped, the soulfire special attack is not on cooldown, and adrenaline is over ~50%
  if not abilities.spec.hilight then
  abilities.spec.hilight = equipment.roar.isequipped and not abilities.spec.isgrey and not buffs.soulfirecd.active and stats.adrenaline.fraction >= 0.5
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
  end         featuring crits
  --]]

-- ARSONIST HILIGHTS             fuck crits all my homies hate crits
  -- burn baby burn
  abilities.sunshine.highprio   = true
  print(buffs.conflagrate.active, buffs.sonic.active)
  abilities.combust.highprio    = buffs.conflagrate.active
  abilities.dbreath.highprio    = buffs.combust.active
  abilities.cblast.highprio     = buffs.sonic.active
  abilities.magma.highprio      = buffs.corruptionessence.parensnumber and buffs.corruptionessence.parensnumber > 19 and buffs.sonic.active
  abilities.spec.highprio       = true

  -- combust is hilighted whenever it's off cooldown and not already on target
  abilities.combust.hilight = not abilities.combust.isoncd and not buffs.combust.active
  -- corruption blast is hilighted whenever it's off cooldown and not already on target
  abilities.cblast.hilight  = not abilities.cblast.isgrey and not abilities.cblast.isoncd and not buffs.cblast.active

  -- runic charge hilights
  abilities.sonic.hilight   = buffs.runiccharge.active or (not abilities.sonic.isoncd and not buffs.sonic.active)
  abilities.conc.hilight    = buffs.runiccharge.active or (buffs.tsunami.active and not abilities.conc.isoncd)

  -- magma tempest is hilighted when the sonic wave buff is active
  abilities.magma.hilight = not abilities.magma.isgrey and not abilities.magma.isoncd and buffs.sonic.active
  -- dragon breath is also hilighted when your target is combusted and it isn't on cooldown
  abilities.dbreath.hilight = not abilities.dbreath.isoncd and buffs.combust.active

  -- wild magic is hilighted when it is available and not on cooldown, unless adrenaline is filling up and sunshine hasn't been used
  abilities.wildmagic.hilight = (not abilities.wildmagic.isgrey and not abilities.wildmagic.isoncd and abilities.conc.buff) and not (stats.adrenaline.fraction >= 1 and not ((((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd)) or (buffs.tsunami.active or abilities.tsunami.isoncd)))

  -- this pertains to soulfire, it is hilighted when it is available, the roar of awakening is equipped, the soulfire special attack is not on cooldown, and adrenaline is over ~50%
  if not abilities.spec.hilight then
  abilities.spec.hilight = equipment.roar.isequipped and not abilities.spec.isgrey and not buffs.soulfirecd.active and stats.adrenaline.fraction >= 0.5
  end

  -- sunshine is hilighted when it is available to be used, not currently active, and not on cooldown
  abilities.sunshine.hilight = not abilities.sunshine.isgrey and not (buffs.sunshine.active or buffs.gsunshine.active) and not abilities.sunshine.isoncd

  -- omnipower is hilighted when it is available, sunshine is active, and it is not on cooldown
  abilities.omnipower.hilight = not abilities.omnipower.isgrey and (((buffs.sunshine.active or buffs.gsunshine.active) or abilities.sunshine.isoncd)) and not abilities.omnipower.isoncd
--]]


--elseif cbstyle == "melee" then                      MELEE HILIGHTS HERE
  abilities.meteor.highprio = true
  abilities.berserk.highprio = true
  abilities.overpower.highprio = true
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


--elseif cbstyle == "ranged" then                           RANGED HILIGHTS HERE
  abilities.deathsswiftness.highprio = true
  abilities.deadshot.highprio = true
  abilities.shtendrils.highprio = true
  abilities.rapidfire.highprio = true

  -- hilight galeshot if it's ready to be used, rapid fire is not on cooldown, and death's swiftness IS on cooldown (making sure you aren't using up a galeshot when you can use death's swiftness first)
  abilities.galeshot.hilight = not abilities.galeshot.isgrey and not abilities.galeshot.isoncd and not abilities.rapidfire.isoncd and (abilities.deathsswiftness.isoncd or abilities.deathsswiftness.isoncd)

  -- hilight shadow tendrils when under the shadows buff
  abilities.shtendrils.hilight = buffs.shadows.active and not abilities.shtendrils.isoncd

  -- hilight rapid fire when the searing winds buff is active
  abilities.rapidfire.hilight = buffs.winds.active and not abilities.rapidfire.isoncd

  -- check if deathspore effect is actually active
  sporesactive = buffs.spore.number and not buffs.spore.parensnumber and buffs.sporecd.active

  -- hilight death's swiftness when it's ready to be used and the deathspore effect is active
  abilities.deathsswiftness.hilight = sporesactive and not abilities.deathsswiftness.isgrey and not (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.deathsswiftness.isoncd

  -- hilight shadows when it's ready to be used and death's swiftness is active
  abilities.shadows.hilight = not abilities.shadows.isgrey and (buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and not abilities.shadows.isoncd

  -- hilight deadshot when it's ready to be used, when death's swiftness and searing winds are active or their abilities are on cooldown
  abilities.deadshot.hilight = not abilities.deadshot.isgrey and not abilities.deadshot.isoncd and (((buffs.deathsswiftness.active or buffs.gdeathsswiftness.active) and buffs.winds.active) or (abilities.deathsswiftness.isoncd and abilities.galeshot.isoncd))


--elseif cbstyle == "necromancy" then                                NECROMANCY HILIGHTS HERE
  -- generally living death, skulls, conjure, and cmd ghost are high priority
  abilities.conjarmy.highprio = true
  abilities.conjskele.highprio = true
  abilities.conjghost.highprio = true
  abilities.cmdghost.highprio = true
  abilities.livingdeath.highprio = true
  abilities.skulls.highprio = true
  -- maybe you don't want bloat flashing
  --abilities.bloat.lowprio = true

  -- finger of death becomes high priority when capped on necrosis stacks
  abilities.finger.highprio = (buffs.necrosis.number == 12)

  -- finger of death is hilighted when necrosis stacks are 6 or more
  abilities.finger.hilight = buffs.necrosis.active and (buffs.necrosis.number or 0) >= 6

  -- volley of souls is hilighted when residual soul stacks are 5 if there is a soulbound lantern found on screen, or 3 if there is none
  abilities.volley.hilight = buffs.residualsouls.active and ((equipment.sblantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 5) or (not equipment.sblantern.x and (buffs.residualsouls.parensnumber or buffs.residualsouls.number or 0) == 3))

  -- [[death guard spec if death guard is equipped]]
  if not abilities.spec.hilight then
  abilities.spec.hilight = (
    not abilities.spec.isgrey and not buffs.deathgrasp.active -- [[available for use and not on cooldown]]
    and not buffs.livingdeath.active and abilities.livingdeath.isoncd and buffs.bloat.active -- [[living death is not active, bloat is active]]
    and (
      (not abilities.skulls.isoncd and stats.adrenaline.fraction >= 0.9) -- [[adrenaline must be ~90%+ if deathskulls is not on cooldown]]
      or (stats.adrenaline.fraction >= 0.5) -- [[otherwise, adrenaline must be ~50%+]]
    )
    and not equipment.omniguard.isequipped
    and (buffs.necrosis.number or 0) <= 5 and (buffs.necrosis.number or 0) >= 1 -- [[necrosis stacks are more than 1 but less than 6]]
    )
  end

  -- death guard spec if death guard is in an eof
  if not abilities.eof.hilight then
  abilities.eof.hilight = (
    not abilities.eof.isgrey and not buffs.deathgrasp.active -- available for use and not on cooldown
    and not buffs.livingdeath.active and abilities.livingdeath.isoncd and buffs.bloat.active -- living death is not active, bloat is active
    and (
      (not abilities.skulls.isoncd and stats.adrenaline.fraction >= 0.9) -- adrenaline must be ~90%+ if deathskulls is not on cooldown
      or (stats.adrenaline.fraction >= 0.5) -- otherwise, adrenaline must be ~50%+
    )
    and equipment.omniguard.isequipped
    and (buffs.necrosis.number or 0) <= 5 and (buffs.necrosis.number or 0) >= 1 -- necrosis stacks are more than 1 but less than 6
    )
  end
  -- omniguard spec
  if not abilities.spec.hilight then
  abilities.spec.hilight = equipment.omniguard.isequipped and not abilities.spec.isgrey and not buffs.deathessencecd.active and not buffs.livingdeath.active and abilities.livingdeath.isoncd and (abilities.livingdeath.cdnumber or 0) >= 20
  end
  -- hilight conjuring when you haven't conjured...
  abilities.conjarmy.hilight = not buffs.skeletonwarrior.active or not buffs.vengefulghost.active
  abilities.conjskele.hilight = not abilities.conjarmy.x and not buffs.skeletonwarrior.active
  abilities.conjghost.hilight = not abilities.conjarmy.x and not buffs.vengefulghost.active
  abilities.conjzomb.hilight = not abilities.conjarmy.x and not buffs.putridzombie.active
  abilities.conjphant.hilight = not abilities.conjarmy.x and not buffs.phantomguardian.active

  -- hilight command ghost when you forgot to command ghost
  abilities.cmdghost.hilight = not abilities.cmdghost.isgrey

  -- hilight command skeleton when it's off cooldown
  abilities.cmdskele.hilight = not abilities.cmdskele.isgrey and not abilities.cmdskele.isoncd
  -- hilight command zombie when it's nearing the end of its timer, for some decent no-cost damage
  abilities.cmdzom.hilight = buffs.putridzombie.active and (buffs.putridzombie.number or 0) <= 5

  -- hilight command phantom when 20 or more stacks are gained
  abilities.cmdphant.hilight = buffs.phantomguardian.active and (buffs.phantomguardian.parensnumber or 0) >= 20

  -- hilight bloat when off cooldown
  abilities.bloat.hilight = not buffs.bloat.active and stats.adrenaline.fraction >= 0.5

  -- hilight split soul when
  abilities.splitsoul.hilight = buffs.vengefulghost.active and not abilities.splitsoul.isoncd

  -- death skulls is hilighted when it's available and not off cooldown, this is for death skulls when outside of living death
  -- inside of living death, death skulls is hilighted constantly, as a reminder for its increased priority
  abilities.skulls.hilight = (buffs.livingdeath.active) or (buffs.vengefulghost.active and abilities.cmdghost.isgrey and not abilities.skulls.isgrey and not abilities.skulls.isoncd)

  -- the necromancy autoattack is only hilighted when deathspark is active, the devourer's guard uses the same assets for its effect so that's covered here as well
  abilities.necroauto.hilight = buffs.deathspark.active

  -- living death is hilighted whenever it's ready and death skulls is on cooldown, to take advantage of its cooldown reset
  abilities.livingdeath.hilight = not abilities.livingdeath.isgrey and not buffs.livingdeath.active and not abilities.livingdeath.isoncd and abilities.skulls.isoncd

  
--end
  --hilightabilities()
  hilightabilities2()
end