
local ShouldDoDumpster = false
local ProgressBar = ProgressBar or 0
local ProgressBarDisplay = ProgressBarDisplay or 0
local SearchingText = "Searching"

surface.CreateFont("SearchingFont", {
  font = "Roboto",
  size = 38,
  weight = 500,
  antialias = true
})

timer.Create( "DumpsterSystem_SearchingTextNice", 0.5, 0, function()
    if SearchingText == "Searching" then
        SearchingText = "Searching."
    elseif SearchingText == "Searching." then
        SearchingText = "Searching.."
    elseif SearchingText == "Searching.." then
        SearchingText = "Searching..."
    elseif SearchingText == "Searching..." then
        SearchingText = "Searching"
    end
end )

net.Receive( "dumpsterSystem_DoDumpsterUse", function()
    ShouldDoDumpster = true
end )

hook.Add( "Think", "DumpsterSystemDumpsterThink", function()
    if ProgressBar >= 600 then
        ProgressBar = 0
        ShouldDoDumpster = false
        
        net.Start( "dumpsterSystem_DoDumpsterUseComplete" )
        net.SendToServer()
    end
end )

hook.Add( "HUDPaint", "DumpsterSystemDumpsterHUD", function()
    if ShouldDoDumpster then
        ProgressBar = math.Approach( ProgressBar, 600, 1 )
        ProgressBarDisplay = ProgressBar / 2
        draw.RoundedBox( 0, ScrW() / 2 - 300 / 2, ScrH() / 2, ProgressBarDisplay, 50, dumpsterSystem.config.SEARCHING_COLOUR )
        draw.OutlinedBox( ScrW() / 2 - 300 / 2, ScrH() / 2, 300, 50, 3, Color( 0, 0, 0, 255 ) )
        draw.SimpleTextOutlined( SearchingText, "SearchingFont", ScrW() / 2 - 300 / 2 + 10, ScrH() / 2 + 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0 ) )
    else
        ProgressBar = 0
    end
end )