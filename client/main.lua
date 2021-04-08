local isPaused, isDead, pickups = false, false, {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('nex:Core:onPlayerJoined')
			break
		end
	end
end)

RegisterNetEvent('nex:Core:playerLoaded')
AddEventHandler('nex:Core:playerLoaded', function(playerData)
	NEX.PlayerLoaded = true
	NEX.PlayerData = playerData

	Citizen.Wait(500)

	-- check if player is coming from loading screen
	if GetEntityModel(PlayerPedId()) == GetHashKey('PLAYER_ZERO') then
		local defaultModel = GetHashKey('mp_m_freemode_01')
		RequestModel(defaultModel)

		while not HasModelLoaded(defaultModel) do
			Citizen.Wait(10)
		end

		SetPlayerModel(PlayerId(), defaultModel)
		SetPedDefaultComponentVariation(PlayerPedId())
		--SetPedRandomComponentVariation(PlayerPedId(), true)
		SetModelAsNoLongerNeeded(defaultModel)
	end

	AddTextEntry('FE_THDR_GTAO', '~w~~h~'.. Config.ServerName ..' ~m~| ~w~CharId: ~c~#'.. playerData.charId ..' ~m~| ~w~DB: ~c~#'.. playerData.dbId)

	-- freeze the player
	FreezeEntityPosition(PlayerPedId(), true)

	-- enable PVP
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)

	-- disable wanted level
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)

	if Config.EnableHud then
		for k,v in ipairs(playerData.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'
			NEX.UI.HUD.RegisterElement('account_' .. v.name, k, 0, accountTpl, {money = NEX.Math.GroupDigits(v.money)})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if playerData.job.grade_label == '' or playerData.job.grade_label == playerData.job.label then
			jobTpl = '<div>{{job_label}}</div>'
		end

		NEX.UI.HUD.RegisterElement('job', #playerData.accounts, 0, jobTpl, {
			job_label = playerData.job.label,
			grade_label = playerData.job.grade_label
		})
	end

	NEX.Game.Teleport(PlayerPedId(), {
		x = playerData.coords.x,
		y = playerData.coords.y,
		z = playerData.coords.z + 0.25,
		heading = playerData.coords.heading
	}, function()
		TriggerServerEvent('nex:Core:onPlayerSpawn')
		TriggerEvent('nex:Core:onPlayerSpawn')
		TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
		TriggerEvent('nex:Core:restoreLoadout')

		Citizen.Wait(4000)
		--ShutdownLoadingScreen()
		--ShutdownLoadingScreenNui()
		FreezeEntityPosition(PlayerPedId(), false)
		DoScreenFadeIn(10000)
		StartServerSyncLoops()
	end)

	TriggerEvent('nex:Core:loadingScreenOff')
end)

RegisterNetEvent('nex:Core:setMaxWeight')
AddEventHandler('nex:Core:setMaxWeight', function(newMaxWeight) NEX.PlayerData.maxWeight = newMaxWeight end)

AddEventHandler('nex:Core:onPlayerSpawn', function() isDead = false end)
AddEventHandler('nex:Core:onPlayerDeath', function() isDead = true end)

-- AddEventHandler('skinchanger:modelLoaded', function()
-- 	while not NEX.PlayerLoaded do
-- 		Citizen.Wait(100)
-- 	end

-- 	TriggerEvent('nex:Core:restoreLoadout')
-- end)

AddEventHandler('nex:Core:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}
	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(NEX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for k2,v2 in ipairs(v.components) do
			local componentHash = NEX.GetWeaponComponent(weaponName, v2).hash
			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, v.ammo)
			ammoTypes[ammoType] = true
		end
	end
end)

RegisterNetEvent('nex:Core:setAccountMoney')
AddEventHandler('nex:Core:setAccountMoney', function(account)
	for k,v in ipairs(NEX.PlayerData.accounts) do
		if v.name == account.name then
			NEX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		NEX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = NEX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('nex:Core:addInventoryItem')
AddEventHandler('nex:Core:addInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(NEX.PlayerData.inventory) do
		if v.name == item then
			NEX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			NEX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		NEX.UI.ShowInventoryItemNotification(true, item, count)
	end

	-- if NEX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
	-- 	NEX.ShowInventory()
	-- end
end)

RegisterNetEvent('nex:Core:removeInventoryItem')
AddEventHandler('nex:Core:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(NEX.PlayerData.inventory) do
		if v.name == item then
			NEX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			NEX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		NEX.UI.ShowInventoryItemNotification(false, item, count)
	end

	-- if NEX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
	-- 	NEX.ShowInventory()
	-- end
end)

RegisterNetEvent('nex:Core:setJob')
AddEventHandler('nex:Core:setJob', function(job)
	NEX.PlayerData.job = job
end)

RegisterNetEvent('nex:Core:addWeapon')
AddEventHandler('nex:Core:addWeapon', function(weaponName, ammo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, ammo, false, false)
end)

RegisterNetEvent('nex:Core:addWeaponComponent')
AddEventHandler('nex:Core:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = NEX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('nex:Core:setWeaponAmmo')
AddEventHandler('nex:Core:setWeaponAmmo', function(weaponName, weaponAmmo)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedAmmo(playerPed, weaponHash, weaponAmmo)
end)

RegisterNetEvent('nex:Core:setWeaponTint')
AddEventHandler('nex:Core:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
end)

RegisterNetEvent('nex:Core:removeWeapon')
AddEventHandler('nex:Core:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)
	SetPedAmmo(playerPed, weaponHash, 0) -- remove leftover ammo
end)

RegisterNetEvent('nex:Core:removeWeaponComponent')
AddEventHandler('nex:Core:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = NEX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('nex:Core:playFrontEndSound')
AddEventHandler('nex:Core:playFrontEndSound', function(sound, soundset)
	PlaySoundFrontend(-1, sound, soundset, 1)
end)

RegisterNetEvent('nex:Core:teleport')
AddEventHandler('nex:Core:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	NEX.Game.Teleport(playerPed, coords)
end)

-- RegisterNetEvent('nex:Core:setJob')
-- AddEventHandler('nex:Core:setJob', function(job)
-- 	if Config.EnableHud then
-- 		NEX.UI.HUD.UpdateElement('job', {
-- 			job_label = job.label,
-- 			grade_label = job.grade_label
-- 		})
-- 	end
-- end)

RegisterNetEvent('nex:Core:spawnVehicle')
AddEventHandler('nex:Core:spawnVehicle', function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		NEX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	else
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Invalid vehicle model.'}})
	end
end)

RegisterNetEvent('nex:Core:createPickup')
AddEventHandler('nex:Core:createPickup', function(pickupId, label, coords, type, name, components, tintIndex)
	local function setObjectProperties(object)
		SetEntityAsMissionEntity(object, true, false)
		PlaceObjectOnGroundProperly(object)
		FreezeEntityPosition(object, true)
		SetEntityCollision(object, false, true)

		pickups[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = vector3(coords.x, coords.y, coords.z)
		}
	end

	if type == 'item_weapon' then
		local weaponHash = GetHashKey(name)
		NEX.Streaming.RequestWeaponAsset(weaponHash)
		local pickupObject = CreateWeaponObject(weaponHash, 50, coords.x, coords.y, coords.z, true, 1.0, 0)
		SetWeaponObjectTintIndex(pickupObject, tintIndex)

		for k,v in ipairs(components) do
			local component = NEX.GetWeaponComponent(name, v)
			GiveWeaponComponentToWeaponObject(pickupObject, component.hash)
		end

		setObjectProperties(pickupObject)
	else
		NEX.Game.SpawnLocalObject('prop_money_bag_01', coords, setObjectProperties)
	end
end)

RegisterNetEvent('nex:Core:createMissingPickups')
AddEventHandler('nex:Core:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('nex:Core:createPickup', pickupId, pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('nex:Core:registerSuggestions')
AddEventHandler('nex:Core:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('nex:Core:removePickup')
AddEventHandler('nex:Core:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		NEX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('nex:Core:deleteVehicle')
AddEventHandler('nex:Core:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = NEX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				NEX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = NEX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			NEX.Game.DeleteVehicle(vehicle)
		end
	end
end)

RegisterNetEvent("nex:Core:runSpawnCommand")
AddEventHandler("nex:Core:runSpawnCommand", function(model, livery)
    Citizen.CreateThread(function()

        local hash = GetHashKey(model)

        if not IsModelAVehicle(hash) then return end
        if not IsModelInCdimage(hash) or not IsModelValid(hash) then return end
        
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(0)
        end

        local localped = PlayerPedId()
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 5.0, 0.0)

        local heading = GetEntityHeading(localped)
        local vehicle = CreateVehicle(hash, coords, heading, true, false)

        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, 3, false)
        SetVehicleMod(vehicle, 12, 2, false)
        SetVehicleMod(vehicle, 13, 2, false)
        SetVehicleMod(vehicle, 15, 3, false)
        SetVehicleMod(vehicle, 16, 4, false)


        if model == "pol1" then
            SetVehicleExtra(vehicle, 5, 0)
        end

        if model == "police" then
            SetVehicleWheelType(vehicle, 2)
            SetVehicleMod(vehicle, 23, 10, false)
            SetVehicleColours(vehicle, 0, false)
            SetVehicleExtraColours(vehicle, 0, false)
        end

        if model == "pol7" then
            SetVehicleColours(vehicle,0)
            SetVehicleExtraColours(vehicle,0)
        end

        if model == "pol5" or model == "pol6" then
            SetVehicleExtra(vehicle, 1, -1)
        end

        SetModelAsNoLongerNeeded(hash)
        
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleWindowTint(vehicle, 0)

        if livery ~= nil then
            SetVehicleLivery(vehicle, tonumber(livery))
        end
    end)
end)

-- Pause menu disables HUD display
if Config.EnableHud then
	-- Citizen.CreateThread(function()
	-- 	-- while true do
	-- 	-- 	Citizen.Wait(300)

	-- 	-- 	if IsPauseMenuActive() and not isPaused then
	-- 	-- 		isPaused = true
	-- 	-- 		NEX.UI.HUD.SetDisplay(0.0)
	-- 	-- 	elseif not IsPauseMenuActive() and isPaused then
	-- 	-- 		isPaused = false
	-- 	-- 		NEX.UI.HUD.SetDisplay(1.0)
	-- 	-- 	end
	-- 	-- end
	-- end)

	AddEventHandler('nex:Core:loadingScreenOff', function()
		NEX.UI.HUD.SetDisplay(1.0)
	end)
end

function StartServerSyncLoops()
	-- keep track of ammo
	-- Citizen.CreateThread(function()
	-- 	while true do
	-- 		Citizen.Wait(5)

	-- 		if isDead then
	-- 			Citizen.Wait(500)
	-- 		else
	-- 			local playerPed = PlayerPedId()

	-- 			if IsPedShooting(playerPed) then
	-- 				local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
	-- 				local weapon = NEX.GetWeaponFromHash(weaponHash)

	-- 				if weapon then
	-- 					local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
	-- 					TriggerServerEvent('nex:Core:updateWeaponAmmo', weapon.name, ammoCount)
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end)

	-- sync current player coords with server
	Citizen.CreateThread(function()
		local previousCoords = vector3(NEX.PlayerData.coords.x, NEX.PlayerData.coords.y, NEX.PlayerData.coords.z)

		while true do
			Citizen.Wait(5000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)

				if distance > 1 then
					previousCoords = playerCoords
					local playerHeading = NEX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = NEX.Math.Round(playerCoords.x, 1), y = NEX.Math.Round(playerCoords.y, 1), z = NEX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('nex:Core:updateCoords', formattedCoords)
				end
			end
		end
	end)
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		if IsControlJustReleased(0, 289) then
-- 			if IsInputDisabled(0) and not isDead and not NEX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
-- 				NEX.ShowInventory()
-- 			end
-- 		end
-- 	end
-- end)

-- Pickups
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(5)
-- 		local playerPed = PlayerPedId()
-- 		local playerCoords, letSleep = GetEntityCoords(playerPed), true
-- 		local closestPlayer, closestDistance = NEX.Game.GetClosestPlayer(playerCoords)

-- 		for pickupId,pickup in pairs(pickups) do
-- 			local distance = #(playerCoords - pickup.coords)

-- 			if distance < 5 then
-- 				local label = pickup.label
-- 				letSleep = false

-- 				if distance < 1 then
-- 					if IsControlJustReleased(0, 38) then
-- 						if IsPedOnFoot(playerPed) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
-- 							pickup.inRange = true

-- 							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
-- 							NEX.Streaming.RequestAnimDict(dict)
-- 							TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
-- 							Citizen.Wait(1000)
-- 							-- Check here for pickups system work with Nex Core
-- 							TriggerServerEvent('nex:Core:onPickup', pickupId)
-- 							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
-- 						end
-- 					end

-- 					label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
-- 				end

-- 				NEX.Game.Utils.DrawText3D({
-- 					x = pickup.coords.x,
-- 					y = pickup.coords.y,
-- 					z = pickup.coords.z + 0.25
-- 				}, label, 1.2, 2)
-- 			elseif pickup.inRange then
-- 				pickup.inRange = false
-- 			end
-- 		end

-- 		if letSleep then
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)


-- [[ NATIVE TEXTS ]]
AddTextEntry("PM_PANE_LEAVE", "~b~Log off ~w~from ~r~"..Config.ServerName)
AddTextEntry("PM_PANE_QUIT", "~w~Get out of ~o~FiveM")