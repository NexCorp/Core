NEX                           = {}
NEX.PlayerData                = {}
NEX.PlayerLoaded              = false
NEX.CurrentRequestId          = 0
NEX.ServerCallbacks           = {}
NEX.ClientCallbacks     	  = {}
NEX.TimeoutCallbacks          = {}

NEX.UI                        = {}
NEX.UI.HUD                    = {}
NEX.UI.HUD.RegisteredElements = {}
NEX.UI.Menu                   = {}
NEX.UI.Menu.RegisteredTypes   = {}
NEX.UI.Menu.Opened            = {}

NEX.Game                      = {}
NEX.Game.Utils                = {}

NEX.Characters				  = {}

NEX.Scaleform                 = {}
NEX.Scaleform.Utils           = {}

NEX.Streaming                 = {}

NEX.SetTimeout = function(msec, cb)
	table.insert(NEX.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #NEX.TimeoutCallbacks
end

NEX.ClearTimeout = function(i)
	NEX.TimeoutCallbacks[i] = nil
end

NEX.IsPlayerLoaded = function()
	return NEX.PlayerLoaded
end

NEX.GetPlayerData = function()
	return NEX.PlayerData
end

NEX.SetPlayerData = function(key, val)
	NEX.PlayerData[key] = val
end

NEX.ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

NEX.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('esxAdvancedNotification', msg)
	BeginTextCommandThefeedPost('esxAdvancedNotification')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

NEX.ShowHelpNotification = function(msg, thisFrame, beep, duration)
	AddTextEntry('esxHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('esxHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('esxHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

NEX.ShowFloatingHelpNotification = function(msg, coords)
	AddTextEntry('esxFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

NEX.RegisterClientCallback = function(name, cb)
    NEX.ClientCallbacks[name] = cb
end

NEX.TriggerClientCallback = function(name, cb, ...)
    if (NEX.ClientCallbacks ~= nil and NEX.ClientCallbacks[name] ~= nil) then
        NEX.ClientCallbacks[name](cb, ...)
    end
end

NEX.TriggerServerCallback = function(name, cb, ...)
	NEX.ServerCallbacks[NEX.CurrentRequestId] = cb

	TriggerServerEvent('nex:Core:triggerServerCallback', name, NEX.CurrentRequestId, ...)

	if NEX.CurrentRequestId < 65535 then
		NEX.CurrentRequestId = NEX.CurrentRequestId + 1
	else
		NEX.CurrentRequestId = 0
	end
end

NEX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

NEX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #NEX.UI.HUD.RegisteredElements, 1 do
		if NEX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(NEX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	NEX.UI.HUD.UpdateElement(name, data)
end

NEX.UI.HUD.RemoveElement = function(name)
	for i=1, #NEX.UI.HUD.RegisteredElements, 1 do
		if NEX.UI.HUD.RegisteredElements[i] == name then
			table.remove(NEX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

NEX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

NEX.UI.Menu.RegisterType = function(type, open, close)
	NEX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

NEX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		NEX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #NEX.UI.Menu.Opened, 1 do
			if NEX.UI.Menu.Opened[i] then
				if NEX.UI.Menu.Opened[i].type == type and NEX.UI.Menu.Opened[i].namespace == namespace and NEX.UI.Menu.Opened[i].name == name then
					NEX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		NEX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(NEX.UI.Menu.Opened, menu)
	NEX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

NEX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #NEX.UI.Menu.Opened, 1 do
		if NEX.UI.Menu.Opened[i] then
			if NEX.UI.Menu.Opened[i].type == type and NEX.UI.Menu.Opened[i].namespace == namespace and NEX.UI.Menu.Opened[i].name == name then
				NEX.UI.Menu.Opened[i].close()
				NEX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

NEX.UI.Menu.CloseAll = function()
	for i=1, #NEX.UI.Menu.Opened, 1 do
		if NEX.UI.Menu.Opened[i] then
			NEX.UI.Menu.Opened[i].close()
			NEX.UI.Menu.Opened[i] = nil
		end
	end
end

NEX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #NEX.UI.Menu.Opened, 1 do
		if NEX.UI.Menu.Opened[i] then
			if NEX.UI.Menu.Opened[i].type == type and NEX.UI.Menu.Opened[i].namespace == namespace and NEX.UI.Menu.Opened[i].name == name then
				return NEX.UI.Menu.Opened[i]
			end
		end
	end
end

NEX.UI.Menu.GetOpenedMenus = function()
	return NEX.UI.Menu.Opened
end

NEX.UI.Menu.IsOpen = function(type, namespace, name)
	return NEX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

NEX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

NEX.Game.GetPedMugshot = function(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Citizen.Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

NEX.Game.Teleport = function(entity, coords, cb)
	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		local timeout = 0

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(entity) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

		if type(coords) == 'table' and coords.heading then
			SetEntityHeading(entity, coords.heading)
		end
	end

	if cb then
		cb()
	end
end

NEX.Game.SpawnObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		NEX.Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

NEX.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		NEX.Streaming.RequestModel(model)
		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
		SetModelAsNoLongerNeeded(model)

		if cb then
			cb(obj)
		end
	end)
end

NEX.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

NEX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

NEX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		NEX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)
		local timeout = 0

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

NEX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		NEX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		local timeout = 0

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		-- we can get stuck here if any of the axies are "invalid"
		while not HasCollisionLoadedAroundEntity(vehicle) and timeout < 2000 do
			Citizen.Wait(0)
			timeout = timeout + 1
		end

		if cb then
			cb(vehicle)
		end
	end)
end

NEX.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

NEX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

NEX.Game.GetPeds = function(onlyOtherPeds)
	local peds, myPed = {}, PlayerPedId()

	for ped in EnumeratePeds() do
		if ((onlyOtherPeds and ped ~= myPed) or not onlyOtherPeds) then
			table.insert(peds, ped)
		end
	end

	return peds
end

NEX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

NEX.Game.GetPlayers = function(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for k,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				table.insert(players, returnPeds and ped or player)
			end
		end
	end

	return players
end

NEX.Game.GetClosestObject = function(coords, modelFilter) return NEX.Game.GetClosestEntity(NEX.Game.GetObjects(), false, coords, modelFilter) end
NEX.Game.GetClosestPed = function(coords, modelFilter) return NEX.Game.GetClosestEntity(NEX.Game.GetPeds(true), false, coords, modelFilter) end
NEX.Game.GetClosestPlayer = function(coords) return NEX.Game.GetClosestEntity(NEX.Game.GetPlayers(true, true), true, coords, nil) end
NEX.Game.GetClosestVehicle = function(coords, modelFilter) return NEX.Game.GetClosestEntity(NEX.Game.GetVehicles(), false, coords, modelFilter) end
NEX.Game.GetPlayersInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(NEX.Game.GetPlayers(true, true), true, coords, maxDistance) end
NEX.Game.GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(NEX.Game.GetVehicles(), false, coords, maxDistance) end
NEX.Game.IsSpawnPointClear = function(coords, maxDistance) return #NEX.Game.GetVehiclesInArea(coords, maxDistance) == 0 end

NEX.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

NEX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

NEX.Game.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = NEX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = NEX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = NEX.Math.Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = NEX.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = NEX.Math.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = NEX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle)
		}
	else
		return
	end
end

NEX.Game.SetVehicleProperties = function(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end

NEX.Game.Utils.DrawText3D = function(coords, text, size, font)
	coords = vector3(coords.x, coords.y, coords.z)

	local camCoords = GetGameplayCamCoords()
	local distance = #(coords - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	SetDrawOrigin(coords, 0)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

NEX.UI.SendAlert = function(type, title, text, length, style)
	SendNUIMessage({
		type = type,
		title = title,
		text = text,
		length = length,
		style = style
	})
end

NEX.UI.PersistentHudText = function(action, id, type, title, text, style)
	if action:upper() == 'START' then
		SendNUIMessage({
			persist = action,
			id = id,
			type = type,
			title = title,
			text = text,
			style = style
		})
	elseif action:upper() == 'END' then
		SendNUIMessage({
			persist = action,
			id = id
		})
	end
end



-- NEX.ShowInventory = function()
-- 	local playerPed = PlayerPedId()
-- 	local elements, currentWeight = {}, 0

-- 	for k,v in pairs(NEX.PlayerData.accounts) do
-- 		if v.money > 0 then
-- 			local formattedMoney = _U('locale_currency', NEX.Math.GroupDigits(v.money))
-- 			local canDrop = v.name ~= 'bank'

-- 			table.insert(elements, {
-- 				label = ('%s: <span style="color:green;">%s</span>'):format(v.label, formattedMoney),
-- 				count = v.money,
-- 				type = 'item_account',
-- 				value = v.name,
-- 				usable = false,
-- 				rare = false,
-- 				canRemove = canDrop
-- 			})
-- 		end
-- 	end

-- 	for k,v in ipairs(NEX.PlayerData.inventory) do
-- 		if v.count > 0 then
-- 			currentWeight = currentWeight + (v.weight * v.count)

-- 			table.insert(elements, {
-- 				label = ('%s x%s'):format(v.label, v.count),
-- 				count = v.count,
-- 				type = 'item_standard',
-- 				value = v.name,
-- 				usable = v.usable,
-- 				rare = v.rare,
-- 				canRemove = v.canRemove
-- 			})
-- 		end
-- 	end

-- 	for k,v in ipairs(Config.Weapons) do
-- 		local weaponHash = GetHashKey(v.name)

-- 		if HasPedGotWeapon(playerPed, weaponHash, false) then
-- 			local ammo, label = GetAmmoInPedWeapon(playerPed, weaponHash)

-- 			if v.ammo then
-- 				label = ('%s - %s %s'):format(v.label, ammo, v.ammo.label)
-- 			else
-- 				label = v.label
-- 			end

-- 			table.insert(elements, {
-- 				label = label,
-- 				count = 1,
-- 				type = 'item_weapon',
-- 				value = v.name,
-- 				usable = false,
-- 				rare = false,
-- 				ammo = ammo,
-- 				canGiveAmmo = (v.ammo ~= nil),
-- 				canRemove = true
-- 			})
-- 		end
-- 	end

-- 	NEX.UI.Menu.CloseAll()

-- 	NEX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory', {
-- 		title    = _U('inventory', currentWeight, NEX.PlayerData.maxWeight),
-- 		align    = 'bottom-right',
-- 		elements = elements
-- 	}, function(data, menu)
-- 		menu.close()
-- 		local player, distance = NEX.Game.GetClosestPlayer()
-- 		elements = {}

-- 		if data.current.usable then
-- 			table.insert(elements, {label = _U('use'), action = 'use', type = data.current.type, value = data.current.value})
-- 		end

-- 		if data.current.canRemove then
-- 			if player ~= -1 and distance <= 3.0 then
-- 				table.insert(elements, {label = _U('give'), action = 'give', type = data.current.type, value = data.current.value})
-- 			end

-- 			table.insert(elements, {label = _U('remove'), action = 'remove', type = data.current.type, value = data.current.value})
-- 		end

-- 		if data.current.type == 'item_weapon' and data.current.canGiveAmmo and data.current.ammo > 0 and player ~= -1 and distance <= 3.0 then
-- 			table.insert(elements, {label = _U('giveammo'), action = 'give_ammo', type = data.current.type, value = data.current.value})
-- 		end

-- 		table.insert(elements, {label = _U('return'), action = 'return'})

-- 		NEX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_item', {
-- 			title    = data.current.label,
-- 			align    = 'bottom-right',
-- 			elements = elements,
-- 		}, function(data1, menu1)
-- 			local item, type = data1.current.value, data1.current.type

-- 			if data1.current.action == 'give' then
-- 				local playersNearby = NEX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

-- 				if #playersNearby > 0 then
-- 					local players = {}
-- 					elements = {}

-- 					for k,playerNearby in ipairs(playersNearby) do
-- 						players[GetPlayerServerId(playerNearby)] = true
-- 					end

-- 					NEX.TriggerServerCallback('nex:Core:getPlayerNames', function(returnedPlayers)
-- 						for playerId,playerName in pairs(returnedPlayers) do
-- 							table.insert(elements, {
-- 								label = playerName,
-- 								playerId = playerId
-- 							})
-- 						end

-- 						NEX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_item_to', {
-- 							title    = _U('give_to'),
-- 							align    = 'bottom-right',
-- 							elements = elements
-- 						}, function(data2, menu2)
-- 							local selectedPlayer, selectedPlayerId = GetPlayerFromServerId(data2.current.playerId), data2.current.playerId
-- 							playersNearby = NEX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
-- 							playersNearby = NEX.Table.Set(playersNearby)

-- 							if playersNearby[selectedPlayer] then
-- 								local selectedPlayerPed = GetPlayerPed(selectedPlayer)

-- 								if IsPedOnFoot(selectedPlayerPed) and not IsPedFalling(selectedPlayerPed) then
-- 									if type == 'item_weapon' then
-- 										TriggerServerEvent('nex:Core:giveInventoryItem', selectedPlayerId, type, item, nil)
-- 										menu2.close()
-- 										menu1.close()
-- 									else
-- 										NEX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
-- 											title = _U('amount')
-- 										}, function(data3, menu3)
-- 											local quantity = tonumber(data3.value)

-- 											if quantity and quantity > 0 and data.current.count >= quantity then
-- 												TriggerServerEvent('nex:Core:giveInventoryItem', selectedPlayerId, type, item, quantity)
-- 												menu3.close()
-- 												menu2.close()
-- 												menu1.close()
-- 											else
-- 												NEX.ShowNotification(_U('amount_invalid'))
-- 											end
-- 										end, function(data3, menu3)
-- 											menu3.close()
-- 										end)
-- 									end
-- 								else
-- 									NEX.ShowNotification(_U('in_vehicle'))
-- 								end
-- 							else
-- 								NEX.ShowNotification(_U('players_nearby'))
-- 								menu2.close()
-- 							end
-- 						end, function(data2, menu2)
-- 							menu2.close()
-- 						end)
-- 					end, players)
-- 				else
-- 					NEX.ShowNotification(_U('players_nearby'))
-- 				end
-- 			elseif data1.current.action == 'remove' then
-- 				if IsPedOnFoot(playerPed) and not IsPedFalling(playerPed) then
-- 					local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
-- 					NEX.Streaming.RequestAnimDict(dict)

-- 					if type == 'item_weapon' then
-- 						menu1.close()
-- 						TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
-- 						Citizen.Wait(1000)
-- 						TriggerServerEvent('nex:Core:removeInventoryItem', type, item)
-- 					else
-- 						NEX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
-- 							title = _U('amount')
-- 						}, function(data2, menu2)
-- 							local quantity = tonumber(data2.value)

-- 							if quantity and quantity > 0 and data.current.count >= quantity then
-- 								menu2.close()
-- 								menu1.close()
-- 								TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
-- 								Citizen.Wait(1000)
-- 								TriggerServerEvent('nex:Core:removeInventoryItem', type, item, quantity)
-- 							else
-- 								NEX.ShowNotification(_U('amount_invalid'))
-- 							end
-- 						end, function(data2, menu2)
-- 							menu2.close()
-- 						end)
-- 					end
-- 				end
-- 			elseif data1.current.action == 'use' then
-- 				TriggerServerEvent('nex:Core:useItem', item)
-- 			elseif data1.current.action == 'return' then
-- 				NEX.UI.Menu.CloseAll()
-- 				NEX.ShowInventory()
-- 			elseif data1.current.action == 'give_ammo' then
-- 				local closestPlayer, closestDistance = NEX.Game.GetClosestPlayer()
-- 				local closestPed = GetPlayerPed(closestPlayer)
-- 				local pedAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey(item))

-- 				if IsPedOnFoot(closestPed) and not IsPedFalling(closestPed) then
-- 					if closestPlayer ~= -1 and closestDistance < 3.0 then
-- 						if pedAmmo > 0 then
-- 							NEX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
-- 								title = _U('amountammo')
-- 							}, function(data2, menu2)
-- 								local quantity = tonumber(data2.value)

-- 								if quantity and quantity > 0 then
-- 									if pedAmmo >= quantity then
-- 										TriggerServerEvent('nex:Core:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_ammo', item, quantity)
-- 										menu2.close()
-- 										menu1.close()
-- 									else
-- 										NEX.ShowNotification(_U('noammo'))
-- 									end
-- 								else
-- 									NEX.ShowNotification(_U('amount_invalid'))
-- 								end
-- 							end, function(data2, menu2)
-- 								menu2.close()
-- 							end)
-- 						else
-- 							NEX.ShowNotification(_U('noammo'))
-- 						end
-- 					else
-- 						NEX.ShowNotification(_U('players_nearby'))
-- 					end
-- 				else
-- 					NEX.ShowNotification(_U('in_vehicle'))
-- 				end
-- 			end
-- 		end, function(data1, menu1)
-- 			NEX.UI.Menu.CloseAll()
-- 			NEX.ShowInventory()
-- 		end)
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

RegisterNetEvent('nex:Core:serverCallback')
AddEventHandler('nex:Core:serverCallback', function(requestId, ...)
	NEX.ServerCallbacks[requestId](...)
	NEX.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('nex:Core:showNotification')
AddEventHandler('nex:Core:showNotification', function(msg)
	NEX.ShowNotification(msg)
end)

RegisterNetEvent('nex:Core:showAdvancedNotification')
AddEventHandler('nex:Core:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	NEX.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('nex:Core:showHelpNotification')
AddEventHandler('nex:Core:showHelpNotification', function(msg, thisFrame, beep, duration)
	NEX.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

RegisterNetEvent('nex:Core:SendAlert')
AddEventHandler('nex:Core:SendAlert', function(data)
	NEX.UI.SendAlert(data.type, data.title, data.text, data.length, data.style)
end)

RegisterNetEvent('nex:Core::PersistentHudText')
AddEventHandler('nex:Core:PersistentHudText', function(data)
	NEX.UI.PersistentHudText(data.action, data.id, data.type, data.title, data.text, data.style)
end)


-- SetTimeout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local currTime = GetGameTimer()

		for i=1, #NEX.TimeoutCallbacks, 1 do
			if NEX.TimeoutCallbacks[i] then
				if currTime >= NEX.TimeoutCallbacks[i].time then
					NEX.TimeoutCallbacks[i].cb()
					NEX.TimeoutCallbacks[i] = nil
				end
			end
		end
	end
end)
