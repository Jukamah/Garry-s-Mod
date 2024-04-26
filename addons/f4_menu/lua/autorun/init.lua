-- Add the new files
AddCSLuaFile( "cl_init.lua" )
--AddCSLuaFile( "hackcraft.lua" )
-- Include server files
--include( "hackcraft.lua" )
-- Net Library Networkstring
	util.AddNetworkString( "hackcraft2" )
	
-- Net Library Message
	hook.Add( "ShowSpare2", "hacks", function( ply )
		net.Start( "hackcraft2" )
		net.Send( ply )
	end )
