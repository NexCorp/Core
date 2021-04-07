NEX.StartPayCheck = function()
	function payCheck()
		local xPlayers = NEX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = NEX.GetPlayerFromId(xPlayers[i])
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			if xPlayer.IsPlayerReadyForPlay() then
				-- xPlayer.addAccountMoney('points', 1)
				-- TriggerClientEvent('DoLongHudText', xPlayer.source, 'Recibiste 1 GL-Points.', 2)
				if salary > 0 then
					if job == 'unemployed' then -- unemployed
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_help', salary), 'CHAR_BANK_MAZE', 9)
					elseif Config.EnableSocietyPayouts then -- possibly a society
						TriggerEvent('esx_society:getSociety', xPlayer.job.name, function (society)
							if society ~= nil then -- verified society
								TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
									if account.money >= salary then -- does the society money to pay its employees?
										xPlayer.addAccountMoney('bank', salary)
										account.removeMoney(salary)

										TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
									else
										TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), '', _U('company_nomoney'), 'CHAR_BANK_MAZE', 1)
									end
								end)
							else -- not a society
								xPlayer.addAccountMoney('bank', salary)
								TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary), 'CHAR_BANK_MAZE', 9)
							end
						end)
					else -- factions
						
						local isVip = xPlayer.isVip()
						local bonus = 0
						local iva = 0

						if Config.EnableTax then
							iva = salary * Config.Tax
						end

						if string.match(job, "off") then
							xPlayer.addAccountMoney('bank', salary)
							TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary, 0, 0), 'CHAR_BANK_MAZE', 9)
						else
							if isVip > 0 then
								if Config.VipTiers[isVip] then
									bonus = salary * Config.VipTiers[isVip]
								else
									bonus = Config.VipTierDefault
								end
							end

							local finalSalary = ((salary + bonus)-iva)
							xPlayer.addAccountMoney('bank', finalSalary)

							TriggerClientEvent('nex:Core:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', finalSalary, iva, bonus), 'CHAR_BANK_MAZE', 9)
							
							if Config.SendTaxToMazeBankSociety then
								TriggerEvent('nex:Factions:Accounts:getSharedAccount', 'society_mazebank', function(account)
									if account ~= nil then
										account.addMoney(iva)
									end
								end)
							end
						end
					end
				end
			end
		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end
