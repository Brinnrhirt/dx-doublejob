ESX = nil
local job1, secondjob
local job1_grade, secondjob_grade
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

RegisterCommand(Config.Command, function (src, args, raw)
    if timer == 0 and allowCommand then
        TriggerServerEvent('brinn-secondjob:getsecondjob')
        timer = Config.Timer
        allowCommand = false
    else
        local msg1 = 'You have to wait'..timer..' to change your job again'
		local type = 'error'
        TriggerEvent('brinn-secondjob:notification',type,msg1) 
    end
end, false)

RegisterNetEvent('brinn-secondjob:returnsecondjob')
AddEventHandler('brinn-secondjob:returnsecondjob', function(secondjob, secondjob_grade)
    secondjob = secondjob
    secondjob_grade = secondjob_grade
    job1 = ESX.PlayerData.job.name
    job1_grade = ESX.PlayerData.job.grade
    TriggerServerEvent('brinn-secondjob:setsecondjob', job1, job1_grade, secondjob, secondjob_grade)
    local msg1 = 'You switch jobs.'
    local msg2 = 'Your actual job its: '..ESX.PlayerData.job.label..' and your rank its: '..ESX.PlayerData.job.grade_label
	local type = 'success'
    TriggerEvent('brinn-secondjob:notification',type,msg1) 
    Wait(5000)
    TriggerEvent('brinn-secondjob:notification',type,msg2)
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