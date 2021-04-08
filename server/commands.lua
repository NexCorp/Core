NEX.RegisterCommand('tp', 'admin', function(xPlayer, args, showError)
	local currentCoords = xPlayer.getCoords(true)
	NEX.RegisterLog(xPlayer.source, "ACTION", "Command: /tp\nTeleport [".. currentCoords.x .. " " .. currentCoords.y .. " " .. currentCoords.z .."] a [".. args.x .. " " .. args.y .. " " .. args.z .."]" )
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
	
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

NEX.RegisterCommand('reloadjobs', 'admin', function(xPlayer, args, showError)
	NEX.ReloadJobs()
	xPlayer.sendAlert({
		type = "success",
		title = "Reloaded Jobs!",
		text = "The system will start soon for everyone...",
		length = 4000,
		style = {}
	})
end, false, {help = 'Reload the job database.', validate = true, arguments = {}})

NEX.RegisterCommand('reloadqueue', 'admin', function(xPlayer, args, showError)
	TriggerEvent('QueueNex:RefreshList')
	xPlayer.sendAlert({
		type = "success",
		title = "Priority Queue Reloaded!",
		text = "The system will start soon for everyone...",
		length = 4000,
		style = {}
	})
end, false, {help = 'Reload priority queue.', validate = true, arguments = {}})



-- NEX.RegisterCommand('changecharacter', 'admin', function(xPlayer, args, showError)
-- 	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
-- end, false, {help = _U('command_setcoords'), validate = true, arguments = {
-- 	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
-- 	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
-- 	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
-- }})

-- NEX.RegisterCommand('changecharacterto', 'admin', function(xPlayer, args, showError)
-- 	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
-- end, false, {help = _U('command_setcoords'), validate = true, arguments = {
-- 	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
-- 	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
-- 	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
-- }})

NEX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)

	-- Temp fix for 'console' commands use
	if not xPlayer then
		xPlayer = {}
		xPlayer.source = nil
	end

	if NEX.DoesJobExist(args.job, args.grade) then
		if args.category == 1 or args.category == 2 then
			args.playerId.setJob(args.category, args.job, args.grade)
			local data = {
				type = "success",
				title = "Job Changed!",
				text = "New job to the player! " .. args.playerId.source .. " a " .. args.job .. " [".. args.category .."]",
				length = 4000,
				style = {}
			  }
			xPlayer.sendAlert(data)
			NEX.RegisterLog(xPlayer.source, "ACTION", "Command: /setjob\nChange the job #".. args.category .." from DB: "..args.playerId.dbId.." to " .. "(".. args.job .." [".. args.grade .."])")
		else
			showError("There is no category, try 1 or 2.")
		end
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = "category", help = "Job Category", type = "number"},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

NEX.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('nex_admin:runSpawnCommand', args.car)
end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})

NEX.RegisterCommand({'cardel', 'dv'}, 'admin', function(xPlayer, args, showError)
	xPlayer.triggerEvent('nex:Core:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

NEX.RegisterCommand('setaccountmoney', 'admin', function(xPlayer, args, showError)

	-- Temp fix for 'console' commands use
	if not xPlayer then
		xPlayer = {}
		xPlayer.source = nil
	end

	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
		NEX.RegisterLog(xPlayer.source, "ACTION", "Set money:\nReceives: " .. args.playerId.getName() .. "(".. args.playerId.charId .." [".. args.playerId.dbId .."]) [Bill: " .. args.account .. " ($".. args.amount ..")]")
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

NEX.RegisterCommand('giveaccountmoney', 'admin', function(xPlayer, args, showError)

	-- Temp fix for 'console' commands use
	if not xPlayer then
		xPlayer = {}
		xPlayer.source = nil
	end

	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
		NEX.RegisterLog(xPlayer.source, "ACTION", "Add money:\nReceives: " .. args.playerId.getName() .. "(".. args.playerId.charId .." [".. args.playerId.dbId .."]) [Bill: " .. args.account .. " ($".. args.amount ..")]")

	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

NEX.RegisterCommand('giveitem', 'admin', function(xPlayer, args, showError)
	--args.playerId.addInventoryItem(args.item, args.count)
	
	-- Temp fix for 'console' commands use
	if not xPlayer then
		xPlayer = {}
		xPlayer.source = nil
	end

	TriggerClientEvent('player:receiveItem', args.playerId.source, args.item, args.count)
	NEX.RegisterLog(xPlayer.source, "ACTION", "Delivery Item:\nReceuves: " .. args.playerId.getName() .. "(".. args.playerId.charId .." [".. args.playerId.dbId .."]) [Item: " .. args.item .. " ($".. args.count ..")]")

end, true, {help = _U('command_giveitem'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
	{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
}})

-- NEX.RegisterCommand('giveweapon', 'admin', function(xPlayer, args, showError)
-- 	if args.playerId.hasWeapon(args.weapon) then
-- 		showError(_U('command_giveweapon_hasalready'))
-- 	else
-- 		xPlayer.addInventoryItem(args.weapon, 1)
-- 		--xPlayer.addWeapon(args.weapon, args.ammo)
-- 	end
-- end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
-- 	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
-- 	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'item'},
-- 	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
-- }})

NEX.RegisterCommand('giveweaponcomponent', 'admin', function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weaponName) then
		local component = NEX.GetWeaponComponent(args.weaponName, args.componentName)

		if component then
			if xPlayer.hasWeaponComponent(args.weaponName, args.componentName) then
				showError(_U('command_giveweaponcomponent_hasalready'))
			else
				xPlayer.addWeaponComponent(args.weaponName, args.componentName)
			end
		else
			showError(_U('command_giveweaponcomponent_invalid'))
		end
	else
		showError(_U('command_giveweaponcomponent_missingweapon'))
	end
end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'}
}})

NEX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

NEX.RegisterCommand({'clearall', 'clsall'}, 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

NEX.RegisterCommand('clearinventory', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

NEX.RegisterCommand('clearloadout', 'admin', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.loadout) do
		args.playerId.removeWeapon(v.name)
	end
end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

NEX.RegisterCommand('setgroup', 'admin', function(xPlayer, args, showError)
	args.playerId.setGroup(args.group)

	-- Temp fix for 'console' commands use
	if not xPlayer then
		xPlayer = {}
		xPlayer.source = nil
	end

	NEX.RegisterLog(xPlayer.source, "ACTION", "Command: /setgroup\nAssign the group of: " .. args.playerId.getName() .. " [".. args.playerId.dbId .."]" .. " to " .. args.group)
end, true, {help = _U('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'},
}})

NEX.RegisterCommand('save', 'admin', function(xPlayer, args, showError)
	NEX.SavePlayer(args.playerId)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

NEX.RegisterCommand('saveall', 'admin', function(xPlayer, args, showError)
	NEX.SavePlayers()
end, true, {help = _U('command_saveall')})


NEX.RegisterCommand('menu', 'admin', function(xPlayer, args, showError)
	TriggerClientEvent('nex_admin:client:openMenu', xPlayer.source, xPlayer.getGroup(), xPlayer)
end, true, {help = 'Activate Admin Menu'})

NEX.RegisterCommand('hud', 'user', function(xPlayer, args, showError)
	TriggerClientEvent('nex:UI:setVisible', xPlayer.source)
end, true, {help = 'Activate / Deactivate the HUD'})


--- BANKING

if Config.EnablePayCommand then

	NEX.RegisterCommand('pay', 'user', function(xPlayer, args, showError)

		local amount = args.monto
		local targetPlayer = args.paypal

		if xPlayer.getMoney() >= amount and xPlayer.getMoney() > 0 then
			if xPlayer.charId ~= targetPlayer.charId then
				TriggerClientEvent('banking:client:CheckDistance', xPlayer.source, targetPlayer.source, amount)
          
				NEX.RegisterLog(xPlayer.source, "ECONOMY", "(Pay) Give Money:\nReceives: " .. targetPlayer.getName() .. "(".. targetPlayer.charId .." [".. targetPlayer.dbId .."]) ($".. amount ..")]")

			else
				local data = {
					type = "error",
					title = "Whoops!",
					text = "Life is a bycycle, but is it worth getting on?",
					length = 4000,
					style = {}
				}
				xPlayer.sendAlert(data)
			end
		else
			local data = {
				type = "error",
				title = "Whoops!",
				text = "Make sure you have enough money or enter a larger amount to pay.",
				length = 4000,
				style = {}
			  }
			xPlayer.sendAlert(data)
		end

	end, true, {help = _U('command_setgroup'), validate = true, arguments = {
		{name = 'paypal', help = _U('commandgeneric_playerid'), type = 'player'},
		{name = 'monto', help = _U('command_setgroup_group'), type = 'number'},
	}})
	
end