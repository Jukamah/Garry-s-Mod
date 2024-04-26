if not SERVER then return end

if not sql.TableExists("vpt") then
	sql.Query("CREATE TABLE IF NOT EXISTS vpt ( id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, player INTEGER NOT NULL, totaltime INTEGER NOT NULL, lastvisit INTEGER NOT NULL );")
	sql.Query("CREATE INDEX IDX_UTIME_PLAYER ON vpt ( player DESC );")
end

if not sql.TableExists("vptit") then
	sql.Query("CREATE TABLE IF NOT EXISTS vptit (id, int, sid string, istracking int)")
end

function onJoin( ply )
		local uid = ply:UniqueID()
		local row = sql.QueryRow("SELECT totaltime, lastvisit FROM vpt WHERE player = " .. uid .. ";")
		local time = 0

		if row then
			sql.Query("UPDATE vpt SET lastvisit = " .. os.time() .. " WHERE player = " .. uid .. ";")
			time = row.totaltime
		else
			sql.Query("INSERT into vpt ( player, totaltime, lastvisit ) VALUES ( " .. uid .. ", 0, " .. os.time() .. " );")
		end
		ply:SetPT(time)
		ply:SetPTStart(CurTime())
		
		local sid = ply:SteamID()
		
		local rowV = sql.QueryRow("SELECT sid FROM vptit WHERE id = ".. uid.. ";")
		
		if !rowV then
			sql.Query("INSERT into vptit ( id, sid, istracking) VALUES ( ".. uid.. ", '".. sid.. "', 0 );")
		end
end
hook.Add( "PlayerInitialSpawn", "PTInitialSpawn", function(ply)
	timer.Create("V-PT-IPS", 1, 1, onJoin(ply))
end)

hook.Add("PlayerSpawn", "PTSpawn", function(ply)	
	local uid = ply:UniqueID()
	local row = sql.QueryRow("SELECT totaltime, lastvisit FROM vpt WHERE player = " .. uid .. ";")
	print(row.totaltime)
	
	local rowC = sql.QueryRow("SELECT sid, istracking FROM vptit WHERE id = ".. uid.. ";")
	print(rowC)
	
	sql.Query("UPDATE vptit SET istracking = 1 WHERE id = '".. uid.. "';")
end)

function updatePlayer( ply )
	sql.Query( "UPDATE vpt SET totaltime = " .. math.floor(ply:GetPTTotalTime()) .. " WHERE player = " .. ply:UniqueID() .. ";")
end
hook.Add("PlayerDisconnected", "PTDisconnect", updatePlayer)

function updateAll()
	local players = player.GetAll()

	for _, ply in ipairs( players ) do
		if ply and ply:IsConnected() then
			updatePlayer( ply )
		end
	end
end
timer.Create("PTTimer", 67, 0, updateAll)