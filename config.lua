Config = {}

Config.SwitchCommand = 'switchjob'
Config.NotificationCommand = 'showjob'
Config.Timer = 1 -- In Seconds.
Config.Webhook = 'Your Webhook Here'

--	Your Notification System
RegisterNetEvent('brinn-secondjob:notification')
AddEventHandler('brinn-secondjob:notification', function(type,msg)
--	Types used: (error | success)
--	print(msg)
--	exports['mythic_notify']:SendAlert(type,msg)
    ESX.ShowNotification(msg)
end)
