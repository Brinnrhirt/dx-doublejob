Config = {}
Config.Locale = 'en'
Config.SwitchCommand = 'switchjob'
Config.NotificationCommand = 'showjob'
Config.AdminCommand = 'setjob2'
Config.Timer = 1 -- In Seconds.
Config.Webhook = 'Your Webhook Here'
Config.ShowJob = true -- To make the command showjob workable

Config.AdminPermissions = { -- change this as your server ranking ( default are : superadmin | admin | moderator )
	'superadmin',
	'admin',
	--'mod',
}

--	Your Notification System
RegisterNetEvent('dx-secondjob:notification')
AddEventHandler('dx-secondjob:notification', function(type,msg)
--	Types used: (error | success)
--	print(msg)
--	exports['mythic_notify']:SendAlert(type,msg)
--  ESX.ShowNotification(msg)
    exports.dxNotify:SendNotification({                    
        text = '<b><i class="fas fa-bell"></i> NOTIFICACIÓN</span></b></br><span style="color: #a9a29f;">'..msg..'',
        type = type,
        timeout = 3000,
        layout = "centerRight"
    })
end)
