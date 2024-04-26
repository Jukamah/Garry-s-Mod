
dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS or 0

local function CheckDumpsterCount()
	local dumpsterDataFile = "dumpstersystem/data.txt"

	if file.Exists( dumpsterDataFile, "DATA" ) then
		local dumpsterData = util.JSONToTable( file.Read( dumpsterDataFile, "DATA" ) )

		dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterData.DumpsterCount
	else
		return
	end
end

local function SaveDumpsterData( positive, amount )
	if not file.IsDir( "dumpstersystem", "DATA" ) then
			file.CreateDir( "dumpstersystem", "DATA" )
			local dumpsterDataFile = "dumpstersystem/data.txt"

			local data = {
				DumpsterCount = amount
			}

			file.Write( dumpsterDataFile, util.TableToJSON( data ) )
		else
			local dumpsterDataFile = "dumpstersystem/data.txt"

			if file.Exists( dumpsterDataFile, "DATA" ) then
				local dumpsterData = util.JSONToTable( file.Read( dumpsterDataFile, "DATA" ) )
				local TempDumpsterCount = dumpsterData.DumpsterCount

				local data = {}

				if positive then
					data = {
						DumpsterCount = TempDumpsterCount + amount
					}
				else
					data = {
						DumpsterCount = TempDumpsterCount - amount
					}
				end

				file.Write( dumpsterDataFile, util.TableToJSON( data ) )
			else
				local dumpsterDataFile = "dumpstersystem/data.txt"

				local data = {
					DumpsterCount = amount
				}

				file.Write( dumpsterDataFile, util.TableToJSON( data ) )
			end
		end

		CheckDumpsterCount()
end

concommand.Add( "dumpsters_save", function( ply )
	local amount = 0
	if( ply:IsSuperAdmin() ) then
		if not file.IsDir( "dumpstersystem", "DATA" ) then
			file.CreateDir( "dumpstersystem", "DATA" )
			file.CreateDir( "dumpstersystem/dumpsters", "DATA" )
			CheckDumpsterCount()
			for k, v in pairs( ents.FindByClass( "berserkdumpster" ) ) do
				dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS + 1
				amount = amount + 1

				local dumpsterDataFile = "dumpstersystem/dumpsters/dumpster_" .. dumpsterSystem.config.TOTAL_DUMPSTERS .. ".txt"

				if file.Exists( dumpsterDataFile, "DATA" ) then repeat
					dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS + 1
					dumpsterDataFile = "dumpstersystem/dumpsters/dumpster_" .. dumpsterSystem.config.TOTAL_DUMPSTERS .. ".txt"
				until
					file.Exists( dumpsterDataFile, "DATA" ) == false
				end

				local data = {
					Position = v:GetLocalPos(),
					Angle = v:GetLocalAngles(),
					Map = tostring( game.GetMap() )
				}

				file.Write( dumpsterDataFile, util.TableToJSON( data ) )
			end
			ply:PrintMessage( HUD_PRINTTALK, "File does not exist for this map, creating new one for map '" .. tostring( game.GetMap() ) .. "'." )
			SaveDumpsterData( true, amount )
		else
			local validMap = true

			for k, v in pairs( file.Find( "dumpstersystem/dumpsters/dumpster_*.txt", "DATA" ) ) do
				local dumpsterDataFile = "dumpstersystem/dumpsters/" .. v

				local map
				if file.Exists( dumpsterDataFile, "DATA" ) then
					local dumpsterData = util.JSONToTable( file.Read( dumpsterDataFile, "DATA" ) )
					map = dumpsterData.Map
				else
					return
				end

				if map == game.GetMap() then
					ply:PrintMessage( HUD_PRINTTALK, "Please use dumpsters_reset before creating a new file!" )
					validMap = false
					return
				end
			end

			if validMap then
				CheckDumpsterCount()
				for k, v in pairs( ents.FindByClass( "berserkdumpster" ) ) do
					dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS + 1
					amount = amount + 1

					local dumpsterDataFile = "dumpstersystem/dumpsters/dumpster_" .. dumpsterSystem.config.TOTAL_DUMPSTERS .. ".txt"

					if file.Exists( dumpsterDataFile, "DATA" ) then repeat
						dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS + 1
						dumpsterDataFile = "dumpstersystem/dumpsters/dumpster_" .. dumpsterSystem.config.TOTAL_DUMPSTERS .. ".txt"
					until
						file.Exists( dumpsterDataFile, "DATA" ) == false
					end

					local data = {
						Position = v:GetLocalPos(),
						Angle = v:GetLocalAngles(),
						Map = tostring( game.GetMap() )
					}

					file.Write( dumpsterDataFile, util.TableToJSON( data ) )
				end
				ply:PrintMessage( HUD_PRINTTALK, "File does not exist for this map, creating new one for map '" .. tostring( game.GetMap() ) .. "'." )
				SaveDumpsterData( true, amount )
			end
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You are not an administrator!" )
	end
end )

concommand.Add( "dumpsters_reset", function( ply )
	local amount = 0
	if( ply:IsSuperAdmin() ) then
		if file.Exists( "dumpstersystem", "DATA" ) then
			CheckDumpsterCount()
			for k, v in pairs( file.Find( "dumpstersystem/dumpsters/dumpster_*.txt", "DATA" ) ) do
				local dumpsterDataFile = "dumpstersystem/dumpsters/" .. v

				local map

				if file.Exists( dumpsterDataFile, "DATA" ) then
					local dumpsterData = util.JSONToTable( file.Read( dumpsterDataFile, "DATA" ) )
					map = dumpsterData.Map
				else
					continue
				end

				if map != game.GetMap() then continue end

				dumpsterSystem.config.TOTAL_DUMPSTERS = dumpsterSystem.config.TOTAL_DUMPSTERS - 1
				amount = amount + 1

				file.Delete( "dumpstersystem/dumpsters/" .. v )
			end
			ply:PrintMessage( HUD_PRINTTALK, "Successfully deleted dumpster data files for map '" .. game.GetMap() .. "'. Please reset your server." )
			SaveDumpsterData( false, amount )

			file.Delete( "dumpstersystem/dumpsters" )
			file.Delete( "dumpstersystem/data.txt" )
			file.Delete( "dumpstersystem" )
		else
			ply:PrintMessage( HUD_PRINTTALK, "Dumpster file does not exist." )
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You are not an administrator!" )
	end
end )

local function SpawnDumpsters()
	local id = 0

	for k, v in pairs( file.Find( "dumpstersystem/dumpsters/dumpster_*.txt", "DATA" ) ) do
		id = id + 1

		local dumpsterDataFile = "dumpstersystem/dumpsters/" .. v

		local pos
		local ang
		local map

		if file.Exists( dumpsterDataFile, "DATA" ) then
			local dumpsterData = util.JSONToTable( file.Read( dumpsterDataFile, "DATA" ) )
			pos = dumpsterData.Position
			ang = dumpsterData.Angle
			map = dumpsterData.Map
		else
			return
		end

		if map != game.GetMap() then continue end

		local DumpsterEnt = ents.Create( "berserkdumpster" )

		DumpsterEnt:SetPos( Vector( pos ) )
		DumpsterEnt:SetAngles( ang )
		DumpsterEnt:Spawn()
	end
end
hook.Add( "Initialize", "dumpstersystem_InitDumpsters", SpawnDumpsters )