local function DisallowSpawnMenu( )
	if not LocalPlayer():IsSuperAdmin() then
		return false
	end
end
hook.Add( "SpawnMenuOpen", "DisallowSpawnMenu", DisallowSpawnMenu)

local function DisallowContextMenu()
	if not LocalPlayer():IsSuperAdmin() then
		return false
	end
end
hook.Add("ContextMenuOpen", "DisallowContextMenu", DisallowContextMenu)