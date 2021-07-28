# Double JOB
Double JOB script for ESX made by Brinnrhirt

# Discord
Join here to report bugs or ask for help
https://discord.gg/tbZEuU2Zmm

# Features: 
* Configurable Timer and Command
* Added a Notification Command to showing the job you have (in case you don't have a hud for that), easily removable.
* Added an option for multiples notification systems, configurable in the config.lua
* Added a setjob2 command only for admins (grades configurable in the config.lua)

# Extras:
If you want to make the second job payable for your es_extended, you have to go to
es_extended/server/paycheck.lua
line 8 add:

local job2     = xPlayer.job2.grade_name
local salary2  = xPlayer.job2.grade_salary

and go to line 48 and add:
if salary2 > 0 then
				if job2 == 'unemployed2' then -- unemployed
				
				elseif Config.EnableSocietyPayouts then -- possibly a society
					TriggerEvent('esx_society:getSociety', xPlayer.job2.name, function (society)
						if society ~= nil then -- verified society
							TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function (account)
								if account.money >= salary then -- does the society money to pay its employees?
									xPlayer.addAccountMoney('bank',salary2)
									account.removeMoney(salary2)

									TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary2), 'CHAR_BANK_MAZE', 9)
								end
							end)
						else -- not a society
							xPlayer.addAccountMoney('bank',salary2)
							TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary2), 'CHAR_BANK_MAZE', 9)
						end
					end)
				else -- generic job
					xPlayer.addAccountMoney('bank',salary2)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, _U('bank'), _U('received_paycheck'), _U('received_salary', salary2), 'CHAR_BANK_MAZE', 9)
				end
end

* Screenshot: 
https://imgur.com/a/ekMeiqw

# Video preview:
https://streamable.com/0pg44c

# Download link:

https://forum.cfx.re/t/release-free-esx-double-job/4161544/5
