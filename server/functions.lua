NEX.Trace = function(msg)
	if Config.EnableDebug then
		print(('[NexCore] [^2TRACE^7] %s^7'):format(msg))
	end
end

NEX.SetTimeout = function(msec, cb)
	local id = NEX.TimeoutCount + 1

	SetTimeout(msec, function()
		if NEX.CancelledTimeouts[id] then
			NEX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	NEX.TimeoutCount = id

	return id
end

NEX.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for k,v in ipairs(name) do
			NEX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if NEX.RegisteredCommands[name] then
		print(('[NexCore] [^3WARNING^7] An command "%s" is already registered, overriding command'):format(name))

		if NEX.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	NEX.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(playerId, args, rawCommand)
		local command = NEX.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[NexCore] [^3WARNING^7] %s'):format(_U('commanderror_console')))
		else
			local xPlayer, error = NEX.GetPlayerFromId(playerId), nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k,v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == "multistring" then
								newArgs[v.name] = args
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then targetPlayer = playerId end

								if targetPlayer then
									local xTargetPlayer = NEX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = _U('commanderror_invalidplayerid')
									end
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'item' then
								newArgs[v.name] = args[k]
							elseif v.type == 'weapon' then
								if NEX.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								else
									error = _U('commanderror_invalidweapon')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
					print(('[NexCore] [^3WARNING^7] %s^7'):format(error))
				else
					local data = {
						type = "error",
						title = "¡Command Whoops!",
						text = error,
						length = 3000,
						style = {}
					  }
					xPlayer.sendAlert(data)
					--xPlayer.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', error}})
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
						print(('[NexCore] [^3WARNING^7] %s^7'):format(msg))
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

NEX.ClearTimeout = function(id)
	NEX.CancelledTimeouts[id] = true
end

NEX.RegisterServerEvent =  function(name, cb)
	print("Registro => ", name)
	NEX.ServerEvents[name] = cb
end

NEX.TriggerClientCallback = function(source, name, cb, ...)
    local playerId = tostring(source)

    if NEX.ClientCallbacks == nil then
        NEX.ClientCallbacks = {}
    end

    if NEX.ClientCallbacks[playerId] == nil then
        NEX.ClientCallbacks[playerId] = {}
        NEX.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end

    NEX.ClientCallbacks[playerId][tostring(NEX.ClientCallbacks[playerId]['CurrentRequestId'])] = cb

    TriggerClientEvent('nex:Core:triggerClientCallback', source, name, NEX.ClientCallbacks[playerId]['CurrentRequestId'], ...)

    if NEX.ClientCallbacks[playerId]['CurrentRequestId'] < 65535 then
        NEX.ClientCallbacks[playerId]['CurrentRequestId'] = NEX.ClientCallbacks[playerId]['CurrentRequestId'] + 1
    else
        NEX.ClientCallbacks[playerId]['CurrentRequestId'] = 0
    end
end

NEX.TriggerServerEvent = function(name, source, ...) 
    if NEX.ServerEvents ~= nil and NEX.ServerEvents[name] ~= nil then 
        NEX.ServerEvents[name](source, ...) 
    else 
        print("[NexCore] [^3WARNING^7] TriggerServerEvent => '" .. name .. "' not found.") 
    end 
end 

NEX.RegisterServerCallback = function(name, cb)
	NEX.ServerCallbacks[name] = cb
end

NEX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	Citizen.Wait(30) -- fix event spam? 
	if NEX.ServerCallbacks[name] then
		NEX.ServerCallbacks[name](source, cb, ...)
	else
		print(('[NexCore] [^3WARNING^7] Server callback "%s" does not exist.'):format(name))
	end
end

NEX.SwitchPlayerData = function(xPlayer, playerId, charId, cb)
	local canContinue = false
	print('[NexCore] [^2INFO^7] Preparing player switching for ' .. xPlayer.getName() .. ' from #'.. xPlayer.getCharacterId() ..' to character #'..charId)
	xPlayer.PrepareForCharacterSwitching()

	while xPlayer.IsPlayerSwitchInProgress() do
		Citizen.Wait(5000)
		xPlayer.SetPlayerSwitchState(false)
	end
	
	NEX.SavePlayer(xPlayer, function()
		local identifier = xPlayer.identifier
		loadNEXPlayer(identifier, playerId, charId, function(isValid)
			if isValid then
				canContinue = true
			end
		end)
	end)
	Citizen.Wait(200)
	if canContinue then
		cb(true)
	else
		cb(false)
	end
end

NEX.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}

	table.insert(asyncTasks, function(cb2)
		MySQL.Async.execute('UPDATE users SET job_invitation=@jobInvite, isVip=@vip, sex=@sex, unlockCharacters=@unlockCharacters, tutorial=@tutorial, characterId = @charId, firstname = @firstname, lastname = @lastname, dob = @dob, height = @height, accounts = @accounts, job = @job, job_grade = @job_grade, job2=@job2, job_grade2 = @job_grade2, `group` = @group, loadout = @loadout, position = @position, inventory = @inventory WHERE identifier = @identifier', {
			['@charId'] = xPlayer.getCharacterId(),
			['@accounts'] = json.encode(xPlayer.getAccounts(true)),
			['@job'] = xPlayer.job.name,
			['@job_grade'] = xPlayer.job.grade,
			['@job2'] = xPlayer.job2.name,
			['@job_grade2'] = xPlayer.job2.grade,
			['@group'] = xPlayer.getGroup(),
			['@loadout'] = json.encode(xPlayer.getLoadout(true)),
			['@position'] = json.encode(xPlayer.getCoords()),
			['@identifier'] = xPlayer.getIdentifier(),
			['@inventory'] = json.encode(xPlayer.getInventory(true)),
			['@firstname'] = xPlayer.getGameData().getFirstname(),
			['@lastname'] = xPlayer.getGameData().getLastname(),
			['@dob'] = xPlayer.getGameData().getDob().getFullDate(),
			['@height'] = xPlayer.getGameData().getHeight(),
			['@tutorial'] = xPlayer.isTutorialPassed() or 0,
			['@unlockCharacters'] = xPlayer.getUnlockedCharacters(),
			['@sex'] = xPlayer.sex,
			['@jobInvite'] = xPlayer.jobInvitation or nil,
			['@vip'] = xPlayer.getVip()
		}, function(rowsChanged)
			cb2()
		end)

		if xPlayer.getCharacterId() > 0 then
			MySQL.Async.execute('UPDATE users_characters SET isVip=@vip, job_invitation=@jobInvite, sex = @sex, firstname = @firstname, lastname = @lastname, dob = @dob, height = @height, accounts = @accounts, job = @job, job_grade = @job_grade,  job2=@job2, job_grade2 = @job_grade2, loadout = @loadout, position = @position, inventory = @inventory WHERE identifier = @identifier AND characterId = @charId', {
				['@accounts'] = json.encode(xPlayer.getAccounts(true)),
				['@job'] = xPlayer.job.name,
				['@job_grade'] = xPlayer.job.grade,
				['@job2'] = xPlayer.job2.name,
				['@job_grade2'] = xPlayer.job2.grade,
				['@charId'] = xPlayer.getCharacterId(),
				['@loadout'] = json.encode(xPlayer.getLoadout(true)),
				['@position'] = json.encode(xPlayer.getCoords()),
				['@identifier'] = xPlayer.getIdentifier(),
				['@inventory'] = json.encode(xPlayer.getInventory(true)),
				['@firstname'] = xPlayer.getGameData().getFirstname(),
				['@lastname'] = xPlayer.getGameData().getLastname(),
				['@dob'] = xPlayer.getGameData().getDob().getFullDate(),
				['@height'] = xPlayer.getGameData().getHeight(),
				['@sex'] = xPlayer.sex,
				['@jobInvite'] = xPlayer.jobInvitation or nil,
				['@vip'] = xPlayer.getVip()
			}, function(rowsChanged)
				cb2()
			end)
		end
	end)

	Async.parallel(asyncTasks, function(results)
		print(('[NexCore] [^2INFO^7] Saved player "%s^7"'):format(xPlayer.getName()))

		if cb then
			cb()
		end
	end)
end

NEX.SavePlayers = function(cb)
	local xPlayers, asyncTasks = NEX.GetPlayers(), {}

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb2)
			local xPlayer = NEX.GetPlayerFromId(xPlayers[i])
			NEX.SavePlayer(xPlayer, cb2)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		print(('[NexCore] [^2INFO^7] Saved %s player(s)'):format(#xPlayers))
		if cb then
			cb()
		end
	end)
end

NEX.StartDBSync = function()
	function saveData()
		NEX.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

NEX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(NEX.Players) do
		table.insert(sources, k)
	end

	return sources
end

NEX.GetPlayerFromId = function(source)
	return NEX.Players[tonumber(source)]
end

NEX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(NEX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

NEX.GetPlayerFromDBId = function(dbid)
	for k,v in pairs(NEX.Players) do
		if v.dbId == dbid then
			return v
		end
	end
end

NEX.GetPlayerFromCharId = function(charId)
	for k,v in pairs(NEX.Players) do
		if v.charId == charId then
			return v
		end
	end
end

NEX.RegisterUsableItem = function(item, cb)
	NEX.UsableItemsCallbacks[item] = cb
end

NEX.UseItem = function(source, item)
	NEX.UsableItemsCallbacks[item](source, item)
end

NEX.GetItemLabel = function(item)
	if NEX.Items[item] then
		return NEX.Items[item].label
	end
end

NEX.CreatePickup = function(type, name, count, label, playerId, components, tintIndex)
	local pickupId = (NEX.PickupId == 65635 and 0 or NEX.PickupId + 1)
	local xPlayer = NEX.GetPlayerFromId(playerId)
	local coords = xPlayer.getCoords()

	NEX.Pickups[pickupId] = {
		type = type, name = name,
		count = count, label = label,
		coords = coords
	}

	if type == 'item_weapon' then
		NEX.Pickups[pickupId].components = components
		NEX.Pickups[pickupId].tintIndex = tintIndex
	end

	TriggerClientEvent('nex:Core:createPickup', -1, pickupId, label, coords, type, name, components, tintIndex)
	NEX.PickupId = pickupId
end

NEX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if NEX.Jobs[job] and NEX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

NEX.RegisterLog = function(playerId, category, message)
	local xPlayer = NEX.GetPlayerFromId(playerId)
	local urlToUse = NEX.Webhooks[category] or nil  
	
	if urlToUse ~= nil then
		local data = {
            embeds = {
                {
                    title = "[VIGILANTE] Acción Registrada",
                    description = "Nueva acción ejecutada:",
                    color = 16771840,
                    fields = {
                        {
                            name = "SteamName | DB | GameID",
                            value = xPlayer.getName() .. " | " .. xPlayer.getDBId() .. " | " .. xPlayer.source 
                        },
                        {
                            name = "LOG:",
                            value = message
                        },
                    },
                    footer = {
                        text = "Nexus AntiCheat",
                        icon_url = "https://images-ext-2.discordapp.net/external/05w3zIVuaUzJS6zPgq1FuOmG4kif6_NCPQQVHS864mw/https/images-ext-2.discordapp.net/external/PN4jUr9A0-7sD4iKtfJVB3MeTVaGQMhUaihqjp3qFRc/https/cdn.probot.io/HkWlJsRlXU.gif"
                    }
                }
            },
            username = "Nexus AntiCheat v2.0",
            avatar_url = "https://images-ext-2.discordapp.net/external/05w3zIVuaUzJS6zPgq1FuOmG4kif6_NCPQQVHS864mw/https/images-ext-2.discordapp.net/external/PN4jUr9A0-7sD4iKtfJVB3MeTVaGQMhUaihqjp3qFRc/https/cdn.probot.io/HkWlJsRlXU.gif" 
        }
        PerformHttpRequest(urlToUse, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
	else
		print('[NexCore] [^3WARNING^7] Register Action "'.. category ..'" was null.')
	end
end