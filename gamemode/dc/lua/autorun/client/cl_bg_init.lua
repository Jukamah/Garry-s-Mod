function vBGToX(x)
	return (x / 1768 * ScrW())
end

function vBGToY(y)
	return (y / 992 * ScrH())
end

function vBGDrawBackground(w, h, x, y)
	surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
	surface.DrawRect(0, 0, w, h)
		
	local upW, upH = w - vBGToX(4), h - vBGToY(4)

	for a = 0, x - 1, 1 do
		for b = 0, y - 1, 1 do
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(upW / x * a + vBGToX(2), upH / y * b + vBGToY(2), upW / x , upH / y)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(upW / x * a + vBGToX(3), upH / y * b + vBGToY(3), upW / x - vBGToX(2), upH / y - vBGToY(2))		
		end
	end
end

function vBGDrawOutlinedBox(w, h)
	surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(VBGUICOLOUR["base.a"])
	surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
end
	
function vBGDrawCloseButton(w, h, condition)
	if condition then
		surface.SetDrawColor(255, 0, 0)
	else
		surface.SetDrawColor(100, 0, 0)
	end
	surface.DrawRect(0, 0, w, h)
end
	
function vBGDrawOutlinedButton(enabled, w, h, condition, value)
	if enabled then
		if condition then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	else
		surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(VBGUICOLOUR["base.a"])
		surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
	end
end

function vBGDrawOutlinedButtonToggle(w, h, condition1, condition2)
	if condition1 then
		if condition2 then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	else
		if condition2 then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	end
end
	
function vBGDrawIcon(x, y, w, h, texture, colour)
	surface.SetDrawColor(colour)
	surface.SetTexture(surface.GetTextureID(texture))
	surface.DrawTexturedRect(x, y, w, h)
end