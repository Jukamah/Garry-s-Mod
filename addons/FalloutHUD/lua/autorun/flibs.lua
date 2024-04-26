if SERVER then
	resource.AddFile("materials/hud/fo/grenade.vtf")
	resource.AddFile("materials/hud/fo/grenade.vmt")
	resource.AddFile("materials/hud/fo/life_hud.vtf")
	resource.AddFile("materials/hud/fo/life_hud.vmt")
	resource.AddFile("materials/hud/fo/player_found.vtf")
	resource.AddFile("materials/hud/fo/player_found.vmt")
	resource.AddFile("materials/hud/fo/pointer.vtf")
	resource.AddFile("materials/hud/fo/pointer.vmt")
	resource.AddFile("materials/hud/fo/pointer2.vtf")
	resource.AddFile("materials/hud/fo/pointer2.vmt")
	resource.AddFile("materials/hud/fo/tick.vtf")
	resource.AddFile("materials/hud/fo/tick.vmt")
	resource.AddFile("materials/hud/fo/x.vtf")
	resource.AddFile("materials/hud/fo/x.vmt")
end

if CLIENT then
	function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
		if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
			return
		end
		 
		local percX, percY = partx / texw, party / texh;
		local percW, percH = partw / texw, parth / texh;

		local vertexData = {
			{
				x = x,
				y = y,
				u = percX,
				v = percY
			},
			{
				x = x + w,
				y = y,
				u = percX + percW,
				v = percY
			},
			{
				x = x + w,
				y = y + h,
				u = percX + percW,
				v = percY + percH
			},
			{
				x = x,
				y = y + h,
				u = percX,
				v = percY + percH
			}
		}
			 
		surface.DrawPoly( vertexData )
	end
	 
	function draw.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texturename )
		if not( x && y && w && h && partx && party && partw && parth && texturename ) then
			 
			return
		end

		local texture = surface.GetTextureID(texturename)
		 
		local texW, texH = surface.GetTextureSize(texture)
		local percX, percY = partx / texW, party / texH
		local percW, percH = partw / texW, parth / texH

		local vertexData = {
			{
				x = x,
				y = y,
				u = percX,
				v = percY
			},
			{
				x = x + w,
				y = y,
				u = percX + percW,
				v = percY
			},
			{
				x = x + w,
				y = y + h,
				u = percX + percW,
				v = percY + percH
			},
			{
				x = x,
				y = y + h,
				u = percX,
				v = percY + percH
			}
		}
		 
		surface.SetTexture(texture)
		surface.SetDrawColor( 255, 255, 255, 255  * multiplo_fixture )
		surface.DrawPoly(vertexData)
	end

	function GetAngleOfLineBetweenTwoPoints(p1, p2)
		xDiff = p2:GetPos().x - p1:GetPos().x;
		yDiff = p2:GetPos().y - p1:GetPos().y;

		return math.atan2(yDiff, xDiff) * (180 / math.pi)
	end
end