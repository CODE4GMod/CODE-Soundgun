if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddWorkshop("794651430")
end

SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "CODE Soundgun"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "2 Shots.\n\nCauses victim to dance uncontrollably, and sing a song, \nthen die 14 seconds later."
   };

   SWEP.Icon = "vgui/ttt/icon_thrillerblue.png"
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL

SWEP.Primary.Recoil        = 3
SWEP.Primary.Damage        = 1
SWEP.Primary.Delay         = 1
SWEP.Primary.Cone          = 0.01
SWEP.Primary.ClipSize      = 2
SWEP.Primary.Automatic     = false
SWEP.Primary.DefaultClip   = 2
SWEP.Primary.ClipMax       = 2
SWEP.Primary.Ammo          = "none"
SWEP.AmmoEnt               = "none"

SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_fiveseven.mdl"

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.IronSightsPos         = Vector(-5.95, -1, 4.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function PickSong() -- This function is in charge of picking songs,
                    -- if you add one, add it here!
  --local musicChance = math.random(1, 12)
  local musicChance = 1

  -- The following returns the songname, and a bool for special conditions
  if musicChance == 1 then
    return "everycut.wav", true -- Thriller, Michael Jackson
  elseif musicChance == 2 then
    return "bluecut.wav", false -- Blue, Eiffel 65
  elseif musicChance == 3 then
    return "highcut.wav", false -- Highway to Hell, AC/DC
  elseif musicChance == 4 then
    return "starcut.wav", false -- Shooting Star, Bag Raiders
  elseif musicChance == 5 then
    return "dustcut.wav", false -- Another Bites the Dust, Queen
  elseif musicChance == 6 then
    return "lazycut.wav", false -- Number One, Lazy Town
  elseif musicChance == 7 then
    return "smashcut.wav", false -- All Star, Smash Mouth
  elseif musicChance == 8 then
    return "foxcut.wav", false -- The Fox, Ylvis
  elseif musicChance == 9 then
    return "stopcut.wav", false -- Don't Stop Me Now, Queen
  elseif musicChange == 10 then
    return "dankcut.wav", false -- PPAP, PIKOTARO
  elseif musicChance == 11 then
    return "spongecut.wav", false -- Spongebob Theme
  elseif musicChance == 12 then
    return "thrilcut.wav", false
  else
    return "fuckcut.wav", false -- Fuck This Shit I'm out, ???
  end
end

function VictimDance(song, target, attacker)
  target:EmitSound(song)
  target:GodEnable()
  local timerName = "reDance" .. math.random(1,10000)
  timer.Create( timerName, 1, 14, function()
    local danceChange = math.random(1, 2)

    if danceChange == 1 then
      target:DoAnimationEvent( ACT_GMOD_GESTURE_TAUNT_ZOMBIE, 1641 )
    else
      target:DoAnimationEvent( ACT_GMOD_TAUNT_DANCE, 1642 )
    end
    if !target:IsFrozen() then target:Freeze(true) end
  end)

  target:Freeze(true)
  timer.Simple( 14, function()
    if target:Alive() then
    target:GodDisable()
    target:Freeze(false)
    local totalHealth = target:Health()
    local inflictWep = target.Create('weapon_ttt_thriller')
    target:TakeDamage( totalHealth, attacker, inflictWep )
    timer.Simple( 2, function() if target:IsFrozen() then target:Freeze(false) end end)
    end
  end)

end

function AllDance(song, originalTarget, attacker)
  surface.PlaySound(song)
  local players = player.GetAll()

  local timerName = "reDance" .. math.random(1,10000)
  timer.Create( timerName, 1, 14, function()
    for playerEnt in players do

      local danceChange = math.random(1, 2)

      if danceChange == 1 then
        playerEnt:DoAnimationEvent( ACT_GMOD_GESTURE_TAUNT_ZOMBIE, 1641 )
      else
        playerEnt:DoAnimationEvent( ACT_GMOD_TAUNT_DANCE, 1642 )
      end
      if !playerEnt:IsFrozen() then playerEnt:Freeze(true) end
    end
  end)

  for playerEnt in players do
    playerEnt:Freeze(true)
  end
    timer.Simple( 14, function()
      for playerEnt in players do
        if playerEnt:Alive() then
          playerEnt:GodDisable()
          playerEnt:Freeze(false)
      end
    end
    if originalTarget:Alive() then

      local totalHealth = originalTarget:Health()
      local inflictWep = originalTarget.Create('weapon_ttt_thriller')
      originalTarget:TakeDamage( totalHealth, attacker, inflictWep )
      timer.Simple( 2, function() if originalTarget:IsFrozen() then originalTarget:Freeze(false) end end)
      end
    end)


end

function SWEP:PrimaryAttack()
   if not self:CanPrimaryAttack() then return end
   self.Owner:EmitSound("scratch.wav")
   local cone = self.Primary.Cone
   local num = 1

   local bullet = {}
   bullet.Num    = num
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( cone, cone, 0 )
   bullet.Tracer = 1
   bullet.Force	= 10
   bullet.Damage = 1
   bullet.TracerName = "PhyscannonImpact"

   bullet.Callback = function(att, tr)
                        if SERVER or (CLIENT and IsFirstTimePredicted()) then
                           local ent = tr.Entity
                              if SERVER and ent:IsPlayer() then

                local songName, special = PickSong()

                if !special then
                  VictimDance(songName, ent, att)
                else
                  AllDance(songName, ent, att)
                end

                              end
                           end
                        end
   self.Owner:FireBullets( bullet )
   if SERVER then
     self:TakePrimaryAmmo( 1 )
   end
end

function SWEP:OnDrop()
	self:Remove()
end

function
