function gadget:GetInfo()
  return {
    name      = "No Self-Damage",
    desc      = "Prevents units from dealing damage to themselves.",
    author    = "Evil4Zerggin",
    date      = "8 July 2008",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 100,
    enabled   = true  --  loaded by default?
  }
end

if (not gadgetHandler:IsSyncedCode()) then
  return false
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, attackerID, attackerDefID, attackerTeam)
  if unitID == attackerID then return 0 else return damage end
end
