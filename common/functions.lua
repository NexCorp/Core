local Charset = {}
NEX.Intervals 				  = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

NEX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return NEX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

NEX.GetConfig = function()
	return Config
end

NEX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return k, v
		end
	end
end

NEX.GetWeaponFromHash = function(weaponHash)
	for k,v in ipairs(Config.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

NEX.GetWeaponList = function()
	return Config.Weapons
end

NEX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return v.label
		end
	end
end

NEX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = Config.Weapons

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			for k2,v2 in ipairs(v.components) do
				if v2.name == weaponComponent then
					return v2
				end
			end
		end
	end
end

NEX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. NEX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

NEX.Round = function(value, numDecimalPlaces)
	return NEX.Math.Round(value, numDecimalPlaces)
end

NEX.ClearInterval = function(ID)
    if NEX.Intervals[ID] ~= nil then
        NEX.Intervals[ID] = nil
    end
end

NEX.SetInterval = function(ms, cb)
	local i = 0
    while NEX.Intervals[i] ~= nil do i = i + 1 end
    NEX.Intervals[i] = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(ms)
            if NEX.Intervals[i] ~= nil then
                cb()
            else
                break
            end
        end
    end)
    return i
end