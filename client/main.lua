local showJob = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function formatTime(data)
	for i=1, #data do
		local v = data[i]
		if v <= 9 then
			data[i] = "0"..v
		end
	end
	return data
end

local axonOn = true

Citizen.CreateThread(function()
  while true do
		Citizen.Wait(20000)
		showJob = 'none'
		if(PlayerData ~= nil) and (PlayerData.job.name == 'police') and axonOn == true then
			ESX.TriggerServerCallback('esx_vhsText:getName', function(name)
				rank = Config.Ranks[PlayerData.job.grade_name]
				if rank then
					showJob = rank..' '..name
				end
				SendNUIMessage({
					action  = 'changeJob',
					data = showJob
				})
			end)
		else
			SendNUIMessage({
				action  = 'changeJob',
				data = 'none'
			})
		end
	end
end)

RegisterCommand('axon', function(source, args)
	if (PlayerData.job.name == 'police') then
		if axonOn then
			axonOn = false
			exports['mythic_notify']:DoCustomHudText('error', 'Preparing To Shut Down Axon. <br /> Please wait a few seconds.', 10000)
		else
			axonOn = true
			exports['mythic_notify']:DoCustomHudText('success', 'Preparing Axon Device Startup <br /> Please wait a few seconds.', 10000)
		end
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if (PlayerData ~= nil) and (PlayerData.job.name == 'police') then
      hour = GetClockHours()
      minute = GetClockMinutes()
      month = GetClockMonth()
			dayOfMonth = GetClockDayOfMonth()
			month = month + 1

      local type = ' AM'
      if hour == 0 or hour == 24 then
        hour = 12
        type = ' AM'
      elseif hour >= 13 then
        hour = hour - 12
        type = ' PM'
      end

			minute, month, dayOfMonth, hour = table.unpack(formatTime({minute, month, dayOfMonth, hour}))
      local formatted = month..'/'..dayOfMonth..'/2020'..' '..hour..':'..minute..type
      SendNUIMessage({
        action  = 'changeTime',
        data = formatted
      })
    end
    Citizen.Wait(1000)
  end
end)
