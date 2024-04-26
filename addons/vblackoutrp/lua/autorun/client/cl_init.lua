local clSide = file.Find("addons/vblackoutrp/lua/*.lua", "GAME")

for k, v in pairs(clSide) do
	include(v)
end

surface.CreateFont("BRP.Armoury.Weapon", {
	font = "Arial",
	extended = false,
	size = ScreenScale(10),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})