local MaxStocks = 1000000

local MaxPlayerStocks = 333333

local StockDeviation = 0.05 // In percent .05 = 5%

local StockUpdate = 5 // How often to simulate stock change (in minutes)

/*
	Stocks:
		{ "Company Name", "Company Info", <Base Stock Price> }
*/

local Stocks = {
	{ "SyntheTech", "Company producing droid equipment.", 100 },
	{ "Atlas Corp", "Corporation specialized in armor accessories.", 100},
	{ "Beemon Laboratories", "Company producing cybernetic implants.", 100},
	{ "Galactic Arms", "Company producing firearm add-ons.", 100},
	{ "BlasTech Industries", "One of three, of the top arms manufacturers.", 100},
}

local StockMonitorModel		= "models/props_combine/combine_intmonitor001.mdl"
local StockViewModel		= "models/hunter/plates/plate.mdl"

/* DO NOT EDIT BELOW*/

VBGSTOCKLIST		= Stocks
VBGSTOCKSETTING		= { MaxStocks, MaxPlayerStocks, StockDeviation, StockUpdate }

VBGSTOCKEXMODEL = StockMonitorModel
VBGSTOCKVIEWMODEL = StockViewModel