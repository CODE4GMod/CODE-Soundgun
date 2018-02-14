if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddWorkshop("1293479212")
end


-- SWEP Config
SWEP.HoldType              = "pistol"

if CLIENT then
   SWEP.PrintName          = "CODE Soundgun"
   SWEP.Slot               = 6

   SWEP.ViewModelFlip      = false
   SWEP.ViewModelFOV       = 54

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "2 Shots.\n\nCauses victim to dance uncontrollably, and sing a song,\nthen die 14 seconds later."
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
-- End of SWEP Config

soundEffect = "scratch.wav"

songList = {
--{SONGNAME(string), LENGTH(int), SPECIAL_FLAG(bool)}
  {"every",     14,     true  }, -- Make You Sweat,             C+C
  {"blue",      14,     false }, -- Blue,                       Eiffel 65
  {"high",      14,     false }, -- Highway to Hell,            AC/DC
  {"star",      14,     false }, -- Shooting Star,              Bag Raiders
  {"dust",      16,     false }, -- Another One Bites the Dust, Queen
  {"lazy",      12,     false }, -- Number One,                 Lazy Town
  {"smash",     18,     false }, -- All Star,                   Smash Mouth
  {"fox",       15,     false }, -- The Fox,                    Ylvis
  {"stop",      16,     false }, -- Don't Stop Me Now,          Queen
  {"dank",      14,     false }, -- PPAP,                       Pikotaro
  {"thril",     14,     false }, -- Thriller,                   Michael Jackson
  {"end",       14,     false }, -- In The End,                 Linkin Park
  {"nein",      14,     false }, -- Nein Mann,                  Laserkraft 3D
  {"fuck",      14,     false }, -- Fuck This Shit I'm out
  {"tnt",       19,     false }, -- TNT                         AC/DC
}

function PlaySound(entity, song)
  entity:EmitSound(song)
end

function GetSongName(songSeed)
  return songSeed .. "cut.wav"
end

function GetRandomSongArray()
--  local random = 16
  local random = math.random(1, table.getn(songList))
  return songList[random]
end

function GetSong()
  local songSeed, length, special = unpack(GetRandomSongArray())
  return GetSongName(songSeed), length, special
end

function Freeze(target)
  target:GodEnable()
  target:Freeze(true)
end

function Unfreeze(target)
  target:GodDisable()
  target:Freeze(false)
end

function ForceDance(target)
  if math.random(1, 2) == 1 then
    target:DoAnimationEvent( ACT_GMOD_GESTURE_TAUNT_ZOMBIE, 1641 )
  else
    target:DoAnimationEvent( ACT_GMOD_TAUNT_DANCE, 1642 )
  end
end

function StopDance(target)
  target:DoAnimationEvent ( ACT_RESET, 0 )
end

function DealDamage(target, attacker)
  local weapon = ents.Create('weapon_ttt_code_soundgun')
  target:TakeDamage( target:Health(), attacker, weapon)
end

function GlobalPlay(song)
  for key, target in pairs(player.GetAll()) do
    PlaySound(target, song)
  end
end

function FreezeAllPlayers()
  for key, target in pairs(player.GetAll()) do
    if target:Alive() then
      Freeze(target)
    end
  end
end

function UnfreezeAllPlayers()
  for key, target in pairs(player.GetAll()) do
    if target:Alive() then
      Unfreeze(target)
    end
  end
end

function ForceEveryPlayerToDance()
  for key, target in pairs(player.GetAll()) do
    if target:Alive() then
      ForceDance(target)
    end
  end
end

function StopEveryPlayerDancing()
  for key, target in pairs(player.GetAll()) do
    if target:Alive() then
      StopDance(target)
    end
  end
end

function NormalSong(song, length, attacker, target)

  PlaySound(target, song)
  Freeze(target)

  local timerName = "reDance" .. math.random(1,10000)

  timer.Create( timerName, 1, length-1, function()
    ForceDance(target)
  end)


  timer.Simple( length, function()
    if target:Alive() then
      Unfreeze(target)

      DealDamage(target, attacker)
    end
  end)

end

function SpecialSong(song, length, attacker, target)

  GlobalPlay(song)

  FreezeAllPlayers()

  local timerName = "reDance" .. math.random(1, 10000)
  timer.Create( timerName, 1, length-1, function()
    ForceEveryPlayerToDance()
  end)

  timer.Simple( length, function()
    UnfreezeAllPlayers()

    if target:Alive() then
      DealDamage(target, attacker)
    end

    StopEveryPlayerDancing()
  end)

end

function SWEP:PrimaryAttack()

  if not self:CanPrimaryAttack() then
    return
  end

  PlaySound(self.Owner, soundEffect)
  local cone = self.Primary.Cone

  local bullet = {}
  bullet.Num        = 1
  bullet.Src        = self.Owner:GetShootPos()
  bullet.Dir        = self.Owner:GetAimVector()
  bullet.Spread     = Vector( cone, cone, 0)
  bullet.Tracer     = 1
  bullet.Force      = 10
  bullet.Damage     = 1
  bullet.TracerName = "PhyscannonImpact"

  bullet.Callback = function(attacker, target)
    if SERVER then

      local ent = target.Entity
      if ent:IsPlayer() then

        local song, length, special = GetSong()

        if !special then
          NormalSong(song, length, attacker, ent)
        else
          SpecialSong(song, length, attacker, ent)
        end
      end
    end
  end

  self.Owner:FireBullets( bullet )
  if SERVER then
    self:TakePrimaryAmmo( bullet.Num )
  end

end


function SWEP:OnDrop()
  self:Remove()
end
