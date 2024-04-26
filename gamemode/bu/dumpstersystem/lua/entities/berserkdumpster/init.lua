
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "dumpsterSystem_DoDumpsterUse" )
util.AddNetworkString( "dumpsterSystem_DoDumpsterUseComplete" )

local dumpsterPos = dumpsterPos

function ENT:Initialize()
	self:SetModel( dumpsterSystem.config.DUMPSTER_PROP_MODEL )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
	if ( phys:IsValid())  then
		phys:Wake()
	end
end

function ENT:Use( activator, caller, useType )
	if !self:IsValid() then return end
    if activator:GetNWBool( "CanUseDumpster" ) == false then activator:PrintMessage( HUD_PRINTTALK, "You need to wait before doing that again!" ) return end

    activator:SetNWBool( "CanUseDumpster", false )

    activator:Freeze( true )

    net.Start( "dumpsterSystem_DoDumpsterUse" )
    net.Send( activator )
end

function ENT:Think()
    dumpsterPos = self:GetPos()
end

net.Receive( "dumpsterSystem_DoDumpsterUseComplete", function( len, ply )
    ply:Freeze( false )

    local randomSpawn = math.random( 1, 2 )
    local randomWeapon = table.Random( dumpsterSystem.config.DUMPSTER_RANDOM_WEAPONS )
    local randomItem = table.Random( dumpsterSystem.config.DUMPSTER_RANDOM_ITEMS )

    if randomSpawn == 1 then
        local weaponEntity = ents.Create( randomWeapon )
        if weaponEntity:IsValid() then
            weaponEntity:SetPos( Vector( dumpsterPos.x, dumpsterPos.y, dumpsterPos.z + 50 ) )
            weaponEntity:Spawn()
        end
    elseif randomSpawn == 2 then
        local drugEntity = ents.Create( randomItem )
        if drugEntity:IsValid() then
            drugEntity:SetPos( Vector( dumpsterPos.x, dumpsterPos.y, dumpsterPos.z + 50 ) )
            drugEntity:Spawn()
        end
    end

    timer.Simple( dumpsterSystem.config.DUMPSTER_WAIT_TIME, function()
        ply:SetNWBool( "CanUseDumpster", true )
    end )
end )