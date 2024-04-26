--include ( "hackcraft.lua" )

-- Net Library Receive
	net.Receive( "hackcraft2", function()
local frame = vgui.Create( "DFrame" )
frame:SetSize( 500, 500 )
frame:Center()
frame:MakePopup()
frame:SetTitle( "Particularly Me Community" )

local sheet = vgui.Create( "DPropertySheet", frame )
sheet:Dock( FILL )

local panel1 = vgui.Create( "DPanel", sheet )
panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
sheet:AddSheet( "Money/Commands", panel1, "icon16/money.png" )

local panel2 = vgui.Create( "DPanel", sheet )
panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
sheet:AddSheet( "Jobs", panel2, "icon16/user_suit.png" )

local panel3 = vgui.Create( "DPanel", sheet )
panel3.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
sheet:AddSheet( "Entities", panel3, "icon16/cart.png" )

local panel4 = vgui.Create( "DPanel", sheet )
panel4.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
sheet:AddSheet( "Weapons", panel4, "icon16/shield.png" )

--local panel5 = vgui.Create( "DPanel", sheet )
--panel5.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 0 ) ) end
--sheet:AddSheet( "Donate", panel5 )

	end )