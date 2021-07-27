

ESX = nil
local webhook = Config.Webhook -- Notify in discord when someone changes job.

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('brinn_switchjob:getsecondjob')
AddEventHandler('brinn_switchjob:getsecondjob', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT secondjob, secondjob_grade FROM users WHERE identifier = @identifier', { ['@identifier'] = xPlayer.getIdentifier() }, function(result)

        if result[1] ~= nil and result[1].secondjob ~= nil and result[1].secondjob_grade ~= nil then
                TriggerClientEvent('brinn_switchjob:returnsecondjob', _source, result[1].secondjob, result[1].secondjob_grade)
        else
            local msg = 'There was an error while loading your second job from database'
            local type = 'error'
            TriggerClientEvent('brinn-secondjob:notification',source,type,msg)
        end
    end)
end)

RegisterServerEvent('brinn_switchjob:setsecondjob')
AddEventHandler('brinn_switchjob:setsecondjob', function(job1, job1_grade, secondjob, secondjob_grade)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.setJob(secondjob, secondjob_grade)

    MySQL.Async.execute('UPDATE users SET secondjob = @secondjob, secondjob_grade = @secondjob_grade WHERE identifier = @identifier',
        { 
            ['@secondjob'] = job1,
            ['@secondjob_grade'] = job1_grade,
            ['@identifier'] = xPlayer.getIdentifier(),
        },
        function(affectedRows)
            if affectedRows == 0 then
                print('Player with steam ID: '..xPlayer.getIdentifier()..' had an issue while changing his job with saving his secondjob')
            end
        end
    )  

    SendDiscordWebhook(_source, job1, job1_grade, secondjob, secondjob_grade, 255)
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



function SendDiscordWebhook(source, job1, job1_grade, secondjob, secondjob_grade, color)
    local xPlayer = ESX.GetPlayerFromId(source)
		local connect = {
			  {
				  ["color"] = color,
				  ["title"] = GetPlayerName(source)..', SteamID: '..xPlayer.getIdentifier(),
				  ["description"] = 'He change **from**: '..job1..' with rank: '..job1_grade..' **to**: '..secondjob.. ' with rank '..secondjob_grade,
				  ["footer"] = {
					  ["text"] = 'Comando /cambiarjob '..os.date("%Y/%m/%d %X"),
				  },
			  }
		  }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end