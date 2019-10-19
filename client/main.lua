local showJob = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(1000)
  if PlayerData == nil or PlayerData.job == nil then
	  	PlayerData = ESX.GetPlayerData()
  end
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

Citizen.CreateThread(function()
  while true do
		Citizen.Wait(20000)
		showJob = 'none'
		if(PlayerData ~= nil) and (PlayerData.job.name == 'police') then
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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(6000)
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
      local formatted = month..'/'..dayOfMonth..'/2019'..' '..hour..':'..minute..type
      SendNUIMessage({
        action  = 'changeTime',
        data = formatted
      })
    end
    Citizen.Wait(8000)
  end
end)