NEX = {}
NEX.Players = {}
NEX.UsableItemsCallbacks = {}
NEX.Items = {}
NEX.ServerCallbacks = {}
NEX.ClientCallbacks = {}
NEX.ServerEvents = {}
NEX.TimeoutCount = -1
NEX.CancelledTimeouts = {}
NEX.Pickups = {}
NEX.PickupId = 0
NEX.Jobs = {}
NEX.RegisteredCommands = {}
NEX.DevMode = true
NEX.RegisterResources = ConfigServer.SecureResources

NEX.Webhooks = ConfigServer.DiscordWebhooks

NEX.ReloadJobs = function()
	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
		for k,v in ipairs(jobs) do
			NEX.Jobs[v.name] = v
			NEX.Jobs[v.name].grades = {}
		end

		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if NEX.Jobs[v.job_name] then
					NEX.Jobs[v.job_name].grades[tostring(v.grade)] = v
				else
					print(('[NEX Nexus Version] [^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(v.job_name))
				end
			end

			for k2,v2 in pairs(NEX.Jobs) do
				if NEX.Table.SizeOf(v2.grades) == 0 then
					NEX.Jobs[v2.name] = nil
					print(('[NEX Nexus Version] [^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v2.name))
				end
			end
		end)
	end)
end

AddEventHandler('nexus:getNexusObject', function(cb)
	cb(NEX)
end)

function getSharedObject()
	return NEX
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			NEX.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	end)

	NEX.ReloadJobs()

	print('[NexCore] [^2INFO^7] NEX Nexus Version Initialized')
end)

RegisterServerEvent('nex:Core:clientLog')
AddEventHandler('nex:Core:clientLog', function(msg)
	if Config.EnableDebug then
		print(('[NexCore] [^2TRACE^7] %s^7'):format(msg))
	end
end)

RegisterServerEvent('nex:Core:triggerServerEvent') 
AddEventHandler('nex:Core:triggerServerEvent', function(name, requestId, ...) 
	local playerId = source
    NEX.TriggerServerEvent(name, playerId, requestId, ...) 
end)

RegisterServerEvent('nex:Core:triggerServerCallback')
AddEventHandler('nex:Core:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	NEX.TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('nex:Core:serverCallback', playerId, requestId, ...)
	end, ...)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.Wait(3000)
		for k, script in pairs(NEX.RegisterResources) do
			print('[NexCore] [^2INFO^7] Ensuring ' .. script .. '...')
			ExecuteCommand("ensure " .. script)
			Citizen.Wait(1000)
		end
	end
end)
