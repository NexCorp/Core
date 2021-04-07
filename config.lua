Config = {}
Config.Locale = 'en'

Config.ServerName = "NexCore Server"

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money'),
	points = 'NEX-Points'
}

Config.StartingAccountMoney = {bank = 3000, money=2000, points = 0}

Config.EnableSocietyPayouts = false -- pay from the society account that the player is employed at? Requirement: nex_factions
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            = 2000   -- the max inventory weight without backpack
Config.PaycheckInterval     = 20 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug          = true

-- CUSTOM CORE CONFIG
Config.EnablePayCommand 	= true

Config.Tax = 0.16 -- salary * tax
Config.EnableTax = false
Config.VipTiers = { -- VIP Tier => percent
	[1] = 0.1,
	[2] = 0.2,
	[3] = 0.3,
	[4] = 0.4,
	[5] = 0.5,
	[6] = 0.6
}

Config.VipTierDefault = 0.1
Config.SendTaxToMazeBankSociety = false -- Use for store money taxes on a 'virtual bank' || You must have a nex_factions extension

---- MUST BE CONFIGURED
--[[
	Paycheck Tax : boolean
	Max Characters per user : int
	modular VIP system for tax : table?
]]