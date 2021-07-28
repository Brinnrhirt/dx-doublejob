

ESX = nil
local webhook = Config.Webhook -- Notify in discord when someone changes job.

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('brinn_switchjob:getsecondjob')
AddEventHandler('brinn_switchjob:getsecondjob', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT job2, job2_grade FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.getIdentifier() }, function(result)

        if result[1] ~= nil and result[1].job2 ~= nil and result[1].job2_grade ~= nil then
                TriggerClientEvent('brinn_switchjob:returnsecondjob', _source, result[1].job2, result[1].job2_grade)
        else
            local msg = 'There was an error while loading your second job from database'
            local type = 'error'
            TriggerClientEvent('brinn-secondjob:notification',source,type,msg)
        end
    end)
end)

RegisterServerEvent('brinn_switchjob:setsecondjob')
AddEventHandler('brinn_switchjob:setsecondjob', function(job1, job1_grade, job2, job2_grade)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.setJob(job2, job2_grade)

    MySQL.Async.execute('UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier',
        { 
            ['@job2'] = job1,
            ['@job2_grade'] = job1_grade,
            ['@identifier'] = xPlayer.getIdentifier(),
        },
        function(affectedRows)
            if affectedRows == 0 then
                print('Player with steam ID: '..xPlayer.getIdentifier()..' had an issue while changing his job with saving his second job')
            end
        end
    )  

    SendDiscordWebhook(_source, job1, job1_grade, job2, job2_grade, 255)
end)

RegisterCommand(Config.NotificationCommand, function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.label
    local jobgrade = xPlayer.job.grade_label
    local msg = 'You are working as: ' .. job .. ' - ' .. jobgrade
    local type = 'error'
    TriggerClientEvent('brinn-secondjob:notification',source,type,msg)
end)



function SendDiscordWebhook(source, job1, job1_grade, job2, job2_grade, color)
    local xPlayer = ESX.GetPlayerFromId(source)
		local connect = {
			  {
				  ["color"] = color,
				  ["title"] = GetPlayerName(source)..', SteamID: '..xPlayer.getIdentifier(),
				  ["description"] = 'He change **from**: '..job1..' with rank: '..job1_grade..' **to**: '..job2.. ' with rank '..job2_grade,
				  ["footer"] = {
					  ["text"] = 'Comando /cambiarjob '..os.date("%Y/%m/%d %X"),
				  },
			  }
		  }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand(Config.AdminCommand, function(source, args, rawCommand)
    
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if havePermission(xPlayer)then
        if not args[1] or not args[2] or not args[3] then
            local msg = 'You did not enter all the fields'
            local type = 'error'
            TriggerClientEvent('brinn-secondjob:notification',source,type,msg)
        else
            local tPlayer = ESX.GetPlayerFromId(tonumber(args[1])) -- Tonumber in case somebody adds a paramter as a string, not a number
            if not tPlayer then
                local msg2 = 'The ID is not online on the server'
                local type2 = 'error'
                TriggerClientEvent('brinn-secondjob:notification',source,type2,msg2)
            else
                if ESX.DoesJobExist(args[2], tonumber(args[3])) then
                    MySQL.Async.execute('UPDATE users SET secojob2ndjob = @job2, job2_grade = @job2_grade WHERE identifier = @identifier',
                        { 
                            ['@job2'] = args[2],
                            ['@job2_grade'] = tonumber(args[3]),
                            ['@identifier'] = tPlayer.getIdentifier(),
                        },
                            function(affectedRows)
                                if affectedRows == 0 then
                                    local msg3 = 'There were some issues with changing the second job, please try it again'
                                    local type3 = 'error'
                                    TriggerClientEvent('brinn-secondjob:notification',source,type3,msg3)
                                    print('Player with steam ID: '..xPlayer.getIdentifier()..' had an issue while setting setjob to other player')
                                end
                            end
                    )
                else
                    local msg4 = 'Enterred job does not exist'
                    local type4 = 'error'
                    TriggerClientEvent('brinn-secondjob:notification',source,type4,msg4)
                end

            end
        end
    end
end, false)


function havePermission(xPlayer, exclude)	-- you can exclude rank(s) from having permission to specific commands 	[exclude only take tables]
	if exclude and type(exclude) ~= 'table' then exclude = nil end	-- will prevent from errors if you pass wrong argument
	local playerGroup = xPlayer.getGroup()
	for k,v in pairs(Config.AdminPermissions) do
		if v == playerGroup then
			if not exclude then
				return true
			else
				for a,b in pairs(exclude) do
					if b == v then
						return false
					end
				end
				return true
			end
		end
	end
	return false
end
