
--[[-------------------------------------------------------------------
	Advanced Combat System Core Net Functions:
		Needed for the thing to work!
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

wOS = wOS or {}
wOS.Form = wOS.Form or {}
wOS.Form.Singles = wOS.Form.Singles or {}
wOS.Form.Duals = wOS.Form.Duals or {}
wOS.Form.LocalizedForms = {}
wOS.Form.IndexedForms = {}
wOS.Forms = wOS.Forms or {}
wOS.DualForms = wOS.DualForms or {}

--Enums, ignore me!
FORM_SINGLE = 0
FORM_DUAL = 1
FORM_BOTH = 2

util.AddNetworkString( "wOS.SendForm" )
util.AddNetworkString( "wOS.SendFGroups" )

function wOS:RegisterNewForm( FORM )

	if FORM.Type == FORM_SINGLE then
		wOS.Form.Singles[ FORM.Name ] = table.Copy( FORM.Stances )
		wOS.Forms[ FORM.Name ] = table.Copy( FORM.UserGroups )
	elseif FORM.Type == FORM_DUAL then
		wOS.Form.Duals[ FORM.Name ] = table.Copy( FORM.Stances )	
		wOS.DualForms[ FORM.Name ] = table.Copy( FORM.UserGroups )
	else
		wOS.Form.Singles[ FORM.Name ] = table.Copy( FORM.Stances )
		wOS.Form.Duals[ FORM.Name ] = table.Copy( FORM.Stances )	
		wOS.Forms[ FORM.Name ] = table.Copy( FORM.UserGroups )
		wOS.DualForms[ FORM.Name ] = table.Copy( FORM.UserGroups )
	end
	
	wOS.Form.LocalizedForms[ #wOS.Form.LocalizedForms + 1 ] = FORM.Name
	wOS.Form.IndexedForms[ FORM.Name ] = #wOS.Form.LocalizedForms
	
	print( "[wOS] Successfully registered form: " .. FORM.Name )
	
end

function wOS.SendFormData( ply )

	net.Start( "wOS.SendForm" )
		net.WriteTable( wOS.Form )
	net.Send( ply )
	
	net.Start( "wOS.SendFGroups" )
		net.WriteTable( wOS.Forms )
		net.WriteTable( wOS.DualForms )
	net.Send( ply )

end

hook.Add( "PlayerInitialSpawn", "wOS.FormLocalization", function( ply ) wOS.SendFormData( ply ) end )