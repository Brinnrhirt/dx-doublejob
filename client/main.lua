ESX = nil
local job1, job2
local job1_grade, job2_grade
local timer = 0
local sleepThread = 1000
local allowCommand = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand(Config.SwitchCommand, function (src, args, raw)
    if timer == 0 and allowCommand then
        TriggerServerEvent('dx-secondjob:getsecondjob')
        timer = Config.Timer
        allowCommand = false
    else
        local msg1 = _U('timer', timer)
		local type = 'error'
        TriggerEvent('dx-secondjob:notification',type,msg1) 
    end
end, false)

RegisterNetEvent('dx-secondjob:returnsecondjob')
AddEventHandler('dx-secondjob:returnsecondjob', function(job2, job2_grade)
    job2 = job2
    job2_grade = job2_grade
    job1 = ESX.PlayerData.job.name
    job1_grade = ESX.PlayerData.job.grade
    TriggerServerEvent('dx-secondjob:setsecondjob', job1, job1_grade, job2, job2_grade)
	local type = 'success'
    TriggerEvent('dx-secondjob:notification',type,_U('switch_job')) 
    Wait(5000)
end)

Citizen.CreateThread(function()
    
    while true do
        if timer > 1 then
            timer = timer-1  
        elseif timer == 1 then
            allowCommand = true
            timer = 0
        end
        Citizen.Wait(sleepThread)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
