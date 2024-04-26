
hook.Add( "PlayerInitialSpawn", "DumpsterSystemCanUseDumpster", function( ply )
    ply:SetNWBool( "CanUseDumpster", true )
end )