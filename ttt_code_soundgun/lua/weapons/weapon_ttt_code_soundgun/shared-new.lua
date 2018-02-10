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
-- End of SWEP Config

songList = {
--{SONGNAME(string), LENGTH(int), SPECIAL_FLAG(bool)}
  {"every",     14,     true  }, -- Make You Sweat,             C+C
  {"blue",      14,     false }, -- Blue,                       Eiffel 65
  {"high",      14,     false }, -- Highway to Hell,            AC/DC
  {"star",      14,     false }, -- Shooting Star,              Bag Raiders
  {"dust",      14,     false }, -- Another One Bites the Dust, Queen
  {"lazy",      14,     false }, -- Number One,                 Lazy Town
  {"smash",     14,     false }, -- All Star,                   Smash Mouth
  {"fox",       14,     false }, -- The Fox,                    Ylvis
  {"stop",      14,     false }, -- Don't Stop Me Now,          Queen
  {"dank",      14,     false }, -- PPAP,                       Pikotaro
  {"sponge",    14,     false }, -- Spongebob Theme
  {"thril",     14,     false }, -- Thriller,                   Michael Jackson
  {"end",       14,     false }, -- In The End,                 Linkin Park
  {"nein",      14,     false }, -- Nein Mann,                  Laserkraft 3D
  {"country",   14,     false }, -- Country Roads,              John Denver
  {"fuck",      14,     false }  -- Fuck This Shit I'm out
}

GetSongName(songSeed)
  return songSeed .. "cut.wav"
end

GetRandomSongArray()
  local random = math.random(1, table.getn(songList))
  return songList[random]
end
