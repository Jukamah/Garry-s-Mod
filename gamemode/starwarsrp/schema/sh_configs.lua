WEAPON_REQSKILLS = {}

local function addRequire(itemID, reqAttribs)
	WEAPON_REQSKILLS[itemID] =  reqAttribs
end

nut.currency.symbol = "c"
nut.currency.singular = "credit"
nut.currency.plural = "credits"

-- Lists of item to drop when player dies.
-- The number represents the chance of drop of the item.
DROPITEM = {
	--["item_class_to_drop"] = 1,
}

-- Adding Schema Specific Configs.
nut.config.setDefault("font", "Bitstream Vera Sans")

nut.config.add("deathWeapon", false, "Drop weapon when player dies?", nil, {
	category = "penalty"
})