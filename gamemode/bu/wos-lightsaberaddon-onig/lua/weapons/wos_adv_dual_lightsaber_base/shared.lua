
--[[-------------------------------------------------------------------
	Advanced Lightsaber Combat Base:
		An intuitively designed lightsaber combat base.
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2017, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
-- Copyright 2017, David "King David" Wiltos ]]--

AddCSLuaFile()

if ( SERVER ) then
	util.AddNetworkString( "rb655_holdtype" )
	resource.AddWorkshop( "111412589" )
	CreateConVar( "rb655_lightsaber_infinite", "0" )
end

SWEP.PrintName = "Dual Lightsaber Base"
SWEP.Author = "Robotboy655"
SWEP.Category = "Robotboy655's Weapons"
SWEP.Contact = "robotboy655@gmail.com"
SWEP.Purpose = "To slice off each others limbs and heads."
SWEP.Instructions = "Use the force, Luke."
SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.LoadDelay = 0
SWEP.RegendSpeed = 1
SWEP.MaxForce = 100
SWEP.ForcePowerList = {}
SWEP.DevestatorList = {}

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
SWEP.ViewModelFOV = 55

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.AlwaysRaised = true

SWEP.BlockInvincibility = false
SWEP.Stance = 1
SWEP.CombatTypeModel = false
SWEP.Enabled = false
SWEP.StanceCycle = {}
SWEP.StanceCycle[ "Arrogant" ] = "ryoku_"
SWEP.IsLightsaber = true
SWEP.IsDualLightsaber = true
SWEP.CurStance = 1
SWEP.CurForm = "judge_"
SWEP.FPCamTime = 0
SWEP.BlockDrainRate = 0.1
SWEP.StaminaRegenSpeed = 1
SWEP.DevestatorTime = 0
SWEP.UltimateCooldown = 0
SWEP.Cooldowns = {}

-- We have NPC support, but it SUCKS
list.Add( "NPCUsableWeapons", { class = "wos_adv_single_lightsaber_base", title = SWEP.PrintName } )

-- --------------------------------------------------------- Helper functions --------------------------------------------------------- --

function SWEP:PlayWeaponSound( snd )
	if ( CLIENT ) then return end
	if ( IsValid( self:GetOwner() ) && IsValid( self:GetOwner():GetActiveWeapon() ) && self:GetOwner():GetActiveWeapon() != self ) then return end
	if ( !IsValid( self.Owner ) ) then return self:EmitSound( snd ) end
	self.Owner:EmitSound( snd )
end

function SWEP:SelectTargets( num, dist )
	local t = {}
	
	if not dist then
		dist = 512
	end
	
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if not selectedForcePower then return t end
	if selectedForcePower.manualaim then
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
			filter = self.Owner
		})
		
		local ent = tr.Entity
		if not IsValid( ent ) then return t end
		if !ent:GetModel() or ent:GetModel() == "" or ent == self.Owner or ent:Health() < 1 then return t end
		if ent:GetNW2Float( "CloakTime", 0 ) >= CurTime() then return t end
		return { ent }
	end
	
	local p = {}
	for id, ply in pairs( ents.GetAll() ) do
		if ( !ply:GetModel() or ply:GetModel() == "" or ply == self.Owner or ply:Health() < 1 ) then continue end
		if ( string.StartWith( ply:GetModel() or "", "models/gibs/" ) ) then continue end
		if ( string.find( ply:GetModel() or "", "chunk" ) ) then continue end
		if ( string.find( ply:GetModel() or "", "_shard" ) ) then continue end
		if ( string.find( ply:GetModel() or "", "_splinters" ) ) then continue end
		if ply:GetNW2Float( "CloakTime", 0 ) >= CurTime() then continue end
		
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = (ply.GetShootPos && ply:GetShootPos() or ply:GetPos()),
			filter = self.Owner,
		} )

		if ( tr.Entity != ply && IsValid( tr.Entity ) or tr.Entity == game.GetWorld() ) then continue end

		local pos1 = self.Owner:GetPos() + self.Owner:GetAimVector() * dist
		local pos2 = ply:GetPos()
		local dot = self.Owner:GetAimVector():Dot( ( self.Owner:GetPos() - pos2 ):GetNormalized() )

		if ( pos1:Distance( pos2 ) <= dist && ply:EntIndex() > 0 && ply:GetModel() && ply:GetModel() != "" ) then
			table.insert( p, { ply = ply, dist = tr.HitPos:Distance( pos2 ), dot = dot, score = -dot + ( ( dist - pos1:Distance( pos2 ) ) / dist ) * 50 } )
		end
	end

	for id, ply in SortedPairsByMemberValue( p, "dist" ) do
		table.insert( t, ply.ply )
		if ( #t >= num ) then return t end
	end

	return t
end

-- --------------------------------------------------------- Force Powers --------------------------------------------------------- --

function SWEP:GetActiveForcePowers()
	local ForcePowers = {}
	for id, t in pairs( self.ForcePowers ) do
		local ret = hook.Run( "CanUseLightsaberForcePower", self:GetOwner(), t.name )
		if ( ret == false ) then continue end

		table.insert( ForcePowers, t )
	end
	return ForcePowers
end

function SWEP:GetActiveForcePowerType( id )
	local ForcePowers = self:GetActiveForcePowers()
	return ForcePowers[ id ]
end

function SWEP:GetActiveDevestators()
	local Devestators = {}
	for id, t in pairs( self.Devestators ) do
		table.insert( Devestators, t )
	end
	return Devestators
end

function SWEP:GetActiveDevestatorType( id )
	local Devestators = self:GetActiveDevestators()
	return Devestators[ id ]
end

function SWEP:OnRestore()
	self.Owner:SetNW2Float( "wOS.SaberAttackDelay", 0 )
end

function SWEP:SetNextAttack( delay )
	self:SetNextPrimaryFire( CurTime() + delay )
	self:SetNextSecondaryFire( CurTime() + delay )
end

function SWEP:ForceJumpAnim()
	self.Owner.m_bJumping = true

	self.Owner.m_bFirstJumpFrame = true
	self.Owner.m_flJumpStartTime = CurTime()

	self.Owner:AnimRestartMainSequence()
end

SWEP.ForcePowers = {}

-- --------------------------------------------------------- Initialize --------------------------------------------------------- --

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "BladeLength" )
	self:NetworkVar( "Float", 1, "MaxLength" )
	self:NetworkVar( "Float", 2, "BladeWidth" )
	self:NetworkVar( "Float", 3, "Force" )
	self:NetworkVar( "Float", 4, "SecBladeLength" )
	self:NetworkVar( "Float", 5, "SecMaxLength" )
	self:NetworkVar( "Float", 6, "SecBladeWidth" )
	self:NetworkVar( "Float", 7, "DevEnergy" )
	self:NetworkVar( "Float", 8, "FPCamTime" )
	self:NetworkVar( "Float", 9, "Delay" )	
	self:NetworkVar( "Float", 10, "BlockDrain" ) 
	self:NetworkVar( "Float", 11, "ForceCooldown" )
	
	self:NetworkVar( "Bool", 0, "DarkInner" )
	self:NetworkVar( "Bool", 1, "SecDarkInner" )
	self:NetworkVar( "Bool", 2, "Enabled" )
	self:NetworkVar( "Bool", 3, "WorksUnderwater" )
	self:NetworkVar( "Int", 0, "ForceType" )
	self:NetworkVar( "Int", 1, "DevestatorType" )
	self:NetworkVar( "Int", 2, "IncorrectPlayerModel" )
	self:NetworkVar( "Int", 3, "Stance" )
	self:NetworkVar( "Int", 4, "Form" )
	self:NetworkVar( "Int", 5, "MaxForce" )
	self:NetworkVar( "Int", 6, "MaxStamina" )
	self:NetworkVar( "Int", 7, "Stamina" )	
	
	self:NetworkVar( "Vector", 0, "CrystalColor" )
	self:NetworkVar( "Vector", 1, "SecCrystalColor" )
	self:NetworkVar( "String", 0, "WorldModel" )
	self:NetworkVar( "String", 1, "SecWorldModel" )
	self:NetworkVar( "String", 2, "OnSound" )
	self:NetworkVar( "String", 3, "OffSound" )

	if ( SERVER ) then
		self:DataTableInit()
	end
	
end

function SWEP:AddStamina( num )
	self:SetStamina( math.Clamp( self:GetStamina() + num, 0, self:GetMaxStamina() ) )
end

function SWEP:Initialize()
	self.LoopSound = self.LoopSound or "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
	self.SwingSound = self.SwingSound or "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"

	self:SetWeaponHoldType( self:GetTargetHoldType() )
	
	if ( self.Owner && self.Owner:IsNPC() && SERVER ) then -- NPC Weapons
		--self.Owner:Fire( "GagEnable" )

		if ( self.Owner:GetClass() == "npc_citizen" ) then
			self.Owner:Fire( "DisableWeaponPickup" )
		end

		self.Owner:SetKeyValue( "spawnflags", "256" )

		hook.Add( "Think", self, self.NPCThink )

		timer.Simple( 0.5, function()
			if ( !IsValid( self ) or !IsValid( self.Owner ) ) then return end
			self.Owner:SetCurrentWeaponProficiency( 4 )
			self.Owner:CapabilitiesAdd( CAP_FRIENDLY_DMG_IMMUNE )
			self.Owner:CapabilitiesRemove( CAP_WEAPON_MELEE_ATTACK1 )
			self.Owner:CapabilitiesRemove( CAP_INNATE_MELEE_ATTACK1 )
		end )
	end
	
	self.ForcePowers = {}
	self.AvailablePowers = table.Copy( wOS.AvailablePowers )
	for _, force in pairs( self.ForcePowerList ) do
		if not self.AvailablePowers[ force ] then continue end
		self.ForcePowers[ #self.ForcePowers + 1 ] = self.AvailablePowers[ force ]
	end
	
	self.Devestators = {}
	self.AvailableDevestators = table.Copy( wOS.AvailableDevestators )
	for _, dev in pairs( self.DevestatorList ) do
		if not self.AvailableDevestators[ dev ] then continue end
		self.Devestators[ #self.Devestators + 1 ] = self.AvailableDevestators[ dev ]
	end
	
	if SERVER then
		if self.Class then
			wOS:RegisterLightsaber( self.Class, true )
		end
	end
		
end

-- --------------------------------------------------------- NPC Weapons --------------------------------------------------------- --

function SWEP:SetupWeaponHoldTypeForAI( t )
	if ( !self.Owner:IsNPC() ) then return end

	self.ActivityTranslateAI = {}

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK2 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW

	self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_RELAXED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_AGITATED ]			= ACT_WALK

	self.ActivityTranslateAI[ ACT_RUN_CROUCH ]				= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_CROUCH_AIM ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN
	self.ActivityTranslateAI[ ACT_SMALL_FLINCH ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_BIG_FLINCH ]				= ACT_RANGE_ATTACK_PISTOL

	if ( self.Owner:GetClass() == "npc_metropolice" ) then

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_MP_RUN ]					= ACT_HL2MP_RUN_SUITCASE
	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK_SUITCASE
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW
	self.ActivityTranslateAI[ ACT_SMALL_FLINCH ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_BIG_FLINCH ]				= ACT_RANGE_ATTACK_PISTOL

	return end

	if ( self.Owner:GetClass() == "npc_combine_s2" ) then

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK2 ]			= ACT_MELEE_ATTACK_SWING
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_RANGE_ATTACK_THROW


	self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			 = ACT_IDLE_ANGRY_MELEE
	self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_IDLE_ANGRY_MELEE

	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_RELAXED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]			= ACT_WALK
	self.ActivityTranslateAI[ ACT_WALK_AGITATED ]			= ACT_WALK

	self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN
	self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN
	self.ActivityTranslateAI[ ACT_SMALL_FLINCH ]			= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI[ ACT_BIG_FLINCH ]				= ACT_RANGE_ATTACK_PISTOL

	return end

	if ( self.Owner:GetClass() == "npc_combine_s" ) then

	self.ActivityTranslateAI[ ACT_IDLE ]					= ACT_IDLE_UNARMED
	self.ActivityTranslateAI[ ACT_IDLE_ANGRY ]				= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_RELAXED ]			= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_STIMULATED ]			= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_AGITATED ]			= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_AIM_RELAXED ]		= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_AIM_STIMULATED ]		= ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_IDLE_AIM_AGITATED ]		= ACT_IDLE_SHOTGUN

	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1 ]			= ACT_MELEE_ATTACK1
	self.ActivityTranslateAI[ ACT_RANGE_ATTACK1_LOW ]		= ACT_MELEE_ATTACK1
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK1 ]			= ACT_MELEE_ATTACK1
	self.ActivityTranslateAI[ ACT_MELEE_ATTACK2 ]			= ACT_MELEE_ATTACK1
	self.ActivityTranslateAI[ ACT_SPECIAL_ATTACK1 ]			= ACT_MELEE_ATTACK1

	self.ActivityTranslateAI[ ACT_RANGE_AIM_LOW ]			 = ACT_IDLE_SHOTGUN
	self.ActivityTranslateAI[ ACT_COVER_LOW ]				= ACT_IDLE_SHOTGUN

	self.ActivityTranslateAI[ ACT_WALK ]					= ACT_WALK_UNARMED
	self.ActivityTranslateAI[ ACT_WALK_RELAXED ]			= ACT_WALK_UNARMED
	self.ActivityTranslateAI[ ACT_WALK_STIMULATED ]			= ACT_WALK_UNARMED
	self.ActivityTranslateAI[ ACT_WALK_AGITATED ]			= ACT_WALK_UNARMED

	self.ActivityTranslateAI[ ACT_RUN ]						= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_RELAXED ]			= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_STIMULATED ]		= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI[ ACT_RUN_AIM_AGITATED ]		= ACT_RUN_AIM_SHOTGUN
	self.ActivityTranslateAI[ ACT_RUN_AIM ]					= ACT_RUN_AIM_SHOTGUN

	return end
end

function SWEP:GetCapabilities()
	return bit.bor( CAP_WEAPON_MELEE_ATTACK1 )
end

function SWEP:NPC_NextLogic()
	if ( !IsValid( self ) or !IsValid( self.Owner ) ) then return end
	if ( self.Owner:IsCurrentSchedule( SCHED_CHASE_ENEMY ) ) then return end
	self.NPC_NextLogicTimer = true
	self:NPC_ChaseEnemy()

	timer.Simple( math.Rand( 0.7, 1 ), function()
		self.NPC_NextLogicTimer = false
	end )
end

function SWEP:NPC_ChaseEnemy()
	if ( !IsValid( self ) or !IsValid( self.Owner ) ) then return end
	if ( self.Owner:GetEnemy():GetPos():Distance( self:GetPos() ) > 70 ) then
		self.Owner:SetSchedule( SCHED_CHASE_ENEMY )
	end

	if ( self.Owner:GetEnemy() == self.Owner ) then self.Owner:SetEnemy( NULL ) return end
	if ( !self.CooldownTimer && self.Owner:GetEnemy():GetPos():Distance( self:GetPos() ) <= 70 ) then
		self.Owner:SetSchedule( SCHED_MELEE_ATTACK1 )
		self:NPCShoot_Primary( ShootPos, ShootDir )
	end
end

function SWEP:NPCThink()
	if ( !IsValid( self.Owner ) or !IsValid( self ) or !self.Owner:IsNPC() ) then return end

	if ( self:GetEnabled() != IsValid( self.Owner:GetEnemy() ) ) then self:SetEnabled( IsValid( self.Owner:GetEnemy() ) ) end

	--self.Owner:RemoveAllDecals()
	self.Owner:ClearCondition( 13 )
	self.Owner:ClearCondition( 17 )
	self.Owner:ClearCondition( 18 )
	self.Owner:ClearCondition( 20 )
	self.Owner:ClearCondition( 48 )
	self.Owner:ClearCondition( 42 )
	self.Owner:ClearCondition( 45 )

	if ( !self.NPC_NextLogicTimer && IsValid( self.Owner:GetEnemy() ) ) then
		self:NPC_NextLogic()
	end

	self:Think()
end

function SWEP:NPCShoot_Primary( ShootPos, ShootDir )
	if ( !IsValid( self ) or !IsValid( self.Owner ) ) then return end
	if ( !self.Owner:GetEnemy() ) then return end

	self.CooldownTimer = true
	local seqtimer = 0.4
	if self.Owner:GetClass() == "npc_alyx" then
		seqtimer = 0.8
	end

	timer.Simple( seqtimer, function()
		if ( !IsValid( self ) or !IsValid( self.Owner ) ) then return end
		--[[if ( self.Owner:IsCurrentSchedule( SCHED_MELEE_ATTACK1 ) ) then
			self:PrimaryAttack()
		end]]
		self.CooldownTimer = false
	end )
end

-- --------------------------------------------------------- Attacks --------------------------------------------------------- --

function SWEP:PrimaryAttack()
	if ( !IsValid( self.Owner ) ) then return end
	if self.Owner.IsBlocking then return end
	if self.HeavyCharge then 
		if self.HeavyCharge >= CurTime() then return end
	end
	if ( prone and self.Owner:IsProne() ) then self.Owner:SetAnimation( PLAYER_ATTACK1 ); self:SetNextAttack( 1.0 ); return end
	if not self:GetNW2Bool( "SWL_CustomAnimCheck", false ) then self.Owner:SetAnimation( PLAYER_ATTACK1 ); self:SetNextAttack( 1.0 ); return end
	
	if self.Owner:KeyDown(IN_USE) and self:GetEnabled() then
		if SERVER then
			self:StanceUpdate()
		end
		self.CurStance = self:SetNW2Int("Stance", self.CurStance )
		self:SetNextAttack( 0.1 )
		return
	end
	self.CurStance = self:GetNW2Int("Stance", 1 )	
	self.CurForm = self:GetNW2String("CombatTypeModel", "judge_" )	
	if self:GetEnabled() then
		if wOS.EnableStamina then
			if not self.Owner:CanUseStamina( false ) then return end
			self:AddStamina( -1*wOS.AttackCost )
		end
		local time
		if !self.Owner:OnGround() then	
			if SERVER then 
				self:DoAerial() 
			end
			self.AerialLand = true
		else
			if SERVER then 
				self:DoLight() 
			end
		end
		self:SetNextAttack( self:GetDelay() )
		self:SetFPCamTime( CurTime() + self:GetDelay() + 0.1 )
	end
	
end


function SWEP:SecondaryAttack()

	if self.Owner.IsBlocking then 
		if SERVER then
			wOS.LightsaberHook.Devestator( self )
		end
		return 
	end
	
	if self.HeavyCharge then return end
	
	if self.Owner:KeyDown(IN_USE) and self:GetEnabled() and self:GetNW2Bool( "SWL_CustomAnimCheck", false ) and !( prone and self.Owner:IsProne() ) then return end
	
	if SERVER then
		self:HandleForcePower()
	end

end

function SWEP:Reload()

	if ( !self.Owner:KeyPressed( IN_RELOAD ) ) then return end
	if ( self.Owner:WaterLevel() > 2 && !self:GetWorksUnderwater() ) then return end
	--[[
	if not self:GetEnabled() then 
		if self.Owner:KeyDown(IN_USE) then
			if SERVER then
				self.FormPos = self.FormPos + 1
				if self.FormPos > #self.Forms then
					self.FormPos = 1
				end
				self:SetNW2String( "CombatTypeModel", self.Forms[ self.FormPos ] )
				self.StancePos = 1
				self:SetNW2Int( "Stance", self.Stances[ self:GetNW2String( "CombatTypeModel", "judge_" ) ][self.StancePos] )
			end
		end
	end
	]]--
	
	if self.Owner:KeyDown( IN_WALK ) then
		if CLIENT then
			wOS:OpenDevestatorMenu()
		end
		return	
	end
	
	if self.Owner:KeyDown( IN_USE ) then
		if CLIENT then
			wOS:OpenFormMenu( true )
		end
		return
	end

	self:SetEnabled( !self:GetEnabled() )
end

-- --------------------------------------------------------- Hold Types --------------------------------------------------------- --

function SWEP:GetTargetHoldType()
	--if ( !self:GetEnabled() ) then return "normal" end
	if ( self:GetWorldModel() == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" ) then return "knife" end
	if ( self:LookupAttachment( "blade2" ) && self:LookupAttachment( "blade2" ) > 0 ) then return "knife" end

	return "knife"
end

-- --------------------------------------------------------- Drop / Deploy / Holster / Enable / Disable --------------------------------------------------------- --

function SWEP:OnEnabled( bDeploy )
	if ( !self:GetEnabled() or bDeploy ) then self:PlayWeaponSound( self:GetOnSound() ) end

	if ( CLIENT or ( self:GetEnabled() and !bDeploy ) ) then return end

	self:SetHoldType( self:GetTargetHoldType() )
	timer.Remove( "rb655_ls_ht" )

	self.SoundLoop = CreateSound( self.Owner, Sound( self.LoopSound ) )
	if ( self.SoundLoop ) then self.SoundLoop:Play() end

	self.SoundSwing = CreateSound( self.Owner, Sound( self.SwingSound ) )
	if ( self.SoundSwing ) then self.SoundSwing:Play() self.SoundSwing:ChangeVolume( 0, 0 ) end

	self.SoundHit = CreateSound( self.Owner, Sound( "lightsaber/saber_hit.wav" ) )
	if ( self.SoundHit ) then self.SoundHit:Play() self.SoundHit:ChangeVolume( 0, 0 ) end
end

function SWEP:OnDisabled( bRemoved )
	if ( CLIENT ) then
		rb655_SaberClean_wos( self:EntIndex() )
		return true
	end

	if ( self.SoundLoop ) then self.SoundLoop:Stop() self.SoundLoop = nil end
	if ( self.SoundSwing ) then self.SoundSwing:Stop() self.SoundSwing = nil end
	if ( self.SoundHit ) then self.SoundHit:Stop() self.SoundHit = nil end

	return true
end

function SWEP:OnEnabledOrDisabled( name, old, new )

	if ( CLIENT ) then
		rb655_SaberClean_wos( self:EntIndex() )
	end


	if ( old == new ) then return end

	if ( new ) then
		self:OnEnabled()
	else
		self:PlayWeaponSound( self:GetOffSound() )

		-- Fancy extinguish animations?
		timer.Create( "rb655_ls_ht", 0.4, 1, function() if ( IsValid( self ) ) then self:SetHoldType( "normal" ) end end )

		self:OnDisabled()
	end
end

function SWEP:OnDrop()
	if ( self:GetEnabled() ) then self:PlayWeaponSound( self:GetOffSound() ) end
	self:OnDisabled( true )
end
function SWEP:OnRemove()
	if ( self:GetEnabled() && IsValid( self.Owner ) ) then self:PlayWeaponSound( self:GetOffSound() ) end
	self:OnDisabled( true )
end

function SWEP:Deploy()

	local ply = self.Owner
	
	if SERVER and IsValid(ply) then
		self:SetStandard()
	end
	self.CurStance = self:GetNW2Int("Stance", 1 )
	self.CurForm = self:GetNW2String( "CombatTypeModel", "judge_" )

	if ( self:GetEnabled() ) then 
		self:OnEnabled( true ) 
	else 
		self:SetHoldType( "normal" ) 
	end

	if ( CLIENT ) then return end

	if ( ply:IsPlayer() && ply:FlashlightIsOn() ) then ply:Flashlight( false ) end

	self:SetBladeLength( 0 ) -- Reinitialize the effect.

	return true
end

function SWEP:Holster()
	if ( self:GetEnabled() ) then self:PlayWeaponSound( self:GetOffSound() ) end
	self.Owner.IsBlocking = false
	self.Owner:SetNW2Bool( "IsMeditating", false )
	return self:OnDisabled( true )
end

-- --------------------------------------------------------- Think --------------------------------------------------------- --

function SWEP:GetSaberPosAng( num, side )
	num = num or 1

	if ( SERVER ) then self:SetIncorrectPlayerModel( 0 ) end

	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		local attachment = self:LookupAttachment( "blade" .. num )
		if ( side ) then
			attachment = self:LookupAttachment( "quillon" .. num )
		end

		if ( !bone && SERVER ) then
			self:SetIncorrectPlayerModel( 1 )
		end

		if ( attachment && attachment > 0 ) then
			local PosAng = self:GetAttachment( attachment )

			if ( !bone && SERVER ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if ( SERVER && IsValid( self.Owner ) && self.Owner:IsPlayer() && self.Owner:Crouching() ) then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				else
					self:SetIncorrectPlayerModel( 1 )
				end
			end

			ang:RotateAroundAxis( ang:Forward(), 180 )
			ang:RotateAroundAxis( ang:Up(), 30 )
			ang:RotateAroundAxis( ang:Forward(), -5.7 )
			ang:RotateAroundAxis( ang:Right(), 92 )

			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6

			return pos, ang:Forward()
		end

		self:SetIncorrectPlayerModel( 1 )
	else
		self:SetIncorrectPlayerModel( 2 )
	end

	if ( self:GetIncorrectPlayerModel() == 0 ) then self:SetIncorrectPlayerModel( 1 ) end

	local defAng = self:GetAngles()
	defAng.p = 0

	local defPos = self:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	if ( SERVER ) then defPos = defPos + Vector( 0, 0, 36 ) end
	if ( SERVER && IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
end


function SWEP:GetSaberSecPosAng( num, side, model )
	num = num or 1

	if ( SERVER ) then self:SetIncorrectPlayerModel( 0 ) end

	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
		local attachment
		if model then
			attachment = model:LookupAttachment( "blade" .. num )
			if ( side ) then
				attachment = model:LookupAttachment( "quillon" .. num )
			end
		end

		if ( !bone && SERVER ) then
			self:SetIncorrectPlayerModel( 1 )
		end

		if ( attachment && attachment > 0 ) then
			local PosAng = model:GetAttachment( attachment )

			if ( !bone && SERVER ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if ( SERVER && IsValid( self.Owner ) && self.Owner:IsPlayer() && self.Owner:Crouching() ) then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				else
					self:SetIncorrectPlayerModel( 1 )
				end
			end
			if num > 1 then
				ang:RotateAroundAxis( ang:Forward(), 180 )
			end
			if self:GetSecWorldModel() == "models/donation gauntlet/donation gauntlet.mdl" then
				ang:RotateAroundAxis( ang:Up(), 30 )
				ang:RotateAroundAxis( ang:Right(), 82 )
				pos = pos + ang:Up() * -2.5 + ang:Right()*2.6 + ang:Forward() * 32
				pos = pos + ang:Forward()*-26			
				ang:RotateAroundAxis( ang:Right(), -60 )
				ang:RotateAroundAxis( ang:Up(), -40 )
			else
				ang:RotateAroundAxis( ang:Up(), 30 )
				ang:RotateAroundAxis( ang:Right(), 82 )
				pos = pos + ang:Up() * -2.5 + ang:Right()*2.6 + ang:Forward() * 32
				pos = pos + ang:Forward()*-26
			end
			
			return pos, ang:Forward()
		end

		self:SetIncorrectPlayerModel( 1 )
	else
		self:SetIncorrectPlayerModel( 2 )
	end

	if ( self:GetIncorrectPlayerModel() == 0 ) then self:SetIncorrectPlayerModel( 1 ) end

	local defAng = model:GetAngles()
	defAng.p = 0

	local defPos = model:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	if ( SERVER ) then defPos = defPos + Vector( 0, 0, 36 ) end
	if ( SERVER && IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
end

function SWEP:OnForceChanged( name, old, new )
	if ( old > new ) then
		self.NextForce = CurTime() + 4
	end
end
SWEP.BlockCoolDown = 0
function SWEP:Think()
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )
	
	if self.Owner:KeyDown( IN_WALK ) and !self.Owner:KeyDown( IN_SPEED ) and ( ( wOS.EnableStamina and self:GetStamina() > 1 ) or ( !wOS.EnableStamina and self:GetForce() > 1 ) ) and self:GetEnabled() and !( prone and self.Owner:IsProne() ) and self:GetNextPrimaryFire() < CurTime() then
		self.Owner:SetNW2Bool( "IsBlocking", true )
		self.Owner:SetNW2Float( "BlockTime", CurTime() + 0.4 )
		if wOS.EnableStamina then
			self:AddStamina( -1*self:GetBlockDrain() )
		else
			self:SetForce( self:GetForce() - self:GetBlockDrain() )
		end
		self.Owner.IsBlocking = true	
	else
		self.Owner:SetNW2Bool( "IsBlocking", false )
		if self.Owner.IsBlocking then
			self.Owner.IsBlocking = false
		end
	end
	
	if CLIENT then return end
	
	self:ServerThoughts()
	
end

function SWEP:DrawHitEffects( trace, traceBack )
	if ( self:GetBladeLength() <= 0 ) then return end

	if ( trace.Hit ) then
		rb655_DrawHit_wos( trace.HitPos, trace.HitNormal )
	end

	if ( traceBack && traceBack.Hit ) then
		rb655_DrawHit_wos( traceBack.HitPos, traceBack.HitNormal )
	end
end

-- ------------------------------------------------------------- Fluid holdtype changes ----------------------------------------------------------------- --

local index = ACT_HL2MP_IDLE_KNIFE
local KnifeHoldType = {}
KnifeHoldType[ ACT_MP_STAND_IDLE ] = index
KnifeHoldType[ ACT_MP_WALK ] = index + 1
KnifeHoldType[ ACT_MP_RUN ] = index + 2
KnifeHoldType[ ACT_MP_CROUCH_IDLE ] = index + 3
KnifeHoldType[ ACT_MP_CROUCHWALK ] = index + 4
KnifeHoldType[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = index + 5
KnifeHoldType[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index + 5
KnifeHoldType[ ACT_MP_RELOAD_STAND ] = index + 6
KnifeHoldType[ ACT_MP_RELOAD_CROUCH ] = index + 6
KnifeHoldType[ ACT_MP_JUMP ] = index + 7
KnifeHoldType[ ACT_RANGE_ATTACK1 ] = index + 8
KnifeHoldType[ ACT_MP_SWIM ] = index + 9

function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then
		if ( self.ActivityTranslateAI[ act ] ) then return self.ActivityTranslateAI[ act ] end
		return -1
	end

	if ( self.Owner:Crouching() ) then
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + Vector( 0, 0, 20 ),
			mins = self.Owner:OBBMins(),
			maxs = self.Owner:OBBMaxs(),
			filter = self.Owner
		} )

		if ( self:GetEnabled() && tr.Hit && act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ) then return ACT_HL2MP_IDLE_KNIFE + 5 end

		if ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) && self.Owner:Crouching() && act == ACT_MP_CROUCH_IDLE ) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if ( ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) or ( self:GetEnabled() && tr.Hit ) ) && act == ACT_MP_CROUCH_IDLE ) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if ( ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) or ( self:GetEnabled() && tr.Hit ) ) && act == ACT_MP_CROUCHWALK ) then return ACT_HL2MP_IDLE_KNIFE + 4 end

	end

	if ( self.Owner:WaterLevel() > 1 && self:GetEnabled() ) then
		return KnifeHoldType[ act ]
	end

	if ( self.ActivityTranslate[ act ] != nil ) then return self.ActivityTranslate[ act ]end
	return -1
end