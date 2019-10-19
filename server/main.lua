ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT firstname,lastname FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],
		}
	else
		return nil
	end
end


ESX.RegisterServerCallback('esx_vhsText:getName', function(source, cb)
    local name = getIdentity(source)
    cb(string.upper(name.firstname .. " " .. name.lastname))
end)