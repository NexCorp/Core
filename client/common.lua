AddEventHandler('nexus:getNexusObject', function(resourceName, cb)
	local data = {}
	Citizen.Wait(200)
	-- NEX.TriggerServerCallback('nexus:Core:CheckResourceName', function(accepted)
	-- 	if accepted then
	-- 		return cb(NEX)
	-- 	end
	-- end, resourceName)
	return cb(NEX)
end)

function getSharedObject()
	return NEX
end

RegisterNetEvent('nex:Core:triggerClientCallback')
AddEventHandler('nex:Core:triggerClientCallback', function(name, requestId, ...)
    NEX.TriggerClientCallback(name, function(...)
        TriggerServerEvent('nex:Core:clientCallback', requestId, ...)
    end, ...)
end)