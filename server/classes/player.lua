function CreateExtendedPlayer(dbId, playerId, charId, identifier, group, accounts, inventory, weight, job, job2, loadout, name, coords, firstname, lastname, dob, height, unlockCharacters, tutorial, vip,  sex, jobInv)
	local self = {}
	
	self.dbId 		= dbId
	self.charId 	= charId
	self.accounts 	= accounts
	self.coords 	= coords
	self.group 		= group
	self.identifier = identifier
	self.inventory 	= inventory
	self.job 		= job
	self.job2 		= job2
	self.loadout 	= loadout
	self.name 		= name
	self.playerId 	= playerId
	self.source 	= playerId
	self.variables 	= {}
	self.weight 	= weight
	self.maxWeight 	= Config.MaxWeight
	self.firstname  = firstname
	self.lastname   = lastname
	self.dob        = dob
	self.height     = height
	self.tutorial   = tutorial
	self.vip		= vip
	self.sex		= sex
	self.jobInvitation = jobInv

	self.unlockCharacters 	= unlockCharacters or 0
	self.switchState 		= false
	self.readyForPlay 		= false

	ExecuteCommand(('add_principal identifier.license:%s group.%s'):format(self.identifier, self.group))

	self.setVIP = function(value)
		local vipId = tonumber(value)
		if vipId >= 0 and vipId <= 6 then
			self.vip = vipId
		else
			self.vip = 0
		end
	end

	self.getVip = function()
		return self.vip
	end

	self.isVip = function()
		return self.vip
	end

	self.isTutorialPassed = function()
		return self.tutorial
	end

	self.setTutorialStatus = function(value)
		self.tutorial = value
	end

	self.getDBId = function()
		return self.dbId
	end

	self.getUnlockedCharacters = function()
		return self.unlockCharacters
	end

	self.setUnlockedCharacters = function(value)
		self.unlockCharacters = value
	end

	self.addUnlockedCharacters = function(value)
		self.unlockCharacters = self.unlockCharacters + value
	end

	self.removeUnlockedCharacters = function(value)
		self.unlockCharacters = self.unlockCharacters- 1
	end

	self.getCharacterId = function()
		return self.charId
	end

	self.setCharacterId = function(charId)
		self.charId =  charId
	end

	self.setGameData = function()
		return {

			setName = function(firstname, lastname)
				self.firstItem = firstItem
				self.lastname  = lastname
			end,

			setFirstname = function(newValue)
				self.firstname = newValue
			end,

			setLastname = function(newValue)
				self.lastname = newValue
			end,
			
			setDob = function(newValue)
				self.dob = newValue
			end,

			setHeight = function(newValue)
				self.height = newValue
			end,

			setSex = function(newValue)
				self.sex = newValue
			end
		}
	end

	self.getGameData = function()
		return {
			getFirstname = function()
				return self.firstname
			end,

			getLastname = function()
				return self.lastname
			end,

			getFullName = function()
				return self.firstname .. " " .. self.lastname
			end,
			
			getDob = function()
				return {
					getFullDate = function()
						return self.dob
					end,

					getAge = function()
						return 0
					end
				}
			end,

			getHeight = function()
				return self.height
			end,

			getSex = function()
				return self.sex
			end
		}
	end

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.PrepareForCharacterSwitching = function()
		self.switchState = true
		self.triggerEvent("nex:characters:prepareForSwitching")
	end

	self.SetPlayerSwitchState = function(state)
		self.switchState = state
	end

	self.IsPlayerSwitchInProgress = function()
		return self.switchState
	end

	self.IsPlayerReadyForPlay = function()
		return self.readyForPlay
	end

	self.SetPlayerReadyForPlay = function(toggle)
		self.readyForPlay = toggle
	end

	self.setCoords = function(coords, heading)
		self.updateCoords(coords, heading)
		self.triggerEvent('nex:Core:teleport', coords)
	end

	self.updateCoords = function(coords, heading)
		self.coords = {x = NEX.Math.Round(coords.x, 1), y = NEX.Math.Round(coords.y, 1), z = NEX.Math.Round(coords.z, 1), heading = NEX.Math.Round(heading or 0.0, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.setPoints = function(money)
		money = NEX.Math.Round(money)
		self.setAccountMoney('points', money)
	end

	self.getPoints = function()
		return self.getAccount('points').money
	end

	self.addPoints = function(money)
		money = NEX.Math.Round(money)
		self.addAccountMoney('points', money)
	end

	self.removePoints = function(money)
		money = NEX.Math.Round(money)
		self.removeAccountMoney('points', money)
	end

	self.setMoney = function(money)
		money = NEX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		return self.getAccount('money').money
	end

	self.addMoney = function(money)
		money = NEX.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	self.removeMoney = function(money)
		money = NEX.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

	self.getBankMoney = function()
		return self.getAccount('bank').money
	end

	self.addBankMoney = function(money)
		money = NEX.Math.Round(money)
		self.addAccountMoney('bank', money)
	end

	self.removeBankMoney = function(money)
		money = NEX.Math.Round(money)
		self.removeAccountMoney('bank', money)
	end


	self.getBlackMoney = function()
		return self.getAccount('black_money').money
	end

	self.addBlackMoney = function(money)
		money = NEX.Math.Round(money)
		self.addAccountMoney('black_money', money)
	end

	self.removeBlackMoney = function(money)
		money = NEX.Math.Round(money)
		self.removeAccountMoney('black_money', money)
	end


	self.getIdentifier = function()
		return self.identifier
	end

	self.setGroup = function(newGroup)
		ExecuteCommand(('remove_principal identifier.license:%s group.%s'):format(self.identifier, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.license:%s group.%s'):format(self.identifier, self.group))
	end

	self.getGroup = function()
		return self.group
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getJob = function()
		return self.job
	end

	self.getJob2 = function()
		return self.job2
	end

	self.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							table.insert(components, component)
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = NEX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('nex:Core:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + NEX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('nex:Core:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - NEX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('nex:Core:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		return
	end

	self.addInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = NEX.Math.Round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			TriggerEvent('nex:Core:onAddInventoryItem', self.source, item.name, item.count)
			self.triggerEvent('nex:Core:addInventoryItem', item.name, item.count)
		end
	end

	self.removeInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = NEX.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				TriggerEvent('nex:Core:onRemoveInventoryItem', self.source, item.name, item.count)
				self.triggerEvent('nex:Core:removeInventoryItem', item.name, item.count)
			end
		end
	end

	self.playFrontEndSound = function(sound, soundset)
		self.triggerEvent('nex:Core:playFrontEndSound', sound, soundset)
	end

	self.setInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = NEX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, NEX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = NEX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = NEX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('nex:Core:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(category, job, grade)
		if category > 0 and category < 3 then 
			grade = tostring(grade)
			local lastJob = json.decode(json.encode(self.job))

			if NEX.DoesJobExist(job, grade) then
				local jobObject, gradeObject = NEX.Jobs[job], NEX.Jobs[job].grades[grade]

				if category == 1 then
					self.job.id    = jobObject.id
					self.job.name  = jobObject.name
					self.job.label = jobObject.label

					self.job.grade        = tonumber(grade)
					self.job.grade_name   = gradeObject.name
					self.job.grade_label  = gradeObject.label
					self.job.grade_salary = gradeObject.salary
				else
					self.job2.id    = jobObject.id
					self.job2.name  = jobObject.name
					self.job2.label = jobObject.label

					self.job2.grade        = tonumber(grade)
					self.job2.grade_name   = gradeObject.name
					self.job2.grade_label  = gradeObject.label
					self.job2.grade_salary = gradeObject.salary
				end

				TriggerEvent('nex:Core:setJob', self.source, self.job, lastJob)
				self.triggerEvent('nex:Core:setJob', self.job) 
			else
				print(('[NexCore] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
			end
		else
			print(('[NexCore] [^3WARNING^7] INVALID JOB ID IN .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.addWeapon = function(weaponName, ammo)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = NEX.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			self.triggerEvent('nex:Core:addWeapon', weaponName, ammo)
			self.triggerEvent('nex:Core:addInventoryItem', weaponLabel, false, true)
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = NEX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					self.triggerEvent('nex:Core:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('nex:Core:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('nex:Core:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	self.setWeaponTint = function(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = NEX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('nex:Core:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('nex:Core:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	self.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.removeWeapon = function(weaponName)
		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('nex:Core:removeWeapon', weaponName)
			self.triggerEvent('nex:Core:removeInventoryItem', weaponLabel, false, true)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = NEX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('nex:Core:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('nex:Core:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('nex:Core:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	self.showNotification = function(msg)
		self.triggerEvent('nex:Core:showNotification', msg)
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('nex:Core:showHelpNotification', msg, thisFrame, beep, duration)
	end

	self.sendAlert = function(data)
		self.triggerEvent('nex:Core:SendAlert', data)
	end
	
	self.PersistentHudText = function(data)
		self.triggerEvent('nex:Core::PersistentHudText')
	end

	return self
end
