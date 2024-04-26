CLASS.name = "Black Sun"
CLASS.faction = FACTION_BLACKSUN

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", false)
end

CLASS_BS_ENLISTED = CLASS.index