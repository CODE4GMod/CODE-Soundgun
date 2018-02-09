if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddWorkshop("1293479212")
end -- l.1

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
end -- l.8

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
  end -- l.56
end -- l.50

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
    end -- l.93

    if !target:IsFrozen() then target:Freeze(true)
    end -- l.99

  end) -- l.90

  target:Freeze(true)
  timer.Simple( 14, function()
    if target:Alive() then
      target:GodDisable()
      target:Freeze(false)
      local totalHealth = target:Health()
      local inflictWep = target.Create('weapon_ttt_thriller')
      target:TakeDamage( totalHealth, attacker, inflictWep )
      timer.Simple( 2, function()
        if target:IsFrozen() then
          target:Freeze(false)
        end -- l.113
      end) -- l.112
    end -- l.106
  end) -- l.105
end -- l.85

function AllDance(song, originalTarget, attacker)

    for k, v in pairs(players) do
      v:EmitSound(song)
    end

  local players = player.GetAll()

  local timerName = "reDance" .. math.random(1,10000)
  timer.Create( timerName, 1, 14, function()
    for k, v in pairs(players) do

      local danceChange = math.random(1, 2)

      if danceChange == 1 then
        v:DoAnimationEvent( ACT_GMOD_GESTURE_TAUNT_ZOMBIE, 1641 )
      else
        v:DoAnimationEvent( ACT_GMOD_TAUNT_DANCE, 1642 )
      end -- l.135

      if !v:IsFrozen() then
        v:Freeze(true)
      end -- l.141
    end -- l.131
  end) -- l.130

  for k, v in pairs(players) do
    v:Freeze(true)
  end -- l.147

  timer.Simple( 14, function()
    for k, v in pairs(players) do
      if v:Alive() then
        v:GodDisable()
        v:Freeze(false)
      end -- l.153
    end -- l.152

    if originalTarget:Alive() then

      local totalHealth = originalTarget:Health()
      local inflictWep = originalTarget.Create('weapon_ttt_thriller')
      originalTarget:TakeDamage( totalHealth, attacker, inflictWep )
      timer.Simple( 2, function()
        if originalTarget:IsFrozen() then
          originalTarget:Freeze(false)
        end -- l.165
      end) -- l.164
    end -- l.159
  end) -- l.151

end -- l.121

function SWEP:PrimaryAttack()

   if not self:CanPrimaryAttack() then
     return
   end -- l.176

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
                             end -- l.201

                          end -- l.197
                        end -- l.195
                      end -- l.194

   self.Owner:FireBullets( bullet )
   if SERVER then
     self:TakePrimaryAmmo( 1 )
   end -- l. 212
end -- l. 174

function SWEP:OnDrop()
	self:Remove()
end -- l.217
